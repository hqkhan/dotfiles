local map_fzf = function(mode, key, f, options, buffer)
  local desc = nil
  if type(options) == "table" then
    desc = options.desc
    options.desc = nil
  elseif type(options) == "function" then
    desc = options().desc
  end

  local rhs = function()
    local fzf_lua = require("fzf-lua")
    local custom = require("plugins.fzf-lua.cmds")
    -- use deepcopy so options ref isn't saved in the mapping
    -- as this can create weird issues, for example, `lgrep_curbuf`
    -- saving the filename in between executions
    if custom[f] then
      custom[f](options and vim.deepcopy(options) or {})
    else
      fzf_lua[f](options and vim.deepcopy(options) or {})
    end
  end

  local map_options = {
    silent = true,
    buffer = buffer,
    desc   = desc or string.format("FzfLua %s", f),
  }

  vim.keymap.set(mode, key, rhs, map_options)
end

local small_top_big_bottom = {
                                 preview = { vertical = "down:65%", horizontal = "right:75%", }
                             }
-- Misc
map_fzf('n', "<leader>f?", "builtin",           { desc = "builtin commands" })
map_fzf('n', "<C-f>", "files",                  { desc = "Files",
    prompt = 'Files❯ ',
    winopts = small_top_big_bottom,
})

map_fzf('n', "<Space><CR>", "buffers",          { desc = "Buffers",
    winopts = {
        preview = { vertical = "down:65%", horizontal = "right:75%", }
    },
})

-- Git
map_fzf({'n', 'v'}, "<leader>bcm", "git_bcommits", { desc = "Git buffer commits" })
map_fzf('n', "<leader>cm", "git_commits",       { desc = "Git commits" })
map_fzf('n', "<C-g>", "git_files",              { desc = "Git Files" })
map_fzf('n', "<leader>co", "git_branches",      { desc = "Checkout git branches" })
map_fzf('v', "<leader>gbl", "git_bcommits",     { desc = "Git buffer commits" })

-- Grep
map_fzf('n', "<leader>rg", "grep_curbuf",       { desc = "Grep current buffer", winopts = small_top_big_bottom })
map_fzf('n', "<leader>rG", "grep",              { desc = "Grep Project", winopts = small_top_big_bottom })
map_fzf("n", "<leader>cW", "grep_cword",        { desc = "grep <word> (project)", winopts = small_top_big_bottom })
map_fzf('n', '<leader>cw', "grep_curbuf", function()
  return                                        { desc = 'Live grep current buffer',
    prompt = 'Buffer❯ ',
    winopts = small_top_big_bottom,
    search = vim.fn.expand("<cword>"),
  }
end)

map_fzf("v", "<leader>lg", "grep_visual", { desc = "grep visual selection" })

map_fzf('n', "<leader>lG", "live_grep",
    { desc = "Live grep (project)", winopts = small_top_big_bottom, })
map_fzf('n', "<leader>lg", "lgrep_curbuf",
    function() return                           { desc = "Live grep current buffer",
      winopts = small_top_big_bottom,
}end)

map_fzf('n', "<leader>bl", "blines",            { desc = "buffer lines",
      winopts = small_top_big_bottom,
})

map_fzf('n', "<leader>LG", "live_grep_resume",  { desc = "Live grep resume",
      winopts = small_top_big_bottom,
})

map_fzf('n', "<leader>fq", "quickfix",          { desc = "Quickfix",
      winopts = small_top_big_bottom,
})

map_fzf('n', "<leader>tm", "tmux_buffers",      { desc = "tmux buffers" })

-- LSP
map_fzf("n", "<leader>lf", "lsp_finder",              { desc = "location finder [LSP]", winopts = small_top_big_bottom })
map_fzf('n', "<leader>lS", "lsp_workspace_symbols",   { desc = "Workspace symbols", winopts = small_top_big_bottom})
map_fzf('n', "<leader>ls", "lsp_document_symbols",    { desc = "Document symbols", winopts = small_top_big_bottom})
map_fzf('n', "<leader>lr", "lsp_references",          { desc = "LSP references", winopts = small_top_big_bottom})
-- map_fzf('n', "<leader>ld", "lsp_definitions",         { desc = "LSP definitions", winopts = small_top_big_bottom})
-- map_fzf('n', "<leader>lD", "lsp_declarations",        { desc = "LSP declaration", winopts = small_top_big_bottom})
map_fzf('n', "<leader>ld", "diagnostics_document",         { desc = "LSP definitions", winopts = small_top_big_bottom})
map_fzf('n', "<leader>lD", "diagnostics_workspace",        { desc = "LSP declaration", winopts = small_top_big_bottom})
map_fzf("n", "<leader>la", "lsp_code_actions",        { desc = "code actions [LSP]", winopts = small_top_big_bottom})
map_fzf("n", "<leader>ly", "lsp_typedefs",            { desc = "type definitions [LSP]", winopts = small_top_big_bottom})

map_fzf('n', "<leader>HT", "help_tags",               { desc = "nvim help tags", winopts = small_top_big_bottom})

-- Full screen git status
map_fzf('n', '<leader>gs', "git_status_tmuxZ",
          { desc = "git status (fullscreen)",
              winopts = {
                  fullscreen = true,
                  preview = {
                      vertical = "down:70%",
                      horizontal = "right:70%",
                  },
              },
            fzf = {
            ["alt-a"]       = "select-all",
            ["alt-d"]       = "deselect-all",
          },
})
map_fzf('n', '<leader>gS', "git_status", vim.tbl_extend("force", {show_cwd_header = false},            { desc = "git status" }))
map_fzf("n", "<leader>fq", "quickfix", { desc = "quickfix list",
    winopts = small_top_big_bottom,
})

