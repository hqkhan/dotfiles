return {
  { "j-hui/fidget.nvim",
    tag = "legacy",
    config = function()
      require("fidget").setup()
    end
  },
  {
    "williamboman/mason-lspconfig.nvim",
    config = function()
      require("mason-lspconfig").setup({
        ensure_installed = not require("utils").is_NetBSD() and { "lua_ls" } or nil,
      })
    end
  },
  {
    "neovim/nvim-lspconfig",
    event = "BufReadPre",
    dependencies = { "hrsh7th/cmp-nvim-lsp" },
    config = function()
      require("fidget")
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
