local utils = require("utils")

if not utils.has_neovim_v08() then
  utils.warn("nvim-lua requires neovim > 0.8")
  vim.o.lpl = true
  vim.o.termguicolors = true
  pcall(vim.cmd, [[colorscheme lua-embark]])
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
pcall(vim.cmd, [[colorscheme lua-embark]])