map_fzf("n", "<leader>fp", "files", {
  desc = "plugin files (packer)",
  prompt = "Plugins❯ ",
  winopts = small_top_big_bottom,
  cwd = vim.fn.stdpath "data" .. "/lazy"
})

-- dotfiles repo
local dotfiles_git_opts = {
  cwd_header = false,
  cwd = "$HOME",
  git_dir = "$DOTFILES_REPO",
  git_worktree = "$HOME",
  git_config = "status.showUntrackedFiles=no",
}
local dotfiles_grep_opts = {
  prompt = "DotsGrep❯ ",
  cwd_header = false,
  cwd = "$HOME",
  cmd = "git --git-dir=${DOTFILES_REPO} --work-tree=${HOME} -C ${HOME} grep --line-number --column --color=always",
  rg_glob = false, -- this isn't `rg`
}

map_fzf("n", "<leader>yf", "git_files",
  vim.tbl_extend("force", dotfiles_git_opts,
    { desc = "dots ls-files", prompt = "DotsFiles> " }))
map_fzf("n", "<leader>yg", "grep_project",
  vim.tbl_extend("force", dotfiles_grep_opts, { desc = "dots grep" }))
map_fzf("n", "<leader>ylg", "live_grep",
  vim.tbl_extend("force", dotfiles_grep_opts, { desc = "dots live grep" }))
map_fzf("n", "<leader>yb", "git_branches",
  vim.tbl_extend("force", dotfiles_git_opts, { desc = "dots branches" }))
map_fzf("n", "<leader>ycm", "git_commits",
  vim.tbl_extend("force", dotfiles_git_opts, { desc = "dots commits (project)" }))
map_fzf({'n', 'v'}, "<leader>ybcm", "git_bcommits",
  vim.tbl_extend("force", dotfiles_git_opts, { desc = "dots commits (buffer)" }))
map_fzf('v', "<leader>ybl", "git_bcommits",
  vim.tbl_extend("force", dotfiles_git_opts, { desc = "dots commits (buffer)" }))

map_fzf("n", "<leader>yS", "git_status",
  vim.tbl_extend("force", dotfiles_git_opts,
    { desc = "dots status", cmd = "git status -s", prompt = "DotsStatus> " }))
map_fzf("n", "<leader>ys", "git_status_tmuxZ",
  vim.tbl_extend("force", dotfiles_git_opts,
    {
      desc = "dots status (fullscreen)",
      prompt = "DotsStatus> ",
      cmd = "git status -s",
      winopts = {
        fullscreen = true,
        preview = {
          vertical = "down:70%",
          horizontal = "right:70%",
        }
      }
    }))

-- dotfiles priv repo
local dotfiles_priv_git_opts = {
  cwd_header = false,
  cwd = "$HOME",
  git_dir = "$DOTFILES_PRIV_REPO",
  git_worktree = "$HOME",
  git_config = "status.showUntrackedFiles=no",
}
local dotfiles_priv_grep_opts = {
  prompt = "DotsPrivGrep❯ ",
  cwd_header = false,
  cwd = "$HOME",
  cmd = "git --git-dir=${DOTFILES_PRIV_REPO} --work-tree=${HOME} -C ${HOME} grep --line-number --column --color=always",
  rg_glob = false, -- this isn't `rg`
}

map_fzf("n", "<leader>ypf", "git_files",
  vim.tbl_extend("force", dotfiles_priv_git_opts,
    { desc = "dots priv ls-files", prompt = "DotsPrivFiles> " }))
map_fzf("n", "<leader>ypg", "grep_project",
  vim.tbl_extend("force", dotfiles_priv_grep_opts, { desc = "dots priv grep" }))
map_fzf("n", "<leader>yplg", "live_grep",
  vim.tbl_extend("force", dotfiles_priv_grep_opts, { desc = "dots priv live grep" }))
map_fzf("n", "<leader>ypb", "git_branches",
  vim.tbl_extend("force", dotfiles_priv_git_opts, { desc = "dots priv branches" }))
map_fzf("n", "<leader>ypcm", "git_commits",
  vim.tbl_extend("force", dotfiles_priv_git_opts, { desc = "dots priv commits (project)" }))
map_fzf({'n', 'v'}, "<leader>ypbcm", "git_bcommits",
  vim.tbl_extend("force", dotfiles_priv_git_opts, { desc = "dots priv commits (buffer)" }))
map_fzf('v', "<leader>ypbl", "git_bcommits",
  vim.tbl_extend("force", dotfiles_priv_git_opts, { desc = "dots priv commits (buffer)" }))

map_fzf("n", "<leader>ypS", "git_status",
  vim.tbl_extend("force", dotfiles_priv_git_opts,
    { desc = "dots priv status", cmd = "git status -s", prompt = "DotsPrivStatus> " }))
map_fzf("n", "<leader>yps", "git_status_tmuxZ",
  vim.tbl_extend("force", dotfiles_priv_git_opts,
    {
      desc = "dots priv status (fullscreen)",
      prompt = "DotsPrivStatus> ",
      cmd = "git status -s",
      winopts = {
        fullscreen = true,
        preview = {
          vertical = "down:70%",
          horizontal = "right:70%",
        }
      }
    }))
