-- [[ Basic Keymaps ]]
local map = vim.keymap.set
local default_opts = { noremap = true, silent = true }

-- Clear search highlight on pressing <Esc> in normal mode
map('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- Diagnostic keymaps
map('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous [D]iagnostic message' })
map('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next [D]iagnostic message' })
map('n', '<leader>r', vim.diagnostic.open_float, { desc = 'Show diagnostic [E]rror messages' })
map('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

-- Exit terminal mode
map('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- Window navigation
map('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
map('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
map('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
map('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

-- Custom Keybinds
map('n', '<C-d>', '<C-d>zz', default_opts)
map('n', '<C-u>', '<C-u>zz', default_opts)
map('n', '<leader>gg', ':Neogit<CR>', default_opts)
map('n', '<leader>gd', ':DiffviewOpen<CR>', default_opts)
map('n', '<leader>gc', ':DiffviewClose<CR>', default_opts)
map('n', '<leader>gl', ':Neogit log<CR>', default_opts)
map('n', 'yui', '0ggVGY', { desc = 'Copy entire file' })
map('n', 'yup', '0ggVGp', { desc = 'Paste over entire file' })

-- Window resizing
map('n', '<A-Up>', ':resize +2<CR>', default_opts)
map('n', '<A-Down>', ':resize -2<CR>', default_opts)
map('n', '<A-Left>', ':vertical resize -2<CR>', default_opts)
map('n', '<A-Right>', ':vertical resize +2<CR>', default_opts)

-- Larger resizing
map('n', '<C-A-Up>', ':resize +10<CR>', default_opts)
map('n', '<C-A-Down>', ':resize -10<CR>', default_opts)
map('n', '<C-A-Left>', ':vertical resize -10<CR>', default_opts)
map('n', '<C-A-Right>', ':vertical resize +10<CR>', default_opts)

-- Format command
vim.api.nvim_create_user_command('Fmt', function()
  local filepath = vim.fn.expand('%:p')
  vim.fn.system('pre-commit run --files ' .. filepath)
  vim.cmd('e!')
end, {})

-- Return the module
return {}
