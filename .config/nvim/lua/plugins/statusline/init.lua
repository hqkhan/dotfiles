local M = {
  "hqkhan/express_line.nvim",
  -- lazy = false,
  -- enabled = false,
  event = "BufReadPost"
}

local function setup()
  local statusline = require "el"
  local builtin = require "el.builtin"
  local sections = require "el.sections"
  local c = require "plugins.statusline.components"

  local function setup_el()
    statusline.setup {
      regenerate_autocmds = { "WinEnter", "WinLeave" },
      generator = function(_, _)
        local hl_red = "ErrorMsg"
        local hl_green = "diffAdded"
        local hl_yellow = "WarningMsg"
        local hl_magenta = "WarningMsg"
        local hl_statusline = "StatusLine"
        local hl_bg = "Normal"

        local highlights = {
          bg_fg = c.extract_hl({
            bg = { [hl_bg] = "bg" },
            fg = { [hl_bg] = "fg" },
            bold = true,
          }),
          red_fg = c.extract_hl({
            bg = { [hl_bg] = "bg" },
            fg = { [hl_red] = "fg" },
            bold = true,
          }),
          green_tmux_fg = c.extract_hl({
            bg = { [hl_bg] = "bg" },
            fg = { [hl_green] = "fg" },
            bold = true,
          }),
          green_fg = c.extract_hl({
            bg = { [hl_statusline] = "bg" },
            fg = { [hl_green] = "fg" },
            bold = true,
          }),
          yellow_fg = c.extract_hl({
            bg = { [hl_statusline] = "bg" },
            fg = { [hl_yellow] = "fg" },
            bold = true,
          }),
          magenta_fg = c.extract_hl({
            bg = { [hl_statusline] = "bg" },
            fg = { [hl_magenta] = "fg" },
            bold = true,
          }),
          filename_bg_fg = c.extract_hl({
            bg = { ["Darkblue_tmux_bg"] = "bg" },
            fg = { [hl_red] = "fg" },
            bold = true,
          }),
          filename_sepr = c.extract_hl({
            bg = { [hl_statusline] = "bg" },
            fg = { ["Darkblue_tmux_fg"] = "fg" },
          }),
        }

        local signs = {
          right_sepr = '',
          left_sepr = '',
          right_sepr_thin = '',
          left_sepr_thin = '',
        }

        local components = {
          -- Macro recording
          {
            c.macro_recording {
              hls_record = highlights.red_fg,
              icon_record = "󱜨",
            }
          },

          -- Buffer change counts
          {
            c.git_changes_buf {
              fmt = "%s",
              icon_insert = " ",
              icon_change = " ",
              icon_delete = " ",
              hl_insert = hl_green,
              hl_change = hl_yellow,
              hl_delete = highlights.red_fg,
            }
          },

          -- LSP Diagnostics
          {
            c.diagnostics {
              fmt = "%s", lsp = false,
              hl_lsp_srv = highlights.lsp_srv,
              hl_err = highlights.red_fg,
              hl_warn = highlights.yellow_fg,
              hl_info = highlights.green_tmux_fg,
              hl_hint = hl_green,
              icon_err = ' ', icon_warn = ' ', icon_info = ' ', icon_hint = ''
            }
          },
          { sections.split, required = true },

          -- Middle
          -- File path
          { sections.highlight(highlights.filename_sepr, ("%s"):format(signs.left_sepr)) },
          { sections.highlight(highlights.filename_bg_fg, (" ")) },
          { c.file_icon { fmt = "%s ", hl_icon = true } },
          { sections.maximum_width(sections.highlight(highlights.filename_bg_fg, builtin.make_responsive_file(140, 90)), 0.40, { highlight = true }), required = true },
          { sections.highlight(highlights.filename_bg_fg, (" ")) },
          { sections.highlight(highlights.filename_sepr, ("%s"):format(signs.right_sepr)) },

          -- Modified flag
          { " " },
          { sections.highlight(hl_green, builtin.modified_flag) },
          { sections.split, required = true },

          -- Right
          {
            sections.collapse_builtin {
              "[",
              builtin.help_list,
              builtin.readonly_list,
              "]",
            },
          },
        }

        local result = {}
        for _, item in ipairs(components) do
          table.insert(result, item)
        end
        return result
      end,
    }
  end

  -- run at least once
  setup_el()
end

local function augroup(name, fnc)
  fnc(vim.api.nvim_create_augroup(name, { clear = true }))
end

M.config = function()
  setup()

  -- update statusline highlights on colorscheme change
  -- we configure the event here since lazy's colorscheme
  -- config triggers the event and disables our lazy loading
  -- which will cause the splash screen to disappear
  augroup("StatusLineColorschemeUpdate", function(g)
    vim.api.nvim_create_autocmd("ColorScheme", {
      group = g,
      pattern = "*",
      command = "lua require'plugins.statusline'.config()",
    })
  end)
end

return M
