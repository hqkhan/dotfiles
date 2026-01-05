local utils = require("utils")

local map = function(mode, lhs, rhs, opts)
  opts = vim.tbl_extend("keep", opts, { silent = true, buffer = 0 })
  vim.keymap.set(mode, lhs, rhs, opts)
end

local setup = function()
  map("n", "<leader>ll", function()
    vim.diagnostic.open_float({ buffer = 0, scope = "line", border = "rounded" })
  end, { desc = "show line diagnostic [LSP]" })
end

return { setup = setup }
