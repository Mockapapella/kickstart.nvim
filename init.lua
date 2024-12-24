--[[

=====================================================================
==================== READ THIS BEFORE CONTINUING ====================
=====================================================================
========                                    .-----.          ========
========         .----------------------.   | === |          ========
========         |.-""""""""""""""""""-.|   |-----|          ========
========         ||                    ||   | === |          ========
========         ||   KICKSTART.NVIM   ||   |-----|          ========
========         ||                    ||   | === |          ========
========         ||                    ||   |-----|          ========
========         ||:Tutor              ||   |:::::|          ========
========         |'-..................-'|   |____o|          ========
========         `"")----------------(""`   ___________      ========
========        /::::::::::|  |::::::::::\  \ no mouse \     ========
========       /:::========|  |==hjkl==:::\  \ required \    ========
========      '""""""""""""'  '""""""""""""'  '""""""""""'   ========
========                                                     ========
=====================================================================
=====================================================================

What is Kickstart?

  Kickstart.nvim is *not* a distribution.

  Kickstart.nvim is a starting point for your own configuration.
    The goal is that you can read every line of code, top-to-bottom, understand
    what your configuration is doing, and modify it to suit your needs.

    Once you've done that, you can start exploring, configuring and tinkering to
    make Neovim your own! That might mean leaving kickstart just the way it is for a while
    or immediately breaking it into modular pieces. It's up to you!

    If you don't know anything about Lua, I recommend taking some time to read through
    a guide. One possible example which will only take 10-15 minutes:
      - https://learnxinyminutes.com/docs/lua/

    After understanding a bit more about Lua, you can use `:help lua-guide` as a
    reference for how Neovim integrates Lua.
    - :help lua-guide
    - (or HTML version): https://neovim.io/doc/user/lua-guide.html

Kickstart Guide:

  TODO: The very first thing you should do is to run the command `:Tutor` in Neovim.

    If you don't know what this means, type the following:
      - <escape key>
      - :
      - Tutor
      - <enter key>

    (If you already know how the Neovim basics, you can skip this step)

  Once you've completed that, you can continue working through **AND READING** the rest
  of the kickstart init.lua

  Next, run AND READ `:help`.
    This will open up a help window with some basic information
    about reading, navigating and searching the builtin help documentation.

    This should be the first place you go to look when you're stuck or confused
    with something. It's one of my favorite neovim features.

    MOST IMPORTANTLY, we provide a keymap "<space>sh" to [s]earch the [h]elp documentation,
    which is very useful when you're not sure exactly what you're looking for.

  I have left several `:help X` comments throughout the init.lua
    These are hints about where to find more information about the relevant settings,
    plugins or neovim features used in kickstart.

   NOTE: Look for lines like this

    Throughout the file. These are for you, the reader, to help understand what is happening.
    Feel free to delete them once you know what you're doing, but they should serve as a guide
    for when you are first encountering a few different constructs in your nvim config.

If you experience any errors while trying to install kickstart, run `:checkhealth` for more info

I hope you enjoy your Neovim journey,
- TJ

P.S. You can delete this when you're done too. It's your config now! :)
--]]

-- Set <space> as the leader key
-- See `:help mapleader`
--  NOTE: Must happen before plugins are loaded (otherwise wrong leader will be used)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Set to true if you have a Nerd Font installed
vim.g.have_nerd_font = true

-- [[ Setting options ]]
-- See `:help vim.opt`
-- NOTE: You can change these options as you wish!
--  For more options, you can see `:help option-list`

-- Make line numbers default
vim.opt.number = true
-- You can also add relative line numbers, for help with jumping.
--  Experiment for yourself to see if you like it!
vim.opt.relativenumber = true

-- Enable mouse mode, can be useful for resizing splits for example!
vim.opt.mouse = 'a'

-- Don't show the mode, since it's already in status line
vim.opt.showmode = false

-- Sync clipboard between OS and Neovim.
--  Remove this option if you want your OS clipboard to remain independent.
--  See `:help 'clipboard'`
vim.opt.clipboard = 'unnamedplus'

-- Enable break indent
vim.opt.breakindent = true

-- Save undo history
vim.opt.undofile = true

-- Case-insensitive searching UNLESS \C or capital in search
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Keep signcolumn on by default
vim.opt.signcolumn = 'yes'

-- Decrease update time
vim.opt.updatetime = 250

-- Decrease mapped sequence wait time
-- Displays which-key popup sooner
vim.opt.timeoutlen = 300

-- Configure how new splits should be opened
vim.opt.splitright = true
vim.opt.splitbelow = true

-- Sets how neovim will display certain whitespace in the editor.
--  See `:help 'list'`
--  and `:help 'listchars'`
vim.opt.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

-- Preview substitutions live, as you type!
vim.opt.inccommand = 'split'

-- Show which line your cursor is on
vim.opt.cursorline = true

-- Minimal number of screen lines to keep above and below the cursor.
vim.opt.scrolloff = 10

-- [[ Basic Keymaps ]]
--  See `:help vim.keymap.set()`

-- Set highlight on search, but clear on pressing <Esc> in normal mode
vim.opt.hlsearch = true
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- Diagnostic keymaps
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous [D]iagnostic message' })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next [D]iagnostic message' })
vim.keymap.set('n', '<leader>r', vim.diagnostic.open_float, { desc = 'Show diagnostic [E]rror messages' })
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

-- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
-- for people to discover. Otherwise, you normally need to press <C-\><C-n>, which
-- is not what someone will guess without a bit more experience.
--
-- NOTE: This won't work in all terminal emulators/tmux/etc. Try your own mapping
-- or just use <C-\><C-n> to exit terminal mode
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- TIP: Disable arrow keys in normal mode
-- vim.keymap.set('n', '<left>', '<cmd>echo "Use h to move!!"<CR>')
-- vim.keymap.set('n', '<right>', '<cmd>echo "Use l to move!!"<CR>')
-- vim.keymap.set('n', '<up>', '<cmd>echo "Use k to move!!"<CR>')
-- vim.keymap.set('n', '<down>', '<cmd>echo "Use j to move!!"<CR>')

-- Keybinds to make split navigation easier.
--  Use CTRL+<hjkl> to switch between windows
--
--  See `:help wincmd` for a list of all window commands
vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

