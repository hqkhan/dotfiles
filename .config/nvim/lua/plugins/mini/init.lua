local M = {
  -- vim-surround/sandwich, lua version
  -- mini also has an indent highlighter
  "echasnovski/mini.nvim",
  event = "VeryLazy",
}

function M.config()
  require("plugins.mini.surround")
  require("plugins.mini.indentscope")
  require("mini.ai").setup()
  require("mini.align").setup()
end

return M
