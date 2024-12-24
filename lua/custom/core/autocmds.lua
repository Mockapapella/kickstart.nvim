-- [[ Basic Autocommands ]]
local M = {}

function M.setup()
  -- Highlight when yanking (copying) text
  vim.api.nvim_create_autocmd('TextYankPost', {
    desc = 'Highlight when yanking (copying) text',
    group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
    callback = function()
      vim.highlight.on_yank()
    end,
  })

  -- Format buffer keymap
  vim.keymap.set('n', '<leader>F', function()
    require('conform').format({ async = true, lsp_fallback = true })
  end, { desc = 'Format buffer' })

  -- File type configurations
  vim.filetype.add({
    extension = {
      jsx = 'javascriptreact',
      tsx = 'typescriptreact',
    },
    filename = {
      ['next.config.js'] = 'javascript',
      ['next.config.mjs'] = 'javascript',
    },
    pattern = {
      ['%.js'] = {
        priority = -1,
        function(path, bufnr)
          return require('guess-indent').guess_indent(bufnr).type == 'space' and 'javascript' or 'javascriptreact'
        end,
      },
      ['%.ts'] = {
        priority = -1,
        function(path, bufnr)
          return require('guess-indent').guess_indent(bufnr).type == 'space' and 'typescript' or 'typescriptreact'
        end,
      },
      ['.*/templates/.*%.html'] = 'htmldjango',
    },
  })

  -- TypeScript specific keymaps
  vim.api.nvim_create_autocmd('FileType', {
    pattern = { 'javascriptreact', 'typescriptreact' },
    callback = function()
      vim.keymap.set('n', '<leader>ri', ':TypescriptAddMissingImports<CR>', { buffer = true })
      vim.keymap.set('n', '<leader>ro', ':TypescriptOrganizeImports<CR>', { buffer = true })
      vim.keymap.set('n', '<leader>ru', ':TypescriptRemoveUnused<CR>', { buffer = true })
    end,
  })
end

return M
