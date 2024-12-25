local M = {}

-- LSP Attach function
local function on_attach(event)
  local map = function(keys, func, desc)
    vim.keymap.set('n', keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
  end

  -- LSP Keymaps
  map('gd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')
  map('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
  map('gI', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')
  map('<leader>D', require('telescope.builtin').lsp_type_definitions, 'Type [D]efinition')
  map('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')
  map('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')
  map('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
  map('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')
  map('K', vim.lsp.buf.hover, 'Hover Documentation')
  map('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')

  -- Document highlight
  local client = vim.lsp.get_client_by_id(event.data.client_id)
  if client and client.server_capabilities.documentHighlightProvider then
    vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
      buffer = event.buf,
      callback = vim.lsp.buf.document_highlight,
    })

    vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
      buffer = event.buf,
      callback = vim.lsp.buf.clear_references,
    })
  end
end

-- Server Configurations
local servers = {
  ruff = {
    on_attach = function(client, bufnr)
      client.server_capabilities.hoverProvider = false
    end,
    init_options = {
      settings = {
        args = {
          '--select=EFWINDUPANNSBLEBACOMC4T20PTQSIMARGERAPLRUF',
          '--extend-select=YTTTCHQEMICN',
          '--ignore=E501E203E402',
          '--line-length=100',
          '--fix',
        },
      },
    },
  },
  pyright = {
    on_attach = function(client, bufnr)
      client.server_capabilities.documentFormattingProvider = false
      client.server_capabilities.documentRangeFormattingProvider = false
    end,
    settings = {
      python = {
        analysis = {
          autoSearchPaths = true,
          useLibraryCodeForTypes = true,
          diagnosticMode = 'openFilesOnly',
          typeCheckingMode = 'basic',
        },
      },
    },
  },
  lua_ls = {
    settings = {
      Lua = {
        completion = {
          callSnippet = 'Replace',
        },
      },
    },
  },
  ['typescript-language-server'] = {
    filetypes = { 'typescript', 'typescriptreact', 'typescript.tsx', 'javascript', 'javascriptreact', 'javascript.jsx' },
    cmd = { 'typescript-language-server', '--stdio' },
    init_options = {
      hostInfo = 'neovim',
    },
    settings = {
      typescript = {
        inlayHints = {
          includeInlayParameterNameHints = 'all',
          includeInlayParameterNameHintsWhenArgumentMatchesName = false,
          includeInlayFunctionParameterTypeHints = true,
          includeInlayVariableTypeHints = true,
          includeInlayPropertyDeclarationTypeHints = true,
          includeInlayFunctionLikeReturnTypeHints = true,
          includeInlayEnumMemberValueHints = true,
        },
      },
      javascript = {
        inlayHints = {
          includeInlayParameterNameHints = 'all',
          includeInlayParameterNameHintsWhenArgumentMatchesName = false,
          includeInlayFunctionParameterTypeHints = true,
          includeInlayVariableTypeHints = true,
          includeInlayPropertyDeclarationTypeHints = true,
          includeInlayFunctionLikeReturnTypeHints = true,
          includeInlayEnumMemberValueHints = true,
        },
      },
    },
  },
}

function M.setup()
  -- LSP Setup
  local capabilities = vim.lsp.protocol.make_client_capabilities()
  capabilities = vim.tbl_deep_extend('force', capabilities, require('cmp_nvim_lsp').default_capabilities())

  -- Create LSP attach autocommand
  vim.api.nvim_create_autocmd('LspAttach', {
    group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
    callback = on_attach,
  })

  -- Setup Mason
  require('mason').setup()
  require('mason-lspconfig').setup {
    ensure_installed = { 'typescript-language-server' },
  }

  -- Ensure servers are installed
  local ensure_installed = vim.tbl_keys(servers or {})
  vim.list_extend(ensure_installed, {
    'typescript-language-server',
  })

  require('mason-tool-installer').setup {
    ensure_installed = ensure_installed,
    auto_update = false,
    run_on_start = true,
  }

  -- Setup handlers
  require('mason-lspconfig').setup {
    handlers = {
      function(server_name)
        local server = servers[server_name] or {}
        server.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server.capabilities or {})
        require('lspconfig')[server_name].setup(server)
      end,
    },
  }

  -- TypeScript specific setup
  require('lspconfig')['typescript-language-server'].setup(servers['typescript-language-server'])

  -- TypeScript keymaps
  vim.api.nvim_create_autocmd('FileType', {
    pattern = { 'typescript', 'javascript', 'typescriptreact', 'javascriptreact' },
    callback = function()
      vim.keymap.set('n', '<leader>ri', ':TypescriptAddMissingImports<CR>', { buffer = true })
      vim.keymap.set('n', '<leader>ro', ':TypescriptOrganizeImports<CR>', { buffer = true })
      vim.keymap.set('n', '<leader>ru', ':TypescriptRemoveUnused<CR>', { buffer = true })
    end,
  })

  -- Python formatting on save
  vim.api.nvim_create_autocmd('BufWritePre', {
    pattern = '*.py',
    callback = function()
      vim.lsp.buf.format({ async = false, name = 'ruff' }) -- Changed from ruff_lsp to ruff
    end,
  })

  -- Format keymap
  vim.api.nvim_set_keymap('n', '<leader>rf', '<cmd>lua vim.lsp.buf.format({name = "ruff"})<CR>', { noremap = true, silent = true }) -- Changed from ruff_lsp to ruff
end

return M
