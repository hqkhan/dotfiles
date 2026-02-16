local utils = require("utils")

return {
  {
    "williamboman/mason-lspconfig.nvim",
    enabled = utils.__HAS_NVIM_011,
    event = { "VeryLazy", "BufReadPre" },
    dependencies = {
      { "neovim/nvim-lspconfig" },
      { "mason-org/mason.nvim" },
      { "j-hui/fidget.nvim" },
    },
    config = function()
      -- Add the same capabilities to ALL server configurations.
      -- Refer to :h vim.lsp.config() for more information.
      vim.lsp.config("*", {
        capabilities = vim.lsp.protocol.make_client_capabilities()
      })

      require("lsp.diag")
      require("lsp.icons")
      require("lsp.keymaps")
      require("fidget").setup({})
      require("mason").setup()
      require("mason-lspconfig").setup({
        ensure_installed = not utils.is_NetBSD()
            and not utils.is_iSH()
            and { "lua_ls" }
            or nil,
      })
    end,
  },
  {
    "mfussenegger/nvim-jdtls",
    ft = "java",
  },
  {
    "ray-x/lsp_signature.nvim",
    enabled = false,
    event = "InsertEnter",
    opts = {
      -- cfg options
    },
  }
}
