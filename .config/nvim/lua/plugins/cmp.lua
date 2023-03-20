local M = {
  "hrsh7th/nvim-cmp",
  event = "InsertEnter",
  dependencies = {
    "hrsh7th/cmp-path",
    "hrsh7th/cmp-buffer",
    "hrsh7th/cmp-cmdline",
    "hrsh7th/cmp-nvim-lsp",
    "hrsh7th/cmp-nvim-lua",
    "saadparwaiz1/cmp_luasnip",
  },
}
M.config = function()
  local cmp = require("cmp")
  local luasnip = require("luasnip")

  cmp.setup {
    snippet = {
      -- must use a snippet engine
      expand = function(args)
        luasnip.lsp_expand(args.body)
      end,
    },

    window = {
      -- completion = { border = 'single' },
      -- documentation = { border = 'single' },
    },

    completion = {
      -- start completion immediately
      keyword_length = 4,
    },


    sources = {
      { name = 'nvim_lsp' },
      { name = 'nvim_lua' },
      { name = 'luasnip' },
      { name = 'path' },
      { name = 'buffer' },
    },

    -- we use 'comleteopt=...,noselect' but we still want cmp to autoselect
    -- an item if recommended by the LSP server (try with gopls, rust_analyzer)
    -- uncomment to disable
    -- preselect = cmp.PreselectMode.None,

      mapping = {
          ['<C-j>'] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
          ['<C-k>'] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
          ['<Tab>'] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
          ['<S-Tab>'] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
          ["<C-p>"] = cmp.mapping.scroll_docs(-4),
          ["<C-n>"] = cmp.mapping.scroll_docs(4),
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<C-e>"] = cmp.mapping.close(),
          ["<CR>"] = cmp.mapping.confirm({ select = true }),
      },

    formatting = {
      deprecated = false,
      fields = { "kind", "abbr", "menu" },
      format = function(entry, vim_item)

          local source_names = {
            path = "Path",
            buffer = "Buffer",
            cmdline = "Cmdline",
            luasnip = "LuaSnip",
            nvim_lua = "Lua",
            nvim_lsp = "LSP",
          }

          vim_item.menu = ("%-10s [%s]"):format(
            vim_item.kind,
            source_names[entry.source.name] or entry.source.name)

          -- get the item kind icon from our LSP settings
          local kind_idx = vim.lsp.protocol.CompletionItemKind[vim_item.kind]
          if tonumber(kind_idx) > 0 then
            vim_item.kind = vim.lsp.protocol.CompletionItemKind[kind_idx]
          end

          return vim_item
      end,
    },

    -- DO NOT ENABLE
    -- just for testing with nvim native completion menu
    experimental = {
      native_menu = false,
      ghost_text = true,
    },
  }

  -- Use buffer source for `/` (if you enabled `native_menu`, this won't work anymore).
  cmp.setup.cmdline('/', {
    sources = {
      { name = 'buffer' }
    }
  })

  -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
  cmp.setup.cmdline(':', {
    sources = cmp.config.sources({
      { name = 'path' }
    }, {
      { name = 'cmdline' }
    })
  })
end

return M
