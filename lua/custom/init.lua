-- Plugin specifications
local plugins = {
  {
    'hrsh7th/nvim-cmp',
    event = 'InsertEnter',
    dependencies = {
      {
        'L3MON4D3/LuaSnip',
        build = (function()
          if vim.fn.has 'win32' == 1 or vim.fn.executable 'make' == 0 then
            return
          end
          return 'make install_jsregexp'
        end)(),
      },
      'saadparwaiz1/cmp_luasnip',
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-path',
    },
    config = function()
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
        mapping = cmp.mapping.preset.insert {
          ['<C-n>'] = cmp.mapping.select_next_item(),
          ['<C-p>'] = cmp.mapping.select_prev_item(),
          ['<C-b>'] = cmp.mapping.scroll_docs(-4),
          ['<C-f>'] = cmp.mapping.scroll_docs(4),
          ['<C-y>'] = cmp.mapping.confirm { select = true },
          ['<CR>'] = cmp.mapping.confirm { select = true },
          ['<C-Space>'] = cmp.mapping.complete {},
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
        },
        sources = {
          { name = 'nvim_lsp' },
          { name = 'luasnip' },
          { name = 'path' },
        },
      }
    end,
  },
  {
    'neovim/nvim-lspconfig',
    event = 'VeryLazy',
    dependencies = {
      'williamboman/mason.nvim',
      'williamboman/mason-lspconfig.nvim',
      'WhoIsSethDaniel/mason-tool-installer.nvim',
      { 'j-hui/fidget.nvim', opts = {} },
      { 'folke/neodev.nvim', opts = {} },
      'hrsh7th/cmp-nvim-lsp',
    },
    config = function()
      -- Delay LSP setup until after cmp-nvim-lsp is definitely loaded
      vim.defer_fn(function()
        require('custom.lsp').setup()
      end, 100)
    end,
  },
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
        position = 'left',
        number = false,
        relativenumber = false,
      },
    },
    config = function(_, opts)
      require('neo-tree').setup(opts)
      -- Set up keymaps
      vim.keymap.set('n', '<leader>e', ':Neotree toggle<CR>', { noremap = true, silent = true })
      vim.keymap.set('n', '<leader>o', ':Neotree focus<CR>', { noremap = true, silent = true })
      -- Ensure line numbers stay disabled in neo-tree windows
      vim.api.nvim_create_autocmd('FileType', {
        pattern = 'neo-tree',
        callback = function()
          vim.opt_local.number = false
          vim.opt_local.relativenumber = false
        end,
      })
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
      local dap, dapui = require 'dap', require 'dapui'
      require('dap').set_log_level 'TRACE'

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
    config = function()
      require('neogit').setup()
      -- Set up keymaps here instead of in core/keymaps.lua
      vim.keymap.set('n', '<leader>gg', ':Neogit<CR>', { noremap = true, silent = true })
      vim.keymap.set('n', '<leader>gd', ':DiffviewOpen<CR>', { noremap = true, silent = true })
      vim.keymap.set('n', '<leader>gc', ':DiffviewClose<CR>', { noremap = true, silent = true })
      vim.keymap.set('n', '<leader>gl', ':Neogit log<CR>', { noremap = true, silent = true })
    end,
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
          return vim.fn.executable 'make' == 1
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

      -- Add telescope keymaps here since they were incorrectly moved
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
        builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
          winblend = 10,
          previewer = false,
        })
      end, { desc = '[/] Fuzzily search in current buffer' })

      vim.keymap.set('n', '<leader>s/', function()
        builtin.live_grep {
          grep_open_files = true,
          prompt_title = 'Live Grep in Open Files',
        }
      end, { desc = '[S]earch [/] in Open Files' })

      vim.keymap.set('n', '<leader>sn', function()
        builtin.find_files { cwd = vim.fn.stdpath 'config' }
      end, { desc = '[S]earch [N]eovim files' })
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
      vim.cmd.colorscheme 'tokyonight-night'
      vim.cmd.hi 'Comment gui=none'
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
      local statusline = require 'mini.statusline'
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
  -- Add snippets as a local plugin
  {
    dir = vim.fn.stdpath('config') .. '/lua/custom/utils',
    name = 'snippets',
    lazy = false,  -- Load immediately
    priority = 1000,  -- High priority to load early
    config = function()
      -- Set up keymaps here instead of in snippets.lua
      local snippets = require('custom.utils.snippets')
      -- Store in global for access from keymaps
      _G.snippets = snippets
      -- Set up keymaps
      vim.keymap.set('n', '<leader>we', function() snippets.add_snippet_normal() end, { noremap = true, silent = true })
      vim.keymap.set('v', '<leader>we', ':<C-u>lua _G.snippets.add_snippet_visual()<CR>', { noremap = true, silent = true })
      vim.keymap.set('n', '<leader>wr', function() snippets.view_snippets() end, { noremap = true, silent = true })
      vim.keymap.set('n', '<leader>wq', function() snippets.clear_snippets() end, { noremap = true, silent = true })
    end,
  },
}

return plugins