-- Custom Keybinds
vim.api.nvim_set_keymap('n', '<C-d>', '<C-d>zz', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<C-u>', '<C-u>zz', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>gg', ':Neogit<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>gd', ':DiffviewOpen<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>gc', ':DiffviewClose<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>gl', ':Neogit log<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', 'yui', '0ggVGY', { desc = 'Copy entire file' })
vim.api.nvim_set_keymap('n', 'yup', '0ggVGp', { desc = 'Paste over entire file' })

local map = vim.api.nvim_set_keymap
local opts = { noremap = true, silent = true }

-- Use Alt + arrow keys to resize windows
map('n', '<A-Up>', ':resize +2<CR>', opts)
map('n', '<A-Down>', ':resize -2<CR>', opts)
map('n', '<A-Left>', ':vertical resize -2<CR>', opts)
map('n', '<A-Right>', ':vertical resize +2<CR>', opts)

-- Optionally, add Ctrl + Alt + arrow keys for larger resizing
map('n', '<C-A-Up>', ':resize +10<CR>', opts)
map('n', '<C-A-Down>', ':resize -10<CR>', opts)
map('n', '<C-A-Left>', ':vertical resize -10<CR>', opts)
map('n', '<C-A-Right>', ':vertical resize +10<CR>', opts)

vim.api.nvim_create_user_command('Fmt', function()
  local filepath = vim.fn.expand '%:p'
  vim.fn.system('pre-commit run --files ' .. filepath)
  vim.cmd 'e!'
end, {})

vim.opt.guifont = { 'UbuntuMono Nerd Font', ':h12' }

-- [[ Basic Autocommands ]]
--  See `:help lua-guide-autocommands`

