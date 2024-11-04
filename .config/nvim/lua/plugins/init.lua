return {
  {
    "dstein64/vim-startuptime",
    cmd = "StartupTime",
  },
  -- SmartYank (by ibhagwan)
  {
    "ibhagwan/smartyank.nvim",
    config = function()
      require("smartyank").setup({ highlight = { timeout = 100 } })
    end,
    event = "VeryLazy",
    dev = require("utils").is_dev("smartyank.nvim")
  },
  -- plenary is required by gitsigns and telescope
  { "nvim-lua/plenary.nvim" },
  {
    "nvchad/nvim-colorizer.lua",
    config = function()
      require("colorizer").setup()
    end,
    cmd = { "ColorizerAttachToBuffer", "ColorizerDetachFromBuffer" },
  },
  {
    "junegunn/fzf.vim",
    enabled = false,
    lazy = false,
    dev = true,
  },
  {
    "MunifTanjim/nui.nvim",
    -- "VeryLazy" hides splash screen
    event = "VeryLazy",
  },
  {
    "rcarriga/nvim-notify",
    -- "VeryLazy" hides splash screen
    event = "VeryLazy",
  },
  {
    'tzachar/highlight-undo.nvim',
    event = "VeryLazy",
    config = function()
      require('highlight-undo').setup({
        duration = 300,
        keymaps = {
          undo = {
            desc = "undo",
            hlgroup = 'HighlightUndo',
            mode = 'n',
            lhs = 'u',
            rhs = nil,
            opts = {},
          },
          redo = {
            desc = "redo",
            hlgroup = 'HighlightUndo',
            mode = 'n',
            lhs = '<C-r>',
            rhs = nil,
            opts = {},
          },
        },
      })
    end
  },
  {
    "neanias/everforest-nvim",
    version = false,
    lazy = false,
    priority = 1000, -- make sure to load this before all the other start plugins
    -- Optional; default configuration will be used if setup isn't called.
    config = function()
      require("everforest").setup({
        on_highlights = function(hl, palette)
          hl.StatusLine = { link = "Normal" }
          hl.Darkblue_tmux_bg = { bg = "#081633" }
          hl.CursorLine = { bg = "#100E23" }
          hl.CursorLineNr = { fg = palette.grey1, bg = "#081633" }
          hl.MiniIndentscopeSymbol = { fg = palette.yellow }
          hl.GitSignsAdd = { link = "GreenSign" }
          hl.GitSignsChange = { link = "YellowSign" }
          hl.Visual = { link = "IncSearch" }
          hl.HighlightUndo = { fg = "#100E23", bg = palette.yellow }
        end
      })
    end,
  }
}
