-- Set leader key first, before anything else
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Other essential options
vim.g.have_nerd_font = true

-- Basic vim options
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.mouse = 'a'
vim.opt.showmode = false
vim.opt.clipboard = 'unnamedplus'
vim.opt.breakindent = true
vim.opt.undofile = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.signcolumn = 'yes'
vim.opt.updatetime = 250
vim.opt.timeoutlen = 300
vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }
vim.opt.inccommand = 'split'
vim.opt.cursorline = true
vim.opt.scrolloff = 10

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
  vim.fn.system {
    'git',
    'clone',
    '--filter=blob:none',
    '--branch=stable',
    lazyrepo,
    lazypath,
  }
end
vim.opt.rtp:prepend(lazypath)

-- Configure plugins
local plugins = require 'custom'
require('lazy').setup(plugins, {
  ui = {
    icons = vim.g.have_nerd_font and {} or {
      cmd = '⌘',
      config = '🛠',
      event = '📅',
      ft = '📂',
      init = '⚙',
      keys = '🗝',
      plugin = '🔌',
      runtime = '💻',
      require = '🌙',
      source = '📄',
      start = '🚀',
      task = '📌',
      lazy = '💤',
    },
  },
})

-- Initialize core modules after plugins are loaded
vim.api.nvim_create_autocmd('User', {
  pattern = 'VeryLazy', -- Use VeryLazy instead of LazyDone for earlier initialization
  callback = function()
    -- Load core modules
    require 'custom.core.options'
    require 'custom.core.keymaps'
    require('custom.core.autocmds').setup()
    require('custom.utils.git').setup()
  end,
})

-- vim: ts=2 sts=2 sw=2 et
