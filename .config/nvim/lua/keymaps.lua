local map = vim.keymap.set

-- Reload the config (including certain plugins)
vim.api.nvim_create_user_command("NvimRestart",
  function()
    require("utils").reload_config()
  end,
  { nargs = "*" }
)

map('', '<leader>R', "<Esc>:NvimRestart<CR>",
  { silent = true, desc = "reload nvim configuration" })

-- Fix common typos
vim.cmd([[
    cnoreabbrev W! w!
    cnoreabbrev W1 w!
    cnoreabbrev w1 w!
    cnoreabbrev Q! q!
    cnoreabbrev Q1 q!
    cnoreabbrev q1 q!
    cnoreabbrev Qa! qa!
    cnoreabbrev Qall! qall!
    cnoreabbrev Wa wa
    cnoreabbrev Wq wq
    cnoreabbrev wQ wq
    cnoreabbrev WQ wq
    cnoreabbrev wq1 wq!
    cnoreabbrev Wq1 wq!
    cnoreabbrev wQ1 wq!
    cnoreabbrev WQ1 wq!
    cnoreabbrev W w
    cnoreabbrev Q q
    cnoreabbrev Qa qa
    cnoreabbrev Qall qall
]])

-- root doesn't use plugins, use builtin FZF
if require'utils'.is_root() then
  vim.env.FZF_DEFAULT_OPTS = vim.env.FZF_DEFAULT_OPTS
    .. " --info=default"
  vim.g.fzf_layout = {window={['width']=0.9,height=0.9}}
  map('n', '<C-p>', '<cmd>FZF<CR>', { desc = "FZF" })
end

-- alternate file mapping without zz
for _, k in ipairs({ '<C-e>', '<C-^>', '<C-6>'}) do
  map({'n', 'i'}, k, function()
    local to = vim.fn.bufnr('#')
    -- no alternate file, abort
    if to <= 0 then return end
    vim.b.__VIEWSTATE = vim.fn.winsaveview()
    vim.api.nvim_set_current_buf(to)
      if vim.b.__VIEWSTATE then
        vim.fn.winrestview(vim.b.__VIEWSTATE)
        vim.b.__VIEWSTATE = nil
      end
  end,
  { silent = true, desc = "Alternate file (normal & insert mode)" })
end

-- Save
map({ 'n', 'v', 'i'}, '<leader>w', '<Esc>:w!<CR>', { silent = true, desc = "Save" })
-- Quit
map('n', '<leader>q', '<Esc>:q!<CR>', { silent = true, desc = "Quit" })

-- w!! to save with sudo
map('c', 'w!!', "<esc>:lua require'utils'.sudo_write()<CR>", { silent = true })

-- Beginning and end of line in `:` command mode
map('c', '<C-a>', '<home>', {})
map('c', '<C-e>', '<end>' , {})

-- Go up and down in command mode
map('c', '<C-j>', '<Down>', {})
map('c', '<C-k>', '<Up>' , {})
map('c', '<C-h>', '<Left>', {})
map('c', '<C-l>', '<Right>' , {})

-- Scroll up and down
map({'n', 'v'}, '<C-j>', 'j<C-E>', {})
map({'n', 'v'}, '<C-k>', 'k<C-Y>', {})

-- Navigate tabs
map('n', '[t', ':tabprevious<CR>', { desc = "Previous tab" })
map('n', ']t', ':tabnext<CR>',     { desc = "Next tab" })
map('n', '[T', ':tabfirst<CR>',    { desc = "First tab" })
map('n', ']T', ':tablast<CR>',     { desc = "Last tab" })

-- Navigate buffers
map('n', '[b', ':bprevious<CR>',   { desc = "Previous buffer" })
map('n', ']b', ':bnext<CR>',       { desc = "Next buffer" })
map('n', '[B', ':bfirst<CR>',      { desc = "First buffer" })
map('n', ']B', ':blast<CR>',       { desc = "Last buffer" })

-- Quickfix list mappings
map('n', '<leader>cq', "<cmd>lua require'utils'.toggle_qf('q')<CR>",
  { desc = "toggle quickfix list" })
map('n', '[q', ':cprevious<CR>',   { desc = "Next quickfix" })
map('n', ']q', ':cnext<CR>',       { desc = "Previous quickfix" })
map('n', '[Q', ':cfirst<CR>',      { desc = "First quickfix" })
map('n', ']Q', ':clast<CR>',       { desc = "Last quickfix" })

-- shortcut to view :messages
map({'n', 'v'}, '<leader>m', '<cmd>messages<CR>',
  { desc = "open :messages" })
map({'n', 'v'}, '<leader>M', '<cmd>mes clear|echo "cleared :messages"<CR>',
  { desc = "clear :messages" })

-- keep visual selection when (de)indenting
map('v', '<', '<gv', {})
map('v', '>', '>gv', {})

-- Keep matches center screen when cycling with n|N
map('n', 'n', 'nzzzv', { desc = "Fwd  search '/' or '?'" })
map('n', 'N', 'Nzzzv', { desc = "Back search '/' or '?'" })

-- any jump over 5 modifies the jumplist
-- so we can use <C-o> <C-i> to jump back and forth
for _, c in ipairs({
    { 'k', 'Line up' },
    { 'j', 'Line down' },
  }) do
  map('n', c[1], ([[(v:count > 5 ? "m'" . v:count : "") . '%s']]):format(c[1]),
    { expr = true, silent = true, desc = c[2] })
end

-- Search and Replace
-- 'c.' for word, 'c>' for WORD
-- 'c.' in visual mode for selection
map('n', 'c.', [[:%s/\<<C-r><C-w>\>//g<Left><Left>]],
  { desc = "search and replace word under cursor" })
map('n', 'c>', [[:%s/\V<C-r><C-a>//g<Left><Left>]],
  { desc = "search and replace WORD under cursor" })

-- Turn off search matches with double-<Esc>
map('n', '<Esc><Esc>', '<Esc>:nohlsearch<CR>', { silent = true })

-- Change current working dir (:pwd) to curent file's folder
map('n', '<leader>cd', '<Esc>:lua require"utils".set_cwd()<CR>',
  { silent = true, desc = "smart set cwd (git|file parent)" })

map('n', '<C-p>', '<Esc>:lua print(vim.api.nvim_buf_get_name(0))<CR>',
  { silent = true, desc = "print current buffer path" })

map({'n', 'v'}, '<S-j>', '<PageDown>zz',
  { silent = true, desc = "Page down and keep center screen" })
map({'n', 'v'}, '<S-k>', '<PageUp>zz',
  { silent = true, desc = "Page up and keep center screen" })

map('n', '<leader>bd', '<Esc>:bd<CR>',
  { silent = true, desc = "Close current buffer" })

map({ "n", "v" }, "<leader>p", '"0p', { desc = "paste AFTER  from yank (reg:0)" })
map({ "n", "v" }, "<leader>P", '"0P', { desc = "paste BEFORE from yank (reg:0)" })
