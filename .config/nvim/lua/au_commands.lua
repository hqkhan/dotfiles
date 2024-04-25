-- https://github.com/ibhagwan/nvim-lua/blob/main/lua/autocmd.lua
local aucmd = vim.api.nvim_create_autocmd

local function augroup(name, fnc)
  fnc(vim.api.nvim_create_augroup(name, { clear = true }))
end

augroup("SmartTextYankPost", function(g)
  -- highlight yanked text and copy to system clipboard
  -- TextYankPost is also called on deletion, limit to
  -- yanks via v:operator
  -- if we are connected over ssh also copy using OSC52
  aucmd("TextYankPost", {
    group = g,
    pattern = '*',
    -- command = "if has('clipboard') && v:operator=='y' && len(@0)>0 | "
    --   .. "let @+=@0 | endif | "
    --   .. "lua vim.highlight.on_yank{higroup='IncSearch', timeout=2000}"
    desc = "Copy to clipboard/tmux/OSC52",
    callback = function()
      local ok, yank_data = pcall(vim.fn.getreg, "0")
      local valid_yank = ok and #yank_data>0 and vim.v.operator=='y'
      if valid_yank and vim.fn.has('clipboard') == 1 then
        pcall(vim.fn.setreg, "+", yank_data)
      end
      if valid_yank and vim.env.SSH_CONNECTION or
        -- $SSH_CONNECTION doesn't pass over to
        -- root when using `su -`, copy indiscriminately
        require'utils'.is_root() then
        require'utils'.osc52printf(yank_data)
      end
      if valid_yank and vim.env.TMUX then
        -- we use `-w` to also copy to client's clipboard
        vim.fn.system({'tmux', 'set-buffer', '-w', yank_data})
      end
      vim.highlight.on_yank({ higroup='IncSearch', timeout=200 })
    end
  })
end)

-- disable mini.indentscope for certain filetype|buftype
augroup("MiniIndentscopeDisable", function(g)
  aucmd("BufEnter", {
    group = g,
    callback = function(_)
      if vim.bo.filetype == "fzf"
          or vim.bo.filetype == "help"
          or vim.bo.buftype == "nofile"
          or vim.bo.buftype == "terminal"
      then
        vim.b.miniindentscope_disable = true
      end
    end,
  })
end)

augroup("ToggleSearchHL", function(g)
  aucmd("InsertEnter",
    {
      group = g,
      command = ":nohl | redraw"
    })
end)

augroup("NewlineNoAutoComments", function(g)
  aucmd("BufEnter", {
    group = g,
    pattern = '*',
    command = "setlocal formatoptions-=o"
  })
end)

augroup("ActiveWinCursorLine", function(g)
  -- Highlight current line only on focused window
  aucmd({ "WinEnter", "BufEnter", "InsertLeave" }, {
    group = g,
    pattern = '*',
    command = 'if ! &cursorline && ! &pvw | setlocal cursorline | endif'
  })
  aucmd({ "WinLeave", "BufLeave", "InsertEnter" }, {
    group = g,
    pattern = '*',
    command = 'if &cursorline && ! &pvw | setlocal nocursorline | endif'
  })
end)

-- auto-delete fugitive buffers
augroup("Fugitive", function(g)
  aucmd("BufReadPost", {
    group = g,
    pattern = 'fugitive://*',
    command = 'set bufhidden=delete'
  })
end)

