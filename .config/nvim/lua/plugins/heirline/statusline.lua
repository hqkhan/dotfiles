local conditions = require("heirline.conditions")
-- local utils = require("heirline.utils")

local Space = { provider = " " }
local Align = { provider = "%=" }

local Git = {
  condition = conditions.is_git_repo,
  init = function(self)
    self.status_dict = vim.b.gitsigns_status_dict
    self.has_changes = self.status_dict.added ~= 0 or self.status_dict.removed ~= 0 or self.status_dict.changed ~= 0
  end,
  static = {
    icon_insert = " ",
    icon_change = " ",
    icon_delete = " "
  },

  {
    provider = function(self)
      local count = self.status_dict.added or 0
      return count > 0 and (self.icon_insert .. count .. " ")
    end,
    hl = { fg = "green_fg" },
  },
  {
    provider = function(self)
      local count = self.status_dict.removed or 0
      return count > 0 and (self.icon_delete .. count .. " ")
    end,
    hl = { fg = "red_fg", bg = "normal" },
  },
  {
    provider = function(self)
      local count = self.status_dict.changed or 0
      return count > 0 and (self.icon_change .. count .. " ")
    end,
    hl = { fg = "yellow_fg" },
  },
}

local Diagnostics = {
  condition = conditions.has_diagnostics,
  --[[ static = {
        error_icon = vim.fn.sign_getdefined("DiagnosticSignError")[1].text,
        warn_icon = vim.fn.sign_getdefined("DiagnosticSignWarn")[1].text,
        info_icon = vim.fn.sign_getdefined("DiagnosticSignInfo")[1].text,
        hint_icon = vim.fn.sign_getdefined("DiagnosticSignHint")[1].text,
    }, ]]
  static = {
    error_icon = ' ',
    warn_icon = ' ',
    info_icon = ' ',
    hint_icon = ' '
  },
  init = function(self)
    self.errors = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.ERROR })
    self.warnings = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.WARN })
    self.hints = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.HINT })
    self.info = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.INFO })
  end,

  update = { "DiagnosticChanged", "BufEnter" },
  {
    provider = function(self)
      -- 0 is just another output, we can decide to print it or not!
      return self.errors > 0 and (self.error_icon .. self.errors .. " ")
    end,
    hl = { fg = "red_fg", bg = "normal" },
  },
  {
    provider = function(self)
      return self.warnings > 0 and (self.warn_icon .. self.warnings .. " ")
    end,
    hl = { fg = "yellow_fg", bg = "normal" },
  },
  {
    provider = function(self)
      return self.info > 0 and (self.info_icon .. self.info .. " ")
    end,
    hl = { fg = "green_fg", bg = "normal" },
  },
  {
    provider = function(self)
      return self.hints > 0 and (self.hint_icon .. self.hints .. " ")
    end,
    hl = { fg = "green_fg", bg = "normal" },
  },
}

local FileName = {
  -- flexible: shorten path if space doesn't allow for full path
  flexible = 2,
  init = function(self)
    -- make relative, see :h filename-modifers
    self.relname = vim.fn.fnamemodify(self.filename, ":.")
    if self.relname == "" then self.relname = "[No Name]" end
  end,
  {
    provider = function(self)
      return self.relname
    end,
  },
  {
    provider = function(self)
      return vim.fn.pathshorten(self.relname)
    end,
  },
  {
    provider = function(self)
      return vim.fn.fnamemodify(self.filename, ":t")
    end,
  },
  hl = { fg = "red_fg", bg = "dark_tmux_bg" },
}

local FileIcon = {
  init = function(self)
    local filename = self.filename
    local extension = vim.fn.fnamemodify(filename, ":e")
    self.icon, self.icon_color = require("nvim-web-devicons").get_icon_color(filename, extension, { default = true })
  end,
  provider = function(self)
    return self.icon and (self.icon .. " ")
  end,
  hl = function(self)
    return { fg = self.icon_color, bg = "dark_tmux_bg" }
  end
}

local FileFlags = {
  {
    condition = function()
      return vim.bo.modified
    end,
    provider = "[+]",
    hl = { fg = "green_fg", bg = "normal" },
  },
  {
    condition = function()
      return not vim.bo.modifiable or vim.bo.readonly
    end,
    provider = "",
    hl = { fg = "orange", bg = "normal" },
  },
}

local FileNameBlock = {
  update = { "DirChanged", "BufModifiedSet", "VimResized", "BufEnter" },
  init = function(self)
    self.filename = vim.api.nvim_buf_get_name(0)
  end,
  static = {
    right_sepr = '',
    left_sepr = '',
    right_sepr_thin = '',
    left_sepr_thin = ''
  },
  {
    condition = function(self)
      return self.filename ~= "[No Name]"
    end
  },

  {
    provider = function(self)
      return self.left_sepr
    end,
    hl = { fg = "dark_tmux_fg", bg = "normal" }
  },
  {  provider = " ", hl = { fg = "dark_tmux_fg", bg = "dark_tmux_bg" } },
  FileIcon,
  FileName,
  {  provider = " ", hl = { fg = "dark_tmux_fg", bg = "dark_tmux_bg" } },
  {
    provider = function(self)
      return self.right_sepr
    end,
    hl = { fg = "dark_tmux_fg", bg = "normal" }
  },
  FileFlags,
  { provider = "%<" } -- cut here when there's not enough space
}

local MacroRec = {
  condition = function()
    return vim.fn.reg_recording() ~= "" and vim.o.cmdheight == 0
  end,
  provider = function()
    return "󱜨 @" .. vim.fn.reg_recording() .. "  "
  end,
  hl = { fg = "red_fg", bold = true },
  update = {
    "RecordingEnter",
    "RecordingLeave",
  }
}

local DefaultStatusLine = {
  MacroRec, Git, Diagnostics, Space, Align, -- Left
  FileNameBlock, Align,                     -- Middle
  Space,                                    -- Right
}

return {
  hl = "StatusLine",
  -- fallthrough = false,
  DefaultStatusLine,
}