-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.highlight.on_yank()`
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- [[ Install `lazy.nvim` plugin manager ]]
--    See `:help lazy.nvim.txt` or https://github.com/folke/lazy.nvim for more info
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
  vim.fn.system { 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath }
end ---@diagnostic disable-next-line: undefined-field
vim.opt.rtp:prepend(lazypath)

-- [[ Configure and install plugins ]]
--
--  To check the current status of your plugins, run
--    :Lazy
--
--  You can press `?` in this menu for help. Use `:q` to close the window
--
--  To update plugins, you can run
--    :Lazy update
--
-- NOTE: Here is where you install your plugins.
require('lazy').setup({
  {
    'brenoprata10/nvim-highlight-colors',
    opts = {
      render = 'background', -- or 'foreground' or 'virtual'
      enable_named_colors = true,
      enable_tailwind = false,
    },
    config = function(_, opts)
      require('nvim-highlight-colors').setup(opts)
    end,
  },
  {
    'nvim-neo-tree/neo-tree.nvim',
    branch = 'v3.x',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-tree/nvim-web-devicons', -- not strictly required, but recommended
      'MunifTanjim/nui.nvim',
    },
    opts = {
      close_if_last_window = false,
      enable_git_status = true,
      enable_diagnostics = true,
      filesystem = {
        filtered_items = {
          visible = false,
          hide_dotfiles = false,
          hide_gitignored = false,
        },
        follow_current_file = {
          enabled = true,
          leave_dirs_open = false,
        },
        use_libuv_file_watcher = true,
      },
      window = {
        width = 30,
        mappings = {
          ['<space>'] = 'none',
          ['P'] = { 'toggle_preview', config = { use_float = true, use_image_nvim = true } },
        },
      },
    },
    config = function(_, opts)
      require('neo-tree').setup(opts)
      vim.keymap.set('n', '<leader>e', ':Neotree toggle<CR>', { noremap = true, silent = true })
      vim.keymap.set('n', '<leader>o', ':Neotree focus<CR>', { noremap = true, silent = true })
    end,
  },
  {
    'nvim-tree/nvim-web-devicons',
    lazy = false,
    priority = 1000, -- Load it before other plugins
    config = function()
      require('nvim-web-devicons').setup {
        -- Your personalization options can go here
        -- For example:
        -- override = {
        --   zsh = {
        --     icon = "",
        --     color = "#428850",
        --     name = "Zsh"
        --   }
        -- },
        -- color_icons = true,
        -- default = true,
      }
    end,
  },
  {
    'yetone/avante.nvim',
    event = 'VeryLazy',
    build = 'make', -- Optional, only if you want to use tiktoken_core
    opts = {
      provider = 'claude',
      claude = {
        endpoint = 'https://api.anthropic.com',
        model = 'claude-3-5-sonnet-20241022',
        temperature = 0,
        max_tokens = 4096,
      },
      -- Add any other options you want to customize here
    },
    dependencies = {
      'nvim-tree/nvim-web-devicons',
      'stevearc/dressing.nvim',
      'nvim-lua/plenary.nvim',
      'MunifTanjim/nui.nvim',
      {
        'MeanderingProgrammer/render-markdown.nvim',
        opts = {
          file_types = { 'markdown', 'Avante' },
        },
        ft = { 'markdown', 'Avante' },
      },
    },
  },
  {
    'ThePrimeagen/harpoon',
    branch = 'harpoon2',
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
      local harpoon = require 'harpoon'

      -- REQUIRED
      harpoon:setup()
      -- REQUIRED

      -- Basic Harpoon keymaps
      -- Add current file to Harpoon list
      vim.keymap.set('n', '<leader>ha', function()
        harpoon:list():add()
      end, { desc = 'Add file to Harpoon' })

      -- Toggle quick menu
      -- vim.keymap.set('n', '<leader>e', function()
      --   harpoon.ui:toggle_quick_menu(harpoon:list())
      -- end, { desc = 'Toggle Harpoon quick menu' })

      -- Clear Harpoon list
      vim.keymap.set('n', '<leader>hc', function()
        harpoon:list():clear()
        print 'Harpoon list cleared'
      end, { desc = 'Clear Harpoon list' })

      -- Navigate through Harpoon list
      vim.keymap.set('n', '<C-P>', function()
        harpoon:list():prev()
      end, { desc = 'Go to previous Harpoon file' })
      vim.keymap.set('n', '<C-N>', function()
        harpoon:list():next()
      end, { desc = 'Go to next Harpoon file' })

      -- Select specific files in Harpoon list
      for i = 1, 9 do
        vim.keymap.set('n', '<leader>' .. i, function()
          harpoon:list():select(i)
        end, { desc = 'Select Harpoon file ' .. i })
      end
    end,
  },
  {
    'mfussenegger/nvim-dap',
    dependencies = { 'nvim-neotest/nvim-nio', 'mfussenegger/nvim-dap-python', 'rcarriga/nvim-dap-ui', 'theHamsta/nvim-dap-virtual-text' },
    vim.keymap.set('n', '<F1>', ":lua require'dap'.continue()<CR>"),
    vim.keymap.set('n', '<F2>', ":lua require'dap'.step_over()<CR>"),
    vim.keymap.set('n', '<F3>', ":lua require'dap'.step_into()<CR>"),
    vim.keymap.set('n', '<F4>', ":lua require'dap'.step_out()<CR>"),
    vim.keymap.set('n', '<F5>', ":lua require'dap'.close(); require'dapui'.close()<CR>"),
    vim.keymap.set('n', '<leader>a', ":lua require'dap'.toggle_breakpoint()<CR>"),

    config = function()
      local dap, dapui = require 'dap', require 'dapui'
      local project_root = vim.fn.getcwd() -- Get the current working directory dynamically
      local ts_utils = require 'nvim-treesitter.ts_utils'

      require('dap').set_log_level 'TRACE'
      local function get_current_function_name()
        local node = ts_utils.get_node_at_cursor()
        if not node then
          return nil
        end

        while node do
          local type = node:type()
          if type == 'function_definition' or type == 'method_definition' then
            local name_node = node:named_child(0) -- Assuming the function name is the first child
            if name_node then
              return ts_utils.get_node_text(name_node)[1]
            end
          end
          node = node:parent()
        end
      end

      -- Setup the DAP UI
      dapui.setup()

      vim.keymap.set('n', '<leader>dt', function()
        local test_pattern = get_current_function_name()
        vim.fn.jobstart('make test-debug TEST_PATTERN=' .. test_pattern, { detach = true })
        vim.defer_fn(function()
          -- Implement a retry loop or port check here
          require('dap').continue()
        end, 10000) -- Replace with a more robust check
      end, { desc = 'Debug current test in Docker' })

      -- Use dapui when the debugger starts
      dap.listeners.before.attach.dapui_config = function()
        dapui.open()
      end
      dap.listeners.before.launch.dapui_config = function()
        dapui.open()
      end
      dap.listeners.before.event_terminated.dapui_config = function()
        dapui.close()
      end
      dap.listeners.before.event_exited.dapui_config = function()
        dapui.close()
      end

      -- Add Python adapter for dap
      dap.adapters.python = {
        type = 'executable',
        command = os.getenv 'HOME' .. '/.virtualenvs/debugpy/bin/python', -- path to the Python executable in your debugpy virtualenv
        args = { '-m', 'debugpy.adapter' },
      }

      -- Debugging in a docker container
      dap.adapters.python = {
        type = 'server',
        host = 'localhost',
        port = 5678, -- This should match the port that debugpy is listening on in Docker
      }

      dap.configurations.python = {
        {
          -- Setup for running gunicorn under dap
          type = 'python', -- specify the dap adapter type
          request = 'launch',
          name = 'Sentiment - App',
          program = project_root .. '/venv/bin/gunicorn', -- Path to the gunicorn executable in the venv
          args = { 'app.main:app' }, -- The WSGI application module path in gunicorn's format
          env = {
            DEBUG = 'True',
            DD_DOGSTATSD_DISABLE = 'True',
          },
          console = 'integratedTerminal',
          cwd = project_root .. '/sentiment', -- Set the working directory dynamically
          jinja = true,
          pythonPath = function()
            -- Returning the Python path from the virtual environment dynamically
            return project_root .. '/venv/bin/python'
          end,
        },
        {
          -- Setup for running pytest under dap
          type = 'python',
          request = 'launch',
          name = 'Sentiment - All Tests',
          program = project_root .. '/venv/bin/pytest', -- Dynamic path to the python executable in the venv
          args = { 'tests/' }, -- Invoke pytest as a module and specify the tests directory dynamically
          cwd = project_root .. '/sentiment', -- Set the correct working directory dynamically
          pythonPath = function()
            -- Returning the Python path from the virtual environment dynamically
            return project_root .. '/venv/bin/python'
          end,
        },
        {
          type = 'python',
          request = 'launch',
          name = 'Sentiment - Current Test',
          program = project_root .. '/venv/bin/pytest',
          args = function()
            local file_path = vim.fn.expand '%:p' -- gets the current file path in full
            local function_name = get_current_function_name()
            if function_name then
              return { file_path .. '::' .. function_name }
            else
              return { file_path } -- Fallback to file path if function name can't be determined
            end
          end,
          cwd = project_root .. '/sentiment',
          pythonPath = function()
            return project_root .. '/venv/bin/python'
          end,
        },
        {
          -- Connect to the Python process in Docker
          type = 'python', -- Must match the adapter key
          request = 'attach',
          name = 'Dockerfile - /workspace',
          pathMappings = {
            {
              localRoot = vim.fn.getcwd(), -- The directory of your project on your local filesystem
              remoteRoot = '/workspace', -- The directory in Docker where your project is mounted
            },
          },
        },
      }
    end,
  },

  -- NOTE: Plugins can be added with a link (or for a github repo: 'owner/repo' link).
  'tpope/vim-sleuth', -- Detect tabstop and shiftwidth automatically

  -- NOTE: Plugins can also be added by using a table,
  -- with the first argument being the link and the following
  -- keys can be used to configure plugin behavior/loading/etc.
  --
  -- Use `opts = {}` to force a plugin to be loaded.
  --
  --  This is equivalent to:
  --    require('Comment').setup({})

  -- "gc" to comment visual regions/lines
  { 'numToStr/Comment.nvim', opts = {} },

  -- Here is a more advanced example where we pass configuration
  -- options to `gitsigns.nvim`. This is equivalent to the following lua:
  --    require('gitsigns').setup({ ... })
  --
  -- See `:help gitsigns` to understand what the configuration keys do
  { -- Adds git related signs to the gutter, as well as utilities for managing changes
    'lewis6991/gitsigns.nvim',
    opts = {
      signs = {
        add = { text = '+' },
        change = { text = '~' },
        delete = { text = '_' },
        topdelete = { text = '‾' },
        changedelete = { text = '~' },
      },
    },
  },
  {
    'NeogitOrg/neogit',
    dependencies = {
      'nvim-lua/plenary.nvim', -- required
      'sindrets/diffview.nvim', -- optional - Diff integration

      -- Only one of these is needed, not both.
      'nvim-telescope/telescope.nvim', -- optional
      'ibhagwan/fzf-lua', -- optional
    },
    config = true,
  },

  -- NOTE: Plugins can also be configured to run lua code when they are loaded.
  --
  -- This is often very useful to both group configuration, as well as handle
  -- lazy loading plugins that don't need to be loaded immediately at startup.
  --
  -- For example, in the following configuration, we use:
  --  event = 'VimEnter'
  --
  -- which loads which-key before all the UI elements are loaded. Events can be
  -- normal autocommands events (`:help autocmd-events`).
  --
  -- Then, because we use the `config` key, the configuration only runs
  -- after the plugin has been loaded:
  --  config = function() ... end

  { -- Useful plugin to show you pending keybinds.
    'folke/which-key.nvim',
    event = 'VimEnter', -- Sets the loading event to 'VimEnter'
    config = function() -- This is the function that runs, AFTER loading
      require('which-key').setup()
    end,
  },

  -- NOTE: Plugins can specify dependencies.
  --
  -- The dependencies are proper plugin specifications as well - anything
  -- you do for a plugin at the top level, you can do for a dependency.
  --
  -- Use the `dependencies` key to specify the dependencies of a particular plugin

  { -- Fuzzy Finder (files, lsp, etc)
    'nvim-telescope/telescope.nvim',
    event = 'VimEnter',
    branch = '0.1.x',
    dependencies = {
      'nvim-lua/plenary.nvim',
      { -- If encountering errors, see telescope-fzf-native README for install instructions
        'nvim-telescope/telescope-fzf-native.nvim',

        -- `build` is used to run some command when the plugin is installed/updated.
        -- This is only run then, not every time Neovim starts up.
        build = 'make',

        -- `cond` is a condition used to determine whether this plugin should be
        -- installed and loaded.
        cond = function()
          return vim.fn.executable 'make' == 1
        end,
      },
      { 'nvim-telescope/telescope-ui-select.nvim' },

      -- Useful for getting pretty icons, but requires a Nerd Font.
      { 'nvim-tree/nvim-web-devicons', enabled = vim.g.have_nerd_font },
    },
    config = function()
      -- Telescope is a fuzzy finder that comes with a lot of different things that
      -- it can fuzzy find! It's more than just a "file finder", it can search
      -- many different aspects of Neovim, your workspace, LSP, and more!
      --
      -- The easiest way to use telescope, is to start by doing something like:
      --  :Telescope help_tags
      --
      -- After running this command, a window will open up and you're able to
      -- type in the prompt window. You'll see a list of help_tags options and
      -- a corresponding preview of the help.
      --
      -- Two important keymaps to use while in telescope are:
      --  - Insert mode: <c-/>
      --  - Normal mode: ?
      --
      -- This opens a window that shows you all of the keymaps for the current
      -- telescope picker. This is really useful to discover what Telescope can
      -- do as well as how to actually do it!

      -- [[ Configure Telescope ]]
      -- See `:help telescope` and `:help telescope.setup()`
      require('telescope').setup {
        -- You can put your default mappings / updates / etc. in here
        --  All the info you're looking for is in `:help telescope.setup()`
        --
        -- defaults = {
        --   mappings = {
        --     i = { ['<c-enter>'] = 'to_fuzzy_refine' },
        --   },
        -- },
        -- pickers = {}
        extensions = {
          ['ui-select'] = {
            require('telescope.themes').get_dropdown(),
          },
        },
      }

      -- Enable telescope extensions, if they are installed
      pcall(require('telescope').load_extension, 'fzf')
      pcall(require('telescope').load_extension, 'ui-select')

      -- See `:help telescope.builtin`
      local builtin = require 'telescope.builtin'
      vim.keymap.set('n', '<leader>sh', builtin.help_tags, { desc = '[S]earch [H]elp' })
      vim.keymap.set('n', '<leader>sk', builtin.keymaps, { desc = '[S]earch [K]eymaps' })
      vim.keymap.set('n', '<leader>sf', builtin.find_files, { desc = '[S]earch [F]iles' })
      vim.keymap.set('n', '<leader>ss', builtin.builtin, { desc = '[S]earch [S]elect Telescope' })
      vim.keymap.set('n', '<leader>sw', builtin.grep_string, { desc = '[S]earch current [W]ord' })
      vim.keymap.set('n', '<leader>sg', builtin.live_grep, { desc = '[S]earch by [G]rep' })
      vim.keymap.set('n', '<leader>sd', builtin.diagnostics, { desc = '[S]earch [D]iagnostics' })
      vim.keymap.set('n', '<leader>sr', builtin.resume, { desc = '[S]earch [R]esume' })
      vim.keymap.set('n', '<leader>s.', builtin.oldfiles, { desc = '[S]earch Recent Files ("." for repeat)' })
      vim.keymap.set('n', '<leader><leader>', builtin.buffers, { desc = '[ ] Find existing buffers' })

      -- Slightly advanced example of overriding default behavior and theme
      vim.keymap.set('n', '<leader>/', function()
        -- You can pass additional configuration to telescope to change theme, layout, etc.
        builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
          winblend = 10,
          previewer = false,
        })
      end, { desc = '[/] Fuzzily search in current buffer' })

      -- Also possible to pass additional configuration options.
      --  See `:help telescope.builtin.live_grep()` for information about particular keys
      vim.keymap.set('n', '<leader>s/', function()
        builtin.live_grep {
          grep_open_files = true,
          prompt_title = 'Live Grep in Open Files',
        }
      end, { desc = '[S]earch [/] in Open Files' })

      -- Shortcut for searching your neovim configuration files
      vim.keymap.set('n', '<leader>sn', function()
        builtin.find_files { cwd = vim.fn.stdpath 'config' }
      end, { desc = '[S]earch [N]eovim files' })
    end,
  },

  {
    'neovim/nvim-lspconfig',
    dependencies = {
      'williamboman/mason.nvim',
      'williamboman/mason-lspconfig.nvim',
      'WhoIsSethDaniel/mason-tool-installer.nvim',
      { 'j-hui/fidget.nvim', opts = {} },
      { 'folke/neodev.nvim', opts = {} },
    },
    config = function()
      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
        callback = function(event)
          local map = function(keys, func, desc)
            vim.keymap.set('n', keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
          end

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
        end,
      })

      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities = vim.tbl_deep_extend('force', capabilities, require('cmp_nvim_lsp').default_capabilities())

      local servers = {
        ruff = {
          on_attach = function(client, bufnr)
            client.server_capabilities.hoverProvider = false
          end,
          init_options = {
            settings = {
              args = {
                '--select=E,F,W,I,N,D,UP,ANN,S,BLE,B,A,COM,C4,T20,PT,Q,SIM,ARG,ERA,PL,RUF',
                '--extend-select=YTT,TCH,Q,EM,ICN',
                '--ignore=E501,E203,E402',
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
        -- Replace or add this configuration
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

      require('mason').setup()
      require('mason-lspconfig').setup {
        ensure_installed = { 'typescript-language-server' },
      }

      -- Ensure the server is installed via Mason
      local ensure_installed = vim.tbl_keys(servers or {})
      vim.list_extend(ensure_installed, {
        'typescript-language-server',
      })

      require('mason-tool-installer').setup {
        ensure_installed = ensure_installed,
        auto_update = false,
        run_on_start = true,
      }

      require('lspconfig')['typescript-language-server'].setup(servers['typescript-language-server'])

      -- Update or add this section to your existing configuration
      vim.api.nvim_create_autocmd('FileType', {
        pattern = { 'typescript', 'javascript', 'typescriptreact', 'javascriptreact' },
        callback = function()
          vim.keymap.set('n', '<leader>ri', ':TypescriptAddMissingImports<CR>', { buffer = true })
          vim.keymap.set('n', '<leader>ro', ':TypescriptOrganizeImports<CR>', { buffer = true })
          vim.keymap.set('n', '<leader>ru', ':TypescriptRemoveUnused<CR>', { buffer = true })
        end,
      })

      require('mason-lspconfig').setup {
        handlers = {
          function(server_name)
            local server = servers[server_name] or {}
            server.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server.capabilities or {})
            require('lspconfig')[server_name].setup(server)
          end,
        },
      }

      vim.api.nvim_create_autocmd('BufWritePre', {
        pattern = '*.py',
        callback = function()
          vim.lsp.buf.format { async = false, name = 'ruff_lsp' }
        end,
      })

      vim.api.nvim_set_keymap('n', '<leader>rf', '<cmd>lua vim.lsp.buf.format({name = "ruff_lsp"})<CR>', { noremap = true, silent = true })
    end,
  },
  {
    'stevearc/conform.nvim',
    opts = {
      notify_on_error = false,
      format_on_save = {
        timeout_ms = 500,
        lsp_fallback = true,
      },
      formatters_by_ft = {
        lua = { 'stylua' },
        python = { 'ruff_format' }, -- Changed from 'black' to 'ruff_format'
        htmldjango = { 'djlint' },
        html = { 'djlint' },
        css = { 'prettier' },
        javascript = { 'prettier' },
        -- You can also add TypeScript if needed
        -- typescript = { 'prettier' },
      },
      formatters = {
        djlint = {
          command = 'djlint',
          args = {
            '--reformat',
            '-',
            '--indent',
            '2',
            '--profile',
            'django',
          },
        },
        ruff_format = {
          command = 'ruff',
          args = {
            'format',
            '--line-length',
            '100',
            '--quiet',
            '-',
          },
        },
        prettier = {
          command = 'prettier',
          args = { '--stdin-filepath', '$FILENAME' },
        },
      },
    },
    config = function(_, opts)
      require('conform').setup(opts)
      vim.filetype.add {
        pattern = {
          ['.*/templates/.*%.html'] = 'htmldjango',
        },
      }
    end,
  },

  { -- Autocompletion
    'hrsh7th/nvim-cmp',
    event = 'InsertEnter',
    dependencies = {
      -- Snippet Engine & its associated nvim-cmp source
      {
        'L3MON4D3/LuaSnip',
        build = (function()
          -- Build Step is needed for regex support in snippets
          -- This step is not supported in many windows environments
          -- Remove the below condition to re-enable on windows
          if vim.fn.has 'win32' == 1 or vim.fn.executable 'make' == 0 then
            return
          end
          return 'make install_jsregexp'
        end)(),
        dependencies = {
          -- `friendly-snippets` contains a variety of premade snippets.
          --    See the README about individual language/framework/plugin snippets:
          --    https://github.com/rafamadriz/friendly-snippets
          -- {
          --   'rafamadriz/friendly-snippets',
          --   config = function()
          --     require('luasnip.loaders.from_vscode').lazy_load()
          --   end,
          -- },
        },
      },
      'saadparwaiz1/cmp_luasnip',

      -- Adds other completion capabilities.
      --  nvim-cmp does not ship with all sources by default. They are split
      --  into multiple repos for maintenance purposes.
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-path',
    },
    config = function()
      -- See `:help cmp`
      local cmp = require 'cmp'
      local luasnip = require 'luasnip'
      luasnip.config.setup {}

      cmp.setup {
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        completion = { completeopt = 'menu,menuone,noinsert' },

        -- For an understanding of why these mappings were
        -- chosen, you will need to read `:help ins-completion`
        --
        -- No, but seriously. Please read `:help ins-completion`, it is really good!
        mapping = cmp.mapping.preset.insert {
          -- Select the [n]ext item
          ['<C-n>'] = cmp.mapping.select_next_item(),
          -- Select the [p]revious item
          ['<C-p>'] = cmp.mapping.select_prev_item(),

          -- scroll the documentation window [b]ack / [f]orward
          ['<C-b>'] = cmp.mapping.scroll_docs(-4),
          ['<C-f>'] = cmp.mapping.scroll_docs(4),

          -- Accept ([y]es) the completion.
          --  This will auto-import if your LSP supports it.
          --  This will expand snippets if the LSP sent a snippet.
          ['<C-y>'] = cmp.mapping.confirm { select = true },
          ['<CR>'] = cmp.mapping.confirm { select = true },

          -- Manually trigger a completion from nvim-cmp.
          --  Generally you don't need this, because nvim-cmp will display
          --  completions whenever it has completion options available.
          ['<C-Space>'] = cmp.mapping.complete {},

          -- Think of <c-l> as moving to the right of your snippet expansion.
          --  So if you have a snippet that's like:
          --  function $name($args)
          --    $body
          --  end
          --
          -- <c-l> will move you to the right of each of the expansion locations.
          -- <c-h> is similar, except moving you backwards.
          ['<C-l>'] = cmp.mapping(function()
            if luasnip.expand_or_locally_jumpable() then
              luasnip.expand_or_jump()
            end
          end, { 'i', 's' }),
          ['<C-h>'] = cmp.mapping(function()
            if luasnip.locally_jumpable(-1) then
              luasnip.jump(-1)
            end
          end, { 'i', 's' }),

          -- For more advanced luasnip keymaps (e.g. selecting choice nodes, expansion) see:
          --    https://github.com/L3MON4D3/LuaSnip?tab=readme-ov-file#keymaps
        },
        sources = {
          { name = 'nvim_lsp' },
          { name = 'luasnip' },
          { name = 'path' },
        },
      }
    end,
  },

  { -- You can easily change to a different colorscheme.
    -- Change the name of the colorscheme plugin below, and then
    -- change the command in the config to whatever the name of that colorscheme is
    --
    -- If you want to see what colorschemes are already installed, you can use `:Telescope colorscheme`
    'folke/tokyonight.nvim',
    priority = 1000, -- make sure to load this before all the other start plugins
    init = function()
      -- Load the colorscheme here.
      -- Like many other themes, this one has different styles, and you could load
      -- any other, such as 'tokyonight-storm', 'tokyonight-moon', or 'tokyonight-day'.
      vim.cmd.colorscheme 'tokyonight-night'

      -- You can configure highlights by doing something like
      vim.cmd.hi 'Comment gui=none'
    end,
  },

  -- Highlight todo, notes, etc in comments
  { 'folke/todo-comments.nvim', event = 'VimEnter', dependencies = { 'nvim-lua/plenary.nvim' }, opts = { signs = false } },

  { -- Collection of various small independent plugins/modules
    'echasnovski/mini.nvim',
    config = function()
      -- Better Around/Inside textobjects
      --
      -- Examples:
      --  - va)  - [V]isually select [A]round [)]paren
      --  - yinq - [Y]ank [I]nside [N]ext [']quote
      --  - ci'  - [C]hange [I]nside [']quote
      require('mini.ai').setup { n_lines = 500 }

      -- Add/delete/replace surroundings (brackets, quotes, etc.)
      --
      -- - saiw) - [S]urround [A]dd [I]nner [W]ord [)]Paren
      -- - sd'   - [S]urround [D]elete [']quotes
      -- - sr)'  - [S]urround [R]eplace [)] [']
      require('mini.surround').setup()

      -- Simple and easy statusline.
      --  You could remove this setup call if you don't like it,
      --  and try some other statusline plugin
      local statusline = require 'mini.statusline'
      -- set use_icons to true if you have a Nerd Font
      statusline.setup { use_icons = vim.g.have_nerd_font }

      -- You can configure sections in the statusline by overriding their
      -- default behavior. For example, here we set the section for
      -- cursor location to LINE:COLUMN
      ---@diagnostic disable-next-line: duplicate-set-field
      statusline.section_location = function()
        return '%2l:%-2v'
      end

      -- ... and there is more!
      --  Check out: https://github.com/echasnovski/mini.nvim
    end,
  },

  { -- Highlight, edit, and navigate code
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    opts = {
      ensure_installed = { 'bash', 'c', 'html', 'lua', 'markdown', 'vim', 'vimdoc' },
      -- Autoinstall languages that are not installed
      auto_install = true,
      highlight = {
        enable = true,
        -- Some languages depend on vim's regex highlighting system (such as Ruby) for indent rules.
        --  If you are experiencing weird indenting issues, add the language to
        --  the list of additional_vim_regex_highlighting and disabled languages for indent.
        additional_vim_regex_highlighting = { 'ruby' },
      },
      indent = { enable = true, disable = { 'ruby' } },
    },
    config = function(_, opts)
      -- [[ Configure Treesitter ]] See `:help nvim-treesitter`

      ---@diagnostic disable-next-line: missing-fields
      require('nvim-treesitter.configs').setup(opts)

      -- There are additional nvim-treesitter modules that you can use to interact
      -- with nvim-treesitter. You should go explore a few and see what interests you:
      --
      --    - Incremental selection: Included, see `:help nvim-treesitter-incremental-selection-mod`
      --    - Show your current context: https://github.com/nvim-treesitter/nvim-treesitter-context
      --    - Treesitter + textobjects: https://github.com/nvim-treesitter/nvim-treesitter-textobjects
    end,
  },

  -- The following two comments only work if you have downloaded the kickstart repo, not just copy pasted the
  -- init.lua. If you want these files, they are in the repository, so you can just download them and
  -- put them in the right spots if you want.

  -- NOTE: Next step on your Neovim journey: Add/Configure additional plugins for kickstart
  --
  --  Here are some example plugins that I've included in the kickstart repository.
  --  Uncomment any of the lines below to enable them (you will need to restart nvim).
  --
  -- require 'kickstart.plugins.debug',
  -- require 'kickstart.plugins.indent_line',

  -- NOTE: The import below can automatically add your own plugins, configuration, etc from `lua/custom/plugins/*.lua`
  --    This is the easiest way to modularize your config.
  --
  --  Uncomment the following line and add your plugins to `lua/custom/plugins/*.lua` to get going.
  --    For additional information, see `:help lazy.nvim-lazy.nvim-structuring-your-plugins`
  -- { import = 'custom.plugins' },
}, {
  ui = {
    -- If you have a Nerd Font, set icons to an empty table which will use the
    -- default lazy.nvim defined Nerd Font icons otherwise define a unicode icons table
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
      lazy = '💤 ',
    },
  },
})
vim.filetype.add {
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
  },
}

vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'javascriptreact', 'typescriptreact' },
  callback = function()
    vim.keymap.set('n', '<leader>ri', ':TypescriptAddMissingImports<CR>', { buffer = true })
    vim.keymap.set('n', '<leader>ro', ':TypescriptOrganizeImports<CR>', { buffer = true })
    vim.keymap.set('n', '<leader>ru', ':TypescriptRemoveUnused<CR>', { buffer = true })
  end,
})
-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
local function open_github(start_line, end_line)
  local file_path = vim.fn.expand '%:p'
  local git_root = vim.fn.system('git -C ' .. vim.fn.expand '%:p:h' .. ' rev-parse --show-toplevel'):gsub('[\n\r]+', '')
  local relative_file_path = file_path:sub(#git_root + 2)
  local branch = vim.fn.system('git branch --show-current'):gsub('[\n\r]+', '')
  local remote_url = vim.fn.system('git remote get-url origin'):gsub('[\n\r]+', '')
  local github_url = remote_url:gsub('git@github.com:', 'https://github.com/'):gsub('.git$', '')
  local url = github_url .. '/blob/' .. branch .. '/' .. relative_file_path

  if start_line and end_line then
    url = url .. '#L' .. start_line .. '-L' .. end_line
  else
    local line_number = vim.fn.line '.'
    url = url .. '#L' .. line_number
  end

  local open_command
  if vim.fn.has 'mac' == 1 then
    open_command = 'open "' .. url .. '"'
  elseif vim.fn.has 'unix' == 1 then
    open_command = 'xdg-open "' .. url .. '"'
  elseif vim.fn.has 'win32' == 1 or vim.fn.has 'win64' == 1 then
    open_command = 'start "" "' .. url .. '"'
  end

  if open_command then
    vim.fn.system(open_command)
  else
    print 'Unsupported system for opening URLs'
  end
end

local function open_github_visual()
  local start_pos = vim.fn.getpos "'<"
  local end_pos = vim.fn.getpos "'>"
  local start_line, end_line = start_pos[2], end_pos[2]
  open_github(start_line, end_line)
end

-- Register the functions in the Lua global namespace under `myplugin` to avoid conflicts
_G.myplugin = {
  open_github = open_github,
  open_github_visual = open_github_visual,
}

-- Keybinding for normal mode, calling the global function
vim.api.nvim_set_keymap('n', 'gh', ':lua myplugin.open_github()<CR>', { noremap = true, silent = true })

-- Keybinding for visual mode
vim.api.nvim_set_keymap('v', 'gh', ':<C-U>lua myplugin.open_github_visual()<CR>', { noremap = true, silent = true })

local snippet_buffer = {}

-- Helper function to get selected text
local function get_visual_selection()
  local start_pos = vim.fn.getpos "'<"
  local end_pos = vim.fn.getpos "'>"
  local start_line, end_line = start_pos[2], end_pos[2]
  local lines = vim.api.nvim_buf_get_lines(0, start_line - 1, end_line, false)
  return table.concat(lines, '\n')
end

-- Helper function to get total line count of a file
local function get_file_line_count(file_path)
  local file = io.open(file_path, 'r')
  if not file then
    return 0
  end
  local line_count = 0
  for _ in file:lines() do
    line_count = line_count + 1
  end
  file:close()
  return line_count
end

-- Add snippet functions (normal and visual mode)
_G.add_snippet_normal = function()
  local line_num = vim.fn.line '.'
  local code = vim.api.nvim_get_current_line()
  local current_file = vim.fn.expand '%:p'
  local total_lines = get_file_line_count(current_file)
  local snippet = {
    directory = current_file,
    stat = vim.fn.system('stat ' .. current_file):gsub('\n', ' '),
    code = code,
    start_line = line_num,
    end_line = line_num,
    total_lines = total_lines,
  }
  table.insert(snippet_buffer, snippet)
end

_G.add_snippet_visual = function()
  local start_pos = vim.fn.getpos "'<"
  local end_pos = vim.fn.getpos "'>"
  local start_line, end_line = start_pos[2], end_pos[2]
  local lines = vim.api.nvim_buf_get_lines(0, start_line - 1, end_line, false)
  local code = table.concat(lines, '\n')
  local current_file = vim.fn.expand '%:p'
  local total_lines = get_file_line_count(current_file)
  local snippet = {
    directory = current_file,
    stat = vim.fn.system('stat ' .. current_file):gsub('\n', ' '),
    code = code,
    start_line = start_line,
    end_line = end_line,
    total_lines = total_lines,
  }
  table.insert(snippet_buffer, snippet)
end

-- Function to generate file tree
local function generate_file_tree()
  local root_dir = vim.fn.getcwd()
  local tree = {}

  for _, snippet in ipairs(snippet_buffer) do
    local path = vim.fn.fnamemodify(snippet.directory, ':~:.')
    local parts = vim.split(path, '/')
    local current = tree
    for i, part in ipairs(parts) do
      if i == #parts then
        current[part] = true -- Mark as file
      else
        current[part] = current[part] or {}
        current = current[part]
      end
    end
  end

  local function render_tree(node, prefix, is_last)
    local lines = {}
    local keys = vim.tbl_keys(node)
    table.sort(keys)

    for i, key in ipairs(keys) do
      local is_last_item = (i == #keys)
      local new_prefix = prefix .. (is_last and '    ' or '│   ')
      local line = prefix .. (is_last_item and '└── ' or '├── ') .. key

      table.insert(lines, line)

      if type(node[key]) == 'table' then
        local subtree = render_tree(node[key], new_prefix, is_last_item)
        vim.list_extend(lines, subtree)
      end
    end

    return lines
  end

  return render_tree(tree, '', true)
end

-- View snippets function
_G.view_snippets = function()
  if #snippet_buffer == 0 then
    print 'No snippets in buffer.'
    return
  end

  vim.cmd 'vnew'
  local buf = vim.api.nvim_get_current_buf()
  vim.api.nvim_buf_set_option(buf, 'buftype', 'nofile')
  vim.api.nvim_buf_set_option(buf, 'swapfile', false)
  vim.api.nvim_buf_set_option(buf, 'bufhidden', 'wipe')
  vim.api.nvim_buf_set_option(buf, 'modifiable', true)

  local content = {}
  local file_tree = generate_file_tree()

  -- Add file tree to content
  table.insert(content, 'File Tree:')
  table.insert(content, '../')
  vim.list_extend(content, file_tree)
  table.insert(content, string.rep('-', 40))
  table.insert(content, '')

  -- Add snippets to content with line numbers and total line count
  for i, snippet in ipairs(snippet_buffer) do
    table.insert(content, 'Snippet ' .. i .. ':')
    table.insert(content, 'Directory: ' .. snippet.directory)
    table.insert(content, 'Stat: ' .. snippet.stat)
    table.insert(content, string.format('Total lines in file: %d', snippet.total_lines))
    table.insert(content, 'Code:')

    -- Split the code into lines and add line numbers
    local lines = vim.split(snippet.code, '\n')
    local current_line = snippet.start_line

    for _, line in ipairs(lines) do
      table.insert(content, string.format('%6d | %s', current_line, line))
      current_line = current_line + 1
    end

    table.insert(content, '')
    table.insert(content, string.rep('-', 40))
    table.insert(content, '')
  end

  vim.api.nvim_buf_set_lines(buf, 0, -1, false, content)
  print('Displaying ' .. #snippet_buffer .. ' snippets.')
end

-- Clear snippets function
_G.clear_snippets = function()
  local count = #snippet_buffer
  snippet_buffer = {}
  print('Snippet buffer cleared. Removed ' .. count .. ' snippets.')
end

-- Set up keymaps
vim.api.nvim_set_keymap('n', '<leader>we', ':lua add_snippet_normal()<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('v', '<leader>we', ':<C-U>lua add_snippet_visual()<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>wr', ':lua view_snippets()<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>wq', ':lua clear_snippets()<CR>', { noremap = true, silent = true })

vim.filetype.add {
  pattern = {
    ['.*/templates/.*%.html'] = 'htmldjango',
  },
}

