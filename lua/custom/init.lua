-- Initialize core modules
require('custom.core.options')
require('custom.core.keymaps')
require('custom.core.autocmds').setup()

-- Initialize LSP
require('custom.lsp').setup()

-- Initialize utilities
require('custom.utils.git').setup()
require('custom.utils.snippets').setup()

-- Plugin specifications
local plugins = {
  {
    'brenoprata10/nvim-highlight-colors',
    opts = {
      render = 'background',
      enable_named_colors = true,
      enable_tailwind = false,
    },
  },
  {
    'nvim-neo-tree/neo-tree.nvim',
    branch = 'v3.x',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-tree/nvim-web-devicons',
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
    priority = 1000,
    config = function()
      require('nvim-web-devicons').setup {}
    end,
  },
  {
    'yetone/avante.nvim',
    event = 'VeryLazy',
    build = 'make',
    opts = {
      provider = 'claude',
      claude = {
        endpoint = 'https://api.anthropic.com',
        model = 'claude-3-5-sonnet-20241022',
        temperature = 0,
        max_tokens = 4096,
      },
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
      local harpoon = require('harpoon')
      harpoon:setup()

      vim.keymap.set('n', '<leader>ha', function()
        harpoon:list():add()
      end, { desc = 'Add file to Harpoon' })

      vim.keymap.set('n', '<leader>hc', function()
        harpoon:list():clear()
        print('Harpoon list cleared')
      end, { desc = 'Clear Harpoon list' })

      vim.keymap.set('n', '<C-P>', function()
        harpoon:list():prev()
      end, { desc = 'Go to previous Harpoon file' })
      vim.keymap.set('n', '<C-N>', function()
        harpoon:list():next()
      end, { desc = 'Go to next Harpoon file' })

      for i = 1, 9 do
        vim.keymap.set('n', '<leader>' .. i, function()
          harpoon:list():select(i)
        end, { desc = 'Select Harpoon file ' .. i })
      end
    end,
  },
  {
    'mfussenegger/nvim-dap',
    dependencies = {
      'nvim-neotest/nvim-nio',
      'mfussenegger/nvim-dap-python',
      'rcarriga/nvim-dap-ui',
      'theHamsta/nvim-dap-virtual-text',
    },
    config = function()
      -- DAP keymaps
      vim.keymap.set('n', '<F1>', ":lua require'dap'.continue()<CR>")
      vim.keymap.set('n', '<F2>', ":lua require'dap'.step_over()<CR>")
      vim.keymap.set('n', '<F3>', ":lua require'dap'.step_into()<CR>")
      vim.keymap.set('n', '<F4>', ":lua require'dap'.step_out()<CR>")
      vim.keymap.set('n', '<F5>', ":lua require'dap'.close(); require'dapui'.close()<CR>")
      vim.keymap.set('n', '<leader>a', ":lua require'dap'.toggle_breakpoint()<CR>")

      -- DAP configuration
      local dap, dapui = require('dap'), require('dapui')
      require('dap').set_log_level('TRACE')

      -- DAP UI setup
      dapui.setup()

      -- DAP UI listeners
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

      -- Python adapter setup
      dap.adapters.python = {
        type = 'server',
        host = 'localhost',
        port = 5678,
      }

      -- Python configurations
      dap.configurations.python = {
        {
          type = 'python',
          request = 'attach',
          name = 'Dockerfile - /workspace',
          pathMappings = {
            {
              localRoot = vim.fn.getcwd(),
              remoteRoot = '/workspace',
            },
          },
        },
      }
    end,
  },
  { 'tpope/vim-sleuth' },
  { 'numToStr/Comment.nvim', opts = {} },
  {
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
      'nvim-lua/plenary.nvim',
      'sindrets/diffview.nvim',
      'nvim-telescope/telescope.nvim',
      'ibhagwan/fzf-lua',
    },
    config = true,
  },
  {
    'folke/which-key.nvim',
    event = 'VimEnter',
    config = function()
      require('which-key').setup()
    end,
  },
  {
    'nvim-telescope/telescope.nvim',
    event = 'VimEnter',
    branch = '0.1.x',
    dependencies = {
      'nvim-lua/plenary.nvim',
      {
        'nvim-telescope/telescope-fzf-native.nvim',
        build = 'make',
        cond = function()
          return vim.fn.executable('make') == 1
        end,
      },
      { 'nvim-telescope/telescope-ui-select.nvim' },
      { 'nvim-tree/nvim-web-devicons', enabled = vim.g.have_nerd_font },
    },
    config = function()
      require('telescope').setup {
        extensions = {
          ['ui-select'] = {
            require('telescope.themes').get_dropdown(),
          },
        },
      }

      pcall(require('telescope').load_extension, 'fzf')
      pcall(require('telescope').load_extension, 'ui-select')
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
        python = { 'ruff_format' },
        htmldjango = { 'djlint' },
        html = { 'djlint' },
        css = { 'prettier' },
        javascript = { 'prettier' },
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
  {
    'folke/tokyonight.nvim',
    priority = 1000,
    init = function()
      vim.cmd.colorscheme('tokyonight-night')
      vim.cmd.hi('Comment gui=none')
    end,
  },
  {
    'folke/todo-comments.nvim',
    event = 'VimEnter',
    dependencies = { 'nvim-lua/plenary.nvim' },
    opts = { signs = false },
  },
  {
    'echasnovski/mini.nvim',
    config = function()
      require('mini.ai').setup { n_lines = 500 }
      require('mini.surround').setup()
      local statusline = require('mini.statusline')
      statusline.setup { use_icons = vim.g.have_nerd_font }
      statusline.section_location = function()
        return '%2l:%-2v'
      end
    end,
  },
  {
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    opts = {
      ensure_installed = { 'bash', 'c', 'html', 'lua', 'markdown', 'vim', 'vimdoc' },
      auto_install = true,
      highlight = {
        enable = true,
        additional_vim_regex_highlighting = { 'ruby' },
      },
      indent = { enable = true, disable = { 'ruby' } },
    },
    config = function(_, opts)
      require('nvim-treesitter.configs').setup(opts)
    end,
  },
}

-- Return plugin specifications
return plugins
