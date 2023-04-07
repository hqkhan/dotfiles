return {
  { "j-hui/fidget.nvim" },
  { "williamboman/mason-lspconfig.nvim" },
  {
    "neovim/nvim-lspconfig",
    event = "BufReadPre",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
    },
    config = function()
      require("fidget").setup()
      require("mason-lspconfig").setup({
        -- ensure_installed = { "rust_analyzer" },
      })
      -- lazy load null-ls
      require("null-ls")
      require("lsp")
    end
  },
  {
    "ray-x/lsp_signature.nvim",
    event = "BufReadPre",
    config = function()
      local cfg = {}  -- add your config here
      require "lsp_signature".setup(cfg)
    end
  }
}
