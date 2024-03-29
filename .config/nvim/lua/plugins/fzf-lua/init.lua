local M = {
  "ibhagwan/fzf-lua",
  dev = require("utils").is_dev("fzf-lua")
}

function M.init()
  require("plugins.fzf-lua.mappings")
  require("plugins.fzf-lua.cmds")
end

function M.config()
  require("plugins.fzf-lua.setup").setup()

  -- register fzf-lua as vim.ui.select interface
  require("fzf-lua").register_ui_select({
    winopts = {
      win_height = 0.30,
      win_width  = 0.70,
      win_row    = 0.40,
    }
  })
end

return M
