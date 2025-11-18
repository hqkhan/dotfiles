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
      require("fidget").setup({})
      require("mason").setup()
      require("mason-lspconfig").setup({
        ensure_installed = not utils.is_NetBSD()
            and not utils.is_iSH()
            and { "lua_ls" }
            or nil,
      })

      -- JDTLS
      vim.lsp.config('jdtls', {
        on_attach = function()
          vim.api.nvim_buf_set_option(0, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
          local map = function(mode, lhs, rhs, opts)
                opts = vim.tbl_extend("keep", opts, { silent = true, buffer = true })
                vim.keymap.set(mode, lhs, rhs, opts)
              end,
          -- Get basic mappings
          vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
          vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
          vim.keymap.set('n', '<space>k', vim.lsp.buf.hover, bufopts)
          vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
          vim.keymap.set('n', '<leader>s', vim.lsp.buf.signature_help, bufopts)
          vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, bufopts)
          vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, bufopts)
          vim.keymap.set('n', '<space>wl', function()
            print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
          end, bufopts)
          vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, bufopts)
          vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, bufopts)
          vim.keymap.set('n', '<space>ca', vim.lsp.buf.code_action, bufopts)
          vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)
          -- vim.keymap.set('n', '<space>f', vim.lsp.buf.formatting, bufopts)
          vim.keymap.set("n", "gS", vim.lsp.buf.document_symbol, keymap_opts)
          vim.keymap.set("n", "gs", vim.lsp.buf.workspace_symbol, keymap_opts)

          map('n', '<space>k', '<cmd>lua vim.lsp.buf.hover()<CR>',
            { desc = "hover information [LSP]" })
          map('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>',
            { desc = "goto definition [LSP]" })
          map('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>',
            { desc = "goto declaration [LSP]" })
          map('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>',
            { desc = "goto reference [LSP]" })
          map('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>',
            { desc = "goto implementation [LSP]" })
          map('n', '<space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>',
            { desc = "goto type definition [LSP]" })
          map('n', '<space>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>',
            { desc = "code actions [LSP]" })
          map('v', '<space>rca', '<cmd>lua vim.lsp.buf.range_code_action()<CR>',
            { desc = "range code actions [LSP]" })
          -- use our own rename popup implementation
          map('n', '<leader>lR', '<cmd>lua require("lsp.rename").rename()<CR>',
            { desc = "rename [LSP]" })
          map('n', '<space>K', '<cmd>lua vim.lsp.buf.signature_help()<CR>',
            { desc = "signature help [LSP]" })
          map('n', '<space>d', '<cmd>lua require("lsp.handlers").peek_definition()<CR>',
            { desc = "peek definition [LSP]" })

          map('n', '<leader>lt', "<cmd>lua require'lsp.diag'.toggle()<CR>",
            { desc = "toggle virtual text [LSP]" })

          -- neovim PR #16057
          -- https://github.com/neovim/neovim/pull/16057
          local winopts = "{ float =  { border = 'rounded' } }"
          map('n', '[d', ('<cmd>lua vim.diagnostic.goto_prev(%s)<CR>'):format(winopts),
            { desc = "previous diagnostic [LSP]" })
          map('n', ']d', ('<cmd>lua vim.diagnostic.goto_next(%s)<CR>'):format(winopts),
            { desc = "next diagnostic [LSP]" })
          map('n', '<leader>lc', '<cmd>lua vim.diagnostic.reset()<CR>',
            { desc = "clear diagnostics [LSP]" })
          map('n', '<leader>ll', '<cmd>lua vim.diagnostic.open_float(0, { scope = "line", border = "rounded" })<CR>',
            { desc = "show line diagnostic [LSP]" })
          map('n', '<leader>lq', '<cmd>lua vim.diagnostic.setqflist()<CR>',
            { desc = "send diagnostics to quickfix [LSP]" })
          map('n', '<leader>lQ', '<cmd>lua vim.diagnostic.setloclist()<CR>',
            { desc = "send diagnostics to loclist [LSP]" })
          local bemol_dir = vim.fs.find({ ".bemol" }, { upward = true, type = "directory" })[1]
          local ws_folders_lsp = {}
          if bemol_dir then
            local file = io.open(bemol_dir .. "/ws_root_folders", "r")
            if file then
              for line in file:lines() do
                table.insert(ws_folders_lsp, line)
              end
              file:close()
            end
          end
          local folders = vim.lsp.buf.list_workspace_folders()
          for _, line in ipairs(ws_folders_lsp) do
            local is_not_in_workspace = true
            for _, folder in ipairs(folders) do
              if folder == line then
                is_not_in_workspace = false
              end
            end
            if is_not_in_workspace then
              vim.lsp.buf.add_workspace_folder(line)
            end
          end
        end,
        cmd = {
          "jdtls",
          "--jvm-arg=-javaagent:" .. vim.fn.globpath(vim.env.MASON .. "/share/jdtls/", "lombok.jar", true, true)[1]
        },
        ft = "java",
      })

    end,
  },
  {
    "mfussenegger/nvim-jdtls",
    ft = "java",
  },
  {
    "ray-x/lsp_signature.nvim",
    event = "InsertEnter",
    opts = {
      -- cfg options
    },
  }
}
