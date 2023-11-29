local M = {}
local fzf_lua = require("fzf-lua")

function M.git_status_tmuxZ(opts)
  local function tmuxZ()
    vim.cmd("!tmux resize-pane -Z")
  end
  opts = opts or {}
  opts.fn_pre_win = function(_)
    if not opts.__want_resume then
      -- new fzf window, set tmux Z
      -- add small delay or fzf
      -- win gets wrong dimensions
      tmuxZ()
      vim.cmd("sleep! 20m")
    end
    opts.__want_resume = nil
  end
  opts.fn_post_fzf = function(_, s)
    opts.__want_resume = s and (s[1] == 'left' or s[1] == 'right')
    if not opts.__want_resume then
      -- resume asked do not resize
      -- signals fn_pre to do the same
      tmuxZ()
    end
  end
  fzf_lua.git_status(opts)
end

function M.git_bcommits(opts)
  local function diffthis(action)
    return function(...)
      local curwin = vim.api.nvim_get_current_win()
      action(...)
      vim.cmd("windo diffthis")
      vim.api.nvim_set_current_win(curwin)
    end
  end
  print("HERE")

  opts.actions = {
    ["ctrl-v"] = diffthis(fzf_lua.actions.git_buf_vsplit),
  }
  return fzf_lua.git_bcommits(opts)
end

return M