vim.keymap.set('n', '<leader>F', function()
  require('conform').format { async = true, lsp_fallback = true }
end, { desc = 'Format buffer' })
-- Auto Commit Message
local M = {}

function M.generate_commit_message()
  local api_key = os.getenv 'HYPERBOLIC_API_KEY'
  if not api_key then
    vim.api.nvim_echo({ {
      'HYPERBOLIC_API_KEY environment variable is not set',
      'ErrorMsg',
    } }, true, {})
    return
  end

  local current_line = vim.api.nvim_get_current_line()
  local diff_win = vim.fn.winnr 'j'
  vim.cmd(diff_win .. 'wincmd w')
  local diff_content = table.concat(vim.api.nvim_buf_get_lines(0, 0, -1, false), '\n')

  local prompt_template = [[
Write a commit message for this git diff.

]] .. current_line .. [[

<Example 1>
Update database connection handling

- Switch to connection pooling
- Add timeout settings
- Log failed connections

</Example 1>

<Example 2>
Fix image upload validation

- Enforce maximum file size of 5MB for uploaded images
- Restrict allowed file types to .jpg, .png, .gif
- Return user-friendly error messages for validation failures
- Implement asynchronous upload processing to improve user experience
- Auto-rotate images based on EXIF data
- Optimize image compression on server to reduce file sizes
- Add client-side preview of uploaded images
- Integrate with 3rd party service for advanced image optimization
- Scan uploaded files for viruses/malware and log failures
- Update API docs to reflect new image upload requirements

</Example 2>

<Example 3>
Fix typo in footer
</Example 3>


Keep messages succinct. If there's a single small change, use a one-line message (like in Example 3). For multiple changes, list the key updates (like in Examples 1 and 2).

Do not start your message with things like "Here is a good commit message for this diff:" -- just get straight to writing the commit message.

Here's the Git diff:

]] .. diff_content

  local request_body = vim.fn.json_encode {
    messages = {
      {
        role = 'system',
        content = '<|im_start|>system\nYou are a Principal Machine Learning Engineer tasked with generating commit messages. Write with clarity and persuasion. Keep sentences simple. Avoid marketing speak purple prose, hyperbole, and flowery language. Use ordinary words where possible, and technical terms only when needed for precision. Remember: simple writing is persuasive writing.<|im_end|>',
      },
      {
        role = 'user',
        content = '<|im_start|>user\n' .. prompt_template .. '<|im_end|>',
      },
    },
    model = 'Qwen/Qwen2.5-Coder-32B-Instruct',
    max_tokens = 8192,
    temperature = 0.7,
    top_p = 0.8,
    top_k = 20,
    repetition_penalty = 1.05,
  }

  local curl_command = string.format(
    "curl -s -X POST 'https://api.hyperbolic.xyz/v1/chat/completions' "
      .. "-H 'Authorization: Bearer %s' "
      .. "-H 'Content-Type: application/json' "
      .. "-d '%s'",
    api_key,
    request_body:gsub("'", "'\\''")
  )

  -- Write request to debug file
  local debug_file = io.open('/tmp/nvim_commit_debug.json', 'w')
  if debug_file then
    debug_file:write 'REQUEST:\n'
    debug_file:write(request_body)
    debug_file:write '\n\nRESPONSE:\n'
  end

  local handle = io.popen(curl_command)
  local response = handle:read '*a'
  handle:close()

  -- Append response to debug file
  if debug_file then
    debug_file:write(response)
    debug_file:close()
  end

  if response == '' then
    vim.api.nvim_echo({ { 'API call failed', 'ErrorMsg' } }, true, {})
    return
  end

  local ok, parsed_response = pcall(vim.fn.json_decode, response)
  if not ok then
    vim.api.nvim_echo({ { 'Failed to parse API response', 'ErrorMsg' } }, true, {})
    vim.api.nvim_echo({ { 'Raw response: ' .. response, 'Normal' } }, true, {})
    return
  end

  if not parsed_response.choices or not parsed_response.choices[1].message then
    vim.api.nvim_echo({ { 'Missing message in API response', 'ErrorMsg' } }, true, {})
    return
  end

  local commit_message = parsed_response.choices[1].message.content:gsub('<|im_start|>assistant\n', ''):gsub('<|im_end|>', '')
  local commit_win = vim.fn.winnr 'k'
  vim.cmd(commit_win .. 'wincmd w')

  local cursor_pos = vim.api.nvim_win_get_cursor(0)
  local row, col = cursor_pos[1] - 1, cursor_pos[2]
  vim.api.nvim_buf_set_text(0, row, col, row, col, vim.split(commit_message, '\n'))
end

if not _G.myplugin then
  _G.myplugin = {}
end
_G.myplugin.generate_commit_message = M.generate_commit_message

vim.api.nvim_set_keymap('n', '<leader>gai', ':lua _G.myplugin.generate_commit_message()<CR>', {
  noremap = true,
  silent = false,
})

return M