-- Display help|man in vertical splits and map 'q' to quit
augroup("Help", function(g)
  local function open_vert()
    -- do nothing for floating windows or if this is
    -- the fzf-lua minimized help window (height=1)
    local cfg = vim.api.nvim_win_get_config(0)
    if cfg and (cfg.external or cfg.relative and #cfg.relative > 0)
        or vim.api.nvim_win_get_height(0) == 1 then
      return
    end
    -- do not run if Diffview is open
    if vim.g.diffview_nvim_loaded and
        require "diffview.lib".get_current_view() then
      return
    end
    local width = math.floor(vim.o.columns * 0.75)
    vim.cmd("wincmd L")
    vim.cmd("vertical resize " .. width)
    vim.keymap.set("n", "q", "<CMD>q<CR>", { buffer = true })
  end

  aucmd("FileType", {
    group = g,
    pattern = "help,man",
    callback = open_vert,
  })
  -- we also need this auto command or help
  -- still opens in a split on subsequent opens
  aucmd("BufEnter", {
    group = g,
    pattern = "*.txt",
    callback = function()
      if vim.bo.buftype == "help" then
        open_vert()
      end
    end
  })
  aucmd("BufHidden", {
    group = g,
    pattern = "man://*",
    callback = function()
      if vim.bo.filetype == "man" then
        local bufnr = vim.api.nvim_get_current_buf()
        vim.defer_fn(function()
          if vim.api.nvim_buf_is_valid(bufnr) then
            vim.api.nvim_buf_delete(bufnr, { force = true })
          end
        end, 0)
      end
    end
  })
end)

-- https://vim.fandom.com/wiki/Avoid_scrolling_when_switch_buffers
augroup("DoNotAutoScroll", function(g)
  local function is_float(winnr)
    local wincfg = vim.api.nvim_win_get_config(winnr)
    if wincfg and (wincfg.external or wincfg.relative and #wincfg.relative > 0) then
      return true
    end
    return false
  end

  aucmd("BufLeave", {
    group = g,
    desc = "Avoid autoscroll when switching buffers",
    callback = function()
      -- at this stage, current buffer is the buffer we leave
      -- but the current window already changed, verify neither
      -- source nor destination are floating windows
      local from_buf = vim.api.nvim_get_current_buf()
      local from_win = vim.fn.bufwinid(from_buf)
      local to_win = vim.api.nvim_get_current_win()
      if not is_float(to_win) and not is_float(from_win) then
        vim.b.__VIEWSTATE = vim.fn.winsaveview()
      end
    end
  })
  aucmd("BufEnter", {
    group = g,
    desc = "Avoid autoscroll when switching buffers",
    callback = function()
      if vim.b.__VIEWSTATE then
        local to_win = vim.api.nvim_get_current_win()
        if not is_float(to_win) then
          vim.fn.winrestview(vim.b.__VIEWSTATE)
        end
        vim.b.__VIEWSTATE = nil
      end
    end
  })
end)

-- goto last location when opening a buffer
augroup("BufLastLocation", function(g)
  aucmd("BufReadPost", {
    group = g,
    callback = function(e)
      -- skip fugitive commit message buffers
      local bufname = vim.api.nvim_buf_get_name(e.buf)
      if bufname:match("COMMIT_EDITMSG$") then return end
      local mark = vim.api.nvim_buf_get_mark(e.buf, '"')
      local line_count = vim.api.nvim_buf_line_count(e.buf)
      if mark[1] > 0 and mark[1] <= line_count then
        vim.cmd 'normal! g`"zz'
      end
    end,
  })
end)

vim.api.nvim_create_autocmd({ "BufEnter", "WinEnter", "CursorHold", "CursorHoldI", "FocusGained" }, {
  command = "if mode() != 'c' | checktime | endif",
  pattern = { "*" },
})

vim.api.nvim_create_autocmd({ "BufRead" }, {
  pattern = { "gitmux.conf" },
  callback = function()
    vim.cmd([[set filetype=sh]])
  end,
})

vim.api.nvim_create_autocmd("BufWritePost", {
  pattern = { "*tmux.conf" },
  command = "execute 'silent !tmux source <afile> --silent'",
})

augroup("GQFormatter", function(g)
  aucmd({ "FileType", "LspAttach" },
    {
      group = g,
      callback = function(e)
        -- execlude diffview and vim-fugitive
        if vim.bo.filetype == "fugitive"
            or e.file:match("^fugitive:")
            or require("plugins.diffview")._is_open() then
          return
        end
        require("plugins.conform")._set_gq_keymap(e)
      end,
    })
end)
