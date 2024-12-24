-- [[ Setting options ]]
-- See `:help vim.opt`

local opt = vim.opt
local g = vim.g

-- Set <space> as the leader key
-- See `:help mapleader`
g.mapleader = ' '
g.maplocalleader = ' '

-- Set to true if you have a Nerd Font installed
g.have_nerd_font = true

-- Make line numbers default with relative numbers
opt.number = true
opt.relativenumber = true

-- Enable mouse mode
opt.mouse = 'a'

-- Don't show the mode, since it's already in status line
opt.showmode = false

-- Sync clipboard between OS and Neovim.
opt.clipboard = 'unnamedplus'

-- Enable break indent
opt.breakindent = true

-- Save undo history
opt.undofile = true

-- Case-insensitive searching UNLESS \C or capital in search
opt.ignorecase = true
opt.smartcase = true

-- Keep signcolumn on by default
opt.signcolumn = 'yes'

-- Decrease update time
opt.updatetime = 250
opt.timeoutlen = 300

-- Configure how new splits should be opened
opt.splitright = true
opt.splitbelow = true

-- Sets how neovim will display certain whitespace
opt.list = true
opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

-- Preview substitutions live
opt.inccommand = 'split'

-- Show which line your cursor is on
opt.cursorline = true

-- Minimal number of screen lines to keep above and below the cursor.
opt.scrolloff = 10

-- Set highlight on search, but clear on pressing <Esc> in normal mode
opt.hlsearch = true

-- Set GUI font
opt.guifont = { 'UbuntuMono Nerd Font', ':h12' }
