local check_if_dot_file = function()
  local dot_cmd = "Yit ls-files " .. vim.api.nvim_buf_get_name(0)
  local dot_file = vim.api.nvim_exec(dot_cmd, true)
  if #dot_file ~= 0 then
    return true
  end
  return false
end

local git_commit_edit_func = function(selected)
  local commit_hash = selected[1]:match("[^ ]+")
  local git_cmd = "Gedit"
  if check_if_dot_file() then
    git_cmd = "Yedit"
  end
  local cmd = "vsp | " .. git_cmd .. " " .. commit_hash .. ":%"
  vim.cmd(cmd)
end

local git_commit_diff_func = function(selected)
  local commit_hash = selected[1]:match("[^ ]+")
  local git_cmd = "Gvdiffsplit"
  if check_if_dot_file() then
    git_cmd = "Yvdiffsplit"
  end
  local cmd = git_cmd .. " " .. commit_hash .. ":%"
  vim.cmd(cmd)
end

return {
  setup = function()
    local fzf_lua = require("fzf-lua")

    -- return first matching highlight or nil
    local function hl_match(t)
      for _, h in ipairs(t) do
        -- `vim.api.nvim_get_hl_by_name` is deprecated since v0.9.0
        if vim.api.nvim_get_hl then
          local ok, hl = pcall(vim.api.nvim_get_hl, 0, { name = h, link = false })
          if ok and type(hl) == "table" and (hl.fg or hl.bg) then
            return h
          end
        else
          local ok, hl = pcall(vim.api.nvim_get_hl_by_name, h, true)
          -- must have at least bg or fg, otherwise this returns
          -- succesffully for cleared highlights (on colorscheme switch)
          if ok and (hl.foreground or hl.background) then
            return h
          end
        end
      end
    end

    local fzf_colors = function(opts)
      local binary = opts and opts.fzf_bin
      local colors = {
        ["fg"] = { "fg", "Normal" },
        ["bg"] = { "bg", "Normal" },
        ["hl"] = { "fg", "Question" },
        ["fg+"] = { "fg", "Normal" },
        ["bg+"] = { "bg", hl_match({ "NightflyVisual", "CursorLine" }) },
        ["hl+"] = { "fg", "CmpItemKindOperator" },
        ["info"] = { "fg", hl_match({ "NightflyPeach", "WarningMsg" }) },
        -- ["prompt"] = { "fg", "SpecialKey" },
        ["pointer"] = { "fg", "DiagnosticError" },
        ["marker"] = { "fg", "DiagnosticError" },
        ["spinner"] = { "fg", "Label" },
        ["header"] = { "fg", "Comment" },
        ["gutter"] = { "bg", "Normal" },
        ["border"] = { "fg", "FzfLuaTitle" },
      }
      if binary == 'sk' and vim.fn.executable(binary) == 1 then
        colors["matched_bg"] = { "bg", "Normal" }
        colors["current_match_bg"] = { "bg", hl_match({ "NightflyVisual", "CursorLine" }) }
      end
      return colors
    end

    -- custom devicons setup file to be loaded when `multiprocess = true`
    fzf_lua.config._devicons_setup = "~/.config/nvim/lua/plugins/devicons.lua"

    fzf_lua.setup {
      fzf_bin     = fzf_bin,
      fzf_colors  = fzf_colors,
      winopts     = {
        -- Only valid when using a float window
        -- (i.e. when 'split' is not defined)
        height  = 0.98, -- window height
        width   = 0.85, -- window width
        row     = 0.35, -- window row position (0=top, 1=bottom)
        col     = 0.55, -- window col position (0=left, 1=right)
        preview = {
          layout       = 'vertical', -- horizontal|vertical|flex
          flip_columns = 130, -- #cols to switch to horizontal on flex
          scrollbar    = 'float', -- `false` or string:'float|border'
        },
      },
      previewers  = {
        bat = {
          theme = '1337', -- bat preview theme (bat --list-themes)
        },
      },
      keymap      = {
        -- These override the default tables completely
        -- no need to set to `false` to disable a bind
        -- delete or modify is sufficient
        builtin = {
          ["<C-]>"]  = "toggle-preview-cw",
          ["<C-d>"]  = "preview-page-down",
          ["<C-u>"]  = "preview-page-up",
          ["ctrl-f"] = "half-page-down",
          ["ctrl-p"] = "half-page-up",
          ["ctrl-a"] = "beginning-of-line",
          ["ctrl-e"] = "end-of-line",
        },
        -- fzf '--bind=' options
        fzf = {
          ["ctrl-f"] = "half-page-down",
          ["ctrl-p"] = "half-page-up",
          ["ctrl-a"] = "beginning-of-line",
          ["ctrl-e"] = "end-of-line",
          ["ctrl-d"] = "preview-page-down",
          ["ctrl-u"] = "preview-page-up",
        },
      },
      git         = {
        status   = {
          cmd           = "git status -su",
          winopts       = {
            preview = { vertical = "down:70%", horizontal = "right:70%" }
          },
          actions       = {
            ["ctrl-r"] = { fzf_lua.actions.git_reset, fzf_lua.actions.resume },
            ["ctrl-h"] = { fzf_lua.actions.git_stage, fzf_lua.actions.resume },
            ["ctrl-l"] = { fzf_lua.actions.git_unstage, fzf_lua.actions.resume },
          },
          preview_pager = vim.fn.executable("delta") == 1 and "delta --width=$COLUMNS",
        },
        files    = {
          winopts = {
            preview = { vertical = "down:65%", horizontal = "right:75%", }
          },
        },
        commits  = {
          preview_pager = vim.fn.executable("delta") == 1 and "delta --width=$FZF_PREVIEW_COLUMNS",
          winopts       = {
            preview = { vertical = "down:75%", horizontal = "right:75%", }
          },
        },
        bcommits = {
          winopts       = {
            preview = { vertical = "down:75%", horizontal = "right:75%", }
          },
          preview_pager = vim.fn.executable("delta") == 1 and "delta --width=$FZF_PREVIEW_COLUMNS",
          actions       = {
            ['default'] = git_commit_edit_func,
            ['ctrl-y'] = fzf_lua.actions.git_yank_commit,
            ["ctrl-n"] = git_commit_diff_func
          }
        },
        branches = { winopts = {
          preview = { vertical = "down:75%", horizontal = "right:75%", }
        } }
      },
      grep        = {
        debug   = false,
        rg_glob = true,
        rg_opts = "--hidden --column --line-number --no-heading " ..
        "--color=always --smart-case -g '!{.git,node_modules,.ccls-cache}/*' -e",
        actions = {
          ["ctrl-q"] = fzf_lua.actions.file_sel_to_qf,
        }
      },
      lsp         = { symbols = { path_shorten = 1 } },
      diagnostics = { file_icons = false, icon_padding = ' ', path_shorten = 1 }
    }
  end
}
