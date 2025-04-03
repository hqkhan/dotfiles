local ok, lspconfig = pcall(require, "lspconfig")
if not ok then return end

-- Setup icons & handler helper functions
require('lsp.diag')
require('lsp.icons')
require('lsp.handlers')

-- Enable borders for hover/signature help
vim.lsp.handlers["textDocument/hover"] =
    vim.lsp.with(vim.lsp.handlers.hover, { border = "rounded" })
vim.lsp.handlers["textDocument/signatureHelp"] =
    vim.lsp.with(vim.lsp.handlers.signature_help, { border = "rounded" })

-- Custom root dir function that ignores "$HOME/.git" for lua files in $HOME
-- which will then run the LSP in single file mdoe, otherwise will err with:
--   LSP[lua_ls] Your workspace is set to `$HOME`.
--   Lua language server refused to load this directory.
--   Please check your configuration.
--   [learn more here](https://luals.github.io/wiki/faq#why-is-the-server-scanning-the-wrong-folder)
-- Reuse ".../nvim-lspconfig/lua/lspconfig/configs/lua_ls"
local lua_root_dir = function(fname)
  local lua_ls = require "lspconfig.configs.lua_ls".default_config
  local root = lua_ls.root_dir(fname)
  -- NOTE: although returning `nil` here does nullify the "rootUri" property lua_ls still
  -- displays the error, I'm not sure if returning an empty string is the correct move as
  -- it generates "rootUri = "file://" but it does seem to quiet lua_ls and make it work
  -- as if it was started in single file mode
  return root and root ~= vim.env.HOME and root or ""
end

local custom_settings = {
  ["lua_ls"] = {
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
        server = {
          path = "~/.toolbox/bin/rust_analyzer"
        },
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
  'jdtls',
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

local function make_config(srv)
  local capabilities = vim.lsp.protocol.make_client_capabilities()
  -- enables snippet support
  capabilities.textDocument.completion.completionItem.snippetSupport = true
  -- enables LSP autocomplete, prioritize blink over cmp
  local blink_loaded, blink = pcall(require, "blink.cmp")
  if blink_loaded then
    capabilities = blink.get_lsp_capabilities()
  else
    local cmp_loaded, cmp_lsp = pcall(require, "cmp_nvim_lsp")
    if cmp_loaded then
      capabilities = cmp_lsp.default_capabilities()
    end
  end
  return {
    on_attach = require("lsp.on_attach").on_attach,
    capabilities = capabilities,
    root_dir = srv == "lua_ls" and lua_root_dir or nil,
  }
end

for _, srv in ipairs(all_servers) do
  local cfg = make_config()
  if custom_settings[srv] then
    cfg = vim.tbl_deep_extend("force", custom_settings[srv], cfg)
  end
  if is_installed(lspconfig[srv]) and srv ~= "jdtls" then
    lspconfig[srv].setup(cfg)
  end
end

if is_installed(lspconfig["jdtls"]) then
  require("lspconfig").jdtls.setup({
    capabilities = make_config().capabilities,
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
      "--jvm-arg=-javaagent:" .. require("mason-registry")
      .get_package("jdtls")
      :get_install_path() .. "/lombok.jar",
    },
  })
end
