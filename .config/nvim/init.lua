local utils = require("utils")

if vim.fn.has("nvim-0.10") ~= 1 then
  utils.warn("This config requires neovim 0.10 and above")
  vim.o.loadplugins = false
  vim.o.termguicolors = true
  return
end

require("settings")
require("au_commands")
require("keymaps")

-- we don't use plugins as root
if not utils.is_root() then
  require("lazy_bootstrap")
end

-- set colorscheme to modified embark
-- https://github.com/embark-theme/vim
-- vim.g.embark_transparent = true
-- vim.g.embark_terminal_italics = true
vim.g.lua_embark_transparent = true
if utils.is_root() then
  pcall(vim.cmd, [[colorscheme lua-embark]])
else
  pcall(vim.cmd, [[colorscheme everforest]])
end
