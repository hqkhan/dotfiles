local ok, lspconfig = pcall(require, "lspconfig")
if not ok then return end

-- Setup icons & handler helper functions
require('lsp.diag')
require('lsp.icons')
require('lsp.handlers')

local custom_settings = {
  ["lua_ls"] = {
    -- uncomment to enable trace logging into:
    -- '~/.local/share/nvim/mason/packages/lua-language-server/log'
    -- cmd = { "lua-language-server", "--loglevel=trace" },
    settings = {
      Lua = {
        telemetry = { enable = false },
        -- removes the annoying "Do you need to configure your work environment as"
        -- when opening a lua project that doesn't have a '.luarc.json'
        workspace = { checkThirdParty = false }
      }
    }
  },

  ['rust_analyzer'] = {
    settings = {
      ["rust-analyzer"] = {
        rustfmt = {
          -- extraArgs = { "+nightly", },
        },
        checkOnSave = {
          command = "clippy",
          extraArgs = { "--no-deps" },
        }
      }
    }
  },

  ['ccls'] = {
    init_options = {
      codeLens = {
        enabled = false,
        renderInline = false,
        localVariables = false,
      }
    }
  }
}

local manually_installed_servers = {
  'lua_ls',
  'rust_analyzer',
  'gopls',
  'pyright',
  'clangd',
}

local all_servers = (function()
  -- use map for dedup
  local srv_map = {}
  local srv_tbl = {}
  local srv_iter = function(t)
    for _, s in ipairs(t) do
      if not srv_map[s] then
        srv_map[s] = true
        table.insert(srv_tbl, s)
      end
    end
  end
  srv_iter(manually_installed_servers)
  srv_iter(require("mason-lspconfig").get_installed_servers())
  return srv_tbl
end)()

local function is_installed(cfg)
  local cmd = cfg.document_config
      and cfg.document_config.default_config
      and cfg.document_config.default_config.cmd
      or nil
  -- server binary is executable within neovim's PATH
  return cmd and cmd[1] and vim.fn.executable(cmd[1]) == 1
end

local function make_config()
  local capabilities = vim.lsp.protocol.make_client_capabilities()
  -- enables snippet support
  capabilities.textDocument.completion.completionItem.snippetSupport = true
  -- enables LSP autocomplete
  local cmp_loaded, cmp_lsp = pcall(require, "cmp_nvim_lsp")
  if cmp_loaded then
    capabilities = cmp_lsp.default_capabilities()
  end
  return {
    on_attach = require("lsp.on_attach").on_attach,
    capabilities = capabilities,
  }
end

for _, srv in ipairs(all_servers) do
  local cfg = make_config()
  if custom_settings[srv] then
    cfg = vim.tbl_deep_extend("force", custom_settings[srv], cfg)
  end
  if is_installed(lspconfig[srv]) then
    lspconfig[srv].setup(cfg)
  end
end
