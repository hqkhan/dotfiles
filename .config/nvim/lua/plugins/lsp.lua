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
      require("lsp.diag")
      require("lsp.icons")
      require("fidget").setup({})
      require("mason").setup()
      require("mason-lspconfig").setup({
        ensure_installed = not utils.is_NetBSD()
            and not utils.is_iSH()
            and { "lua_ls" }
            or nil,
        automatic_installation = { exclude = { "jdtls" } },
        handlers = {
          function(server_name)
            if server_name == "jdtls" then return end
            require("lspconfig")[server_name].setup({})
          end,
        },
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
