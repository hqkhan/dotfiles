------------------------------------
-------------Keymaps----------------
------------------------------------
local map_fzf = function(mode, key, f, options, buffer)

  local desc = nil
  if type(options) == 'table' then
    desc = options.desc
    options.desc = nil
  elseif type(options) == 'function' then
    desc = options().desc
  end

  local rhs = function()
    local fzf_lua = require("fzf-lua")
    if fzf_lua[f] then
      fzf_lua[f](options or {})
    else
      require("plugins.fzf-lua.cmds")[f](options or {})
    end
  end

  local map_options = {
    silent = true,
    buffer = buffer,
    desc   = desc or string.format("FzfLua %s", f),
  }

  vim.keymap.set(mode, key, rhs, map_options)
end

local small_top_big_bottom = {
                                 preview = { vertical = "down:65%", horizontal = "right:75%", }
                             }
-- Misc
map_fzf('n', "<leader>f?", "builtin",           { desc = "builtin commands" })
map_fzf('n', "<C-f>", "files",                  { desc = "Files",
    prompt = 'Files❯ ',
        winopts = small_top_big_bottom,
})

map_fzf('n', "<Space><CR>", "buffers",          { desc = "Buffers",
    winopts = {
        preview = { vertical = "down:65%", horizontal = "right:75%", }
    },
})

-- Git
map_fzf({'n', 'v'}, "<leader>bcm", "git_bcommits",     { desc = "Git buffer commits" })
map_fzf('n', "<leader>cm", "git_commits",       { desc = "Git commits" })
map_fzf('n', "<C-g>", "git_files",              { desc = "Git Files" })
map_fzf('n', "<leader>co", "git_branches",      { desc = "Checkout git branches" })

-- Grep
map_fzf('n', "<leader>rg", "grep_curbuf",       { desc = "Grep current buffer" })
map_fzf("n", "<leader>cW", "grep_cword",        { desc = "grep <word> (project)" })
map_fzf('n', '<leader>cw', "grep_curbuf", function()
  return                                        { desc = 'Live grep current buffer',
    prompt = 'Buffer❯ ',
    winopts = small_top_big_bottom,
    search = vim.fn.expand("<cword>"),
  }
end)

map_fzf("v", "<leader>lg", "grep_visual", { desc = "grep visual selection" })

map_fzf('n', "<leader>lG", "live_grep",
    function() return                           { desc = "Live grep (project)",
    winopts = small_top_big_bottom,
}end)
map_fzf('n', "<leader>lg", "lgrep_curbuf",
    function() return                           { desc = "Live grep current buffer",
      winopts = small_top_big_bottom,
}end)

map_fzf('n', "<leader>bl", "blines",            { desc = "buffer lines",
      winopts = small_top_big_bottom,
})

map_fzf('n', "<leader>LG", "live_grep_resume",  { desc = "Live grep resume",
      winopts = small_top_big_bottom,
})

map_fzf('n', "<leader>fq", "quickfix",          { desc = "Quickfix",
      winopts = small_top_big_bottom,
})

map_fzf('n', "<leader>tm", "tmux_buffers",      { desc = "tmux buffers" })

map_fzf("n", "<leader>fO", "oldfiles",          { desc = "file history (all)", cwd = "~" })
map_fzf('n', '<leader>fo', "oldfiles", function()
  return                                        { desc = 'file history (cwd)',
    cwd = vim.loop.cwd(),
    show_cwd_header = true,
    cwd_only = true,
    winopts = small_top_big_bottom,
  }
end)

-- LSP
map_fzf("n", "<leader>lf", "lsp_finder",              { desc = "location finder [LSP]" })
map_fzf('n', "<leader>lS", "lsp_workspace_symbols",   { desc = "Workspace symbols" })
map_fzf('n', "<leader>ls", "lsp_document_symbols",    { desc = "Document symbols" })
map_fzf('n', "<leader>lr", "lsp_references",          { desc = "LSP references" })
map_fzf('n', "<leader>ld", "lsp_definitions",         { desc = "LSP definitinos" })
map_fzf('n', "<leader>lD", "lsp_declarations",        { desc = "LSP declaration" })
map_fzf("n", "<leader>ly", "lsp_typedefs",            { desc = "type definitions [LSP]" })

