return {
  "rebelot/heirline.nvim",
  -- enabled = false,
  event = "BufReadPost",
  config = function()
    local utils = require("heirline.utils")
    local setup_colors = function()
      return {
        red_fg = utils.get_highlight("ErrorMsg").fg,
        green_fg = utils.get_highlight("diffAdded").fg,
        yellow_fg = utils.get_highlight("WarningMsg").fg,
        magenta_fg = utils.get_highlight("WarningMsg").fg,
        dark_tmux_fg = utils.get_highlight("Darkblue_tmux_bg").bg,
        dark_tmux_bg = utils.get_highlight("Darkblue_tmux_bg").bg,
        normal = utils.get_highlight("Normal").bg
      }
    end
    require("heirline").setup({
      opts = { colors = setup_colors },
      statusline = require("plugins.heirline.statusline"),
    })
    vim.api.nvim_create_augroup("Heirline", { clear = true })
    vim.api.nvim_create_autocmd("ColorScheme", {
      callback = function()
        utils.on_colorscheme(setup_colors)
      end,
      group = "Heirline",
    })
  end
}
