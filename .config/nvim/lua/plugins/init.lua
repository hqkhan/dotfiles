return {
  {
    "bluz71/vim-nightfly-guicolors",
    lazy = false,
    priority = 1000,
  },
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
}