map_fzf('n', "<leader>HT", "help_tags",               { desc = "nvim help tags" })

-- Full screen git status
map_fzf('n', '<leader>gs', "git_status_tmuxZ",
          { desc = "git status (fullscreen)",
              winopts = {
                  fullscreen = true,
                  preview = {
                      vertical = "down:70%",
                      horizontal = "right:70%",
                  },
              },
            fzf = {
            ["alt-a"]       = "select-all",
            ["alt-d"]       = "deselect-all",
          },
})
map_fzf('n', '<leader>gS', "git_status", vim.tbl_extend("force", {show_cwd_header = false},            { desc = "git status" }))
map_fzf("n", "<leader>fq", "quickfix", { desc = "quickfix list",
    winopts = small_top_big_bottom,
})

map_fzf("n", "<leader>fp", "files", {
  desc = "plugin files (packer)",
  prompt = "Plugins❯ ",
  winopts = small_top_big_bottom,
  cwd = vim.fn.stdpath "data" .. "/lazy"
})

map_fzf("n", "<c-t>", "workdirs", { desc = "cwd workdirs",
  winopts = {
    height = 0.40,
    width  = 0.60,
    row    = 0.40,
  }
})

map_fzf("n", "<leader>li", "get_lines_within_indent", { desc = "Lgrep in current context",
  winopts = small_top_big_bottom
})

-- yadm repo
local yadm_git_opts = {
  cwd_header = false,
  cwd = "$HOME",
  git_dir = "$YADM_REPO",
  git_worktree = "$HOME",
  git_config = "status.showUntrackedFiles=no",
}
local yadm_grep_opts = {
  prompt = "YadmGrep❯ ",
  cwd_header = false,
  cwd = "$HOME",
  cmd = "git --git-dir=${YADM_REPO} -C ${HOME} grep --line-number --column --color=always",
  rg_glob = false, -- this isn't `rg`
}

map_fzf("n", "<leader>yf", "git_files",
  vim.tbl_extend("force", yadm_git_opts,
    { desc = "yadm ls-files", prompt = "YadmFiles> " }))
map_fzf("n", "<leader>yg", "grep_project",
  vim.tbl_extend("force", yadm_grep_opts, { desc = "yadm grep" }))
map_fzf("n", "<leader>ylg", "live_grep",
  vim.tbl_extend("force", yadm_grep_opts, { desc = "yadm live grep" }))
map_fzf("n", "<leader>yb", "git_branches",
  vim.tbl_extend("force", yadm_git_opts, { desc = "yadm branches" }))
map_fzf("n", "<leader>ycm", "git_commits",
  vim.tbl_extend("force", yadm_git_opts, { desc = "yadm commits (project)" }))
map_fzf({'n', 'v'}, "<leader>ybcm", "git_bcommits",
  vim.tbl_extend("force", yadm_git_opts, { desc = "yadm commits (buffer)" }))

map_fzf("n", "<leader>yS", "git_status",
  vim.tbl_extend("force", yadm_git_opts,
    { desc = "yadm status", cmd = "git status -s", prompt = "YadmStatus> " }))
map_fzf("n", "<leader>es", "git_status",
  vim.tbl_extend("force", yadm_git_opts,
    { desc = "yadm status", cmd = "git status -s", prompt = "YadmStatus> " }))

map_fzf("n", "<leader>ys", "git_status_tmuxZ",
  vim.tbl_extend("force", yadm_git_opts,
    {
      desc = "yadm status (fullscreen)",
      prompt = "YadmStatus> ",
      cmd = "git status -s",
      winopts = {
        fullscreen = true,
        preview = {
          vertical = "down:70%",
          horizontal = "right:70%",
        }
      }
    }))
