local M = {
  url = "https://tpope.io/vim/fugitive.git",
  cmd = { "Git", "Yit", "Gread", "Gwrite", "Gvdiffsplit", "Gdiffsplit" },
}

M.init = function()
  local map = vim.keymap.set
  map('n', '<leader>gg', '<Esc>:G<CR>', { silent = true, desc = "Git" })
  map('n', '<leader>gr', '<Esc>:Gread<CR>', { silent = true, desc = "Gread (reset)" })
  map('n', '<leader>gw', '<Esc>:Gwrite<CR>', { silent = true, desc = "Gwrite (stage)" })
  map('n', '<leader>gbl', '<Esc>:Git blame<CR>', { silent = true, desc = "git blame" })
  map('n', '<leader>gc', '<Esc>:Git commit<CR>', { silent = true })
  map('n', '<leader>gC', '<Esc>:Git commit --amend<CR>', { silent = true, desc = "Git commit amend"})
  map('n', '<leader>gd', '<Esc>:Gvdiff<CR>', { silent = true, desc = "Git diff (buffer)" })
  map('n', '<leader>gD', '<Esc>:Git diff<CR>', { silent = true, desc = "Git diff (project)" })
  map('n', '<leader>gp', '<Esc>:Git push<CR>', { silent = true, desc = "Git push" })
  map('n', '<leader>ge', '<Esc>:vsp<CR>:Gedit HEAD~:%<Left><Left>', { silent = true, desc = "Git edit current file from previous commit from head" })
  map('n', '<leader>g+', '<Esc>:Git stash push<CR>', { silent = true, desc = "Git stash push" })
  map('n', '<leader>g-', '<Esc>:Git stash pop<CR>',  { silent = true, desc = "Git stash pop" })

  -- Merge conflict binds
  map('n', '<leader>gm', '<Esc>:Gvdiffsplit!<CR>', { silent = true, desc = "Git merge conflict" })
  map('n', '<leader>gl', '<Esc>:diffget //3<CR>:diffupdate<CR>', { silent = true, desc = "Git take right buffer's hunk" })
  map('n', '<leader>gh', '<Esc>:diffget //2<CR>:diffupdate<CR>', { silent = true, desc = "Git take left buffer's hunk" })
end

return M
