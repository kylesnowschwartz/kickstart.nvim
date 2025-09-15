return { -- Fuzzy Finder (files, lsp, etc)
  'nvim-telescope/telescope.nvim',
  event = 'VimEnter',
  dependencies = {
    'nvim-lua/plenary.nvim',
    { -- If encountering errors, see telescope-fzf-native README for installation instructions
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
    {
      'debugloop/telescope-undo.nvim',
      dependencies = {
        {
          'nvim-telescope/telescope.nvim',
          dependencies = { 'nvim-lua/plenary.nvim' },
        },
      },
      keys = {
        { -- lazy style key map
          '<leader>su',
          '<cmd>Telescope undo<cr>',
          desc = '[S]earch [U]ndo history',
        },
      },
      opts = {
        -- don't use `defaults = { }` here, do this in the main telescope spec
        extensions = {
          undo = {
            -- telescope-undo.nvim config, see below
          },
        },
      },
      config = function(_, opts)
        -- Calling telescope's setup from multiple specs does not hurt, it will happily merge the
        -- configs for us. We won't use data, as everything is in it's own namespace (telescope
        -- defaults, as well as each extension).
        require('telescope').setup(opts)
        require('telescope').load_extension 'undo'
      end,
    },
    {
      -- Using local development version with built-in help feature
      dir = '/Users/kyle/Code/meta-nvim/telescope-live-grep-args.nvim',
      name = 'telescope-live-grep-args.nvim',
      dev = true,
    },
  },
  config = function()
    local actions = require 'telescope.actions'
    require('telescope').setup {
      -- You can put your default mappings / updates / etc. in here
      --  All the info you're looking for is in `:help telescope.setup()`
      --
      pickers = {
        git_commits = {
          git_command = { 'git', 'log', '--no-merges', '--pretty=oneline', '--abbrev-commit', '--', '.' },
        },
        buffers = {
          sort_mru = true,
          -- ignore_current_buffer = true, -- optional, hides current buffer from the lis
          -- sorting_strategy = 'ascending',
          mappings = {
            i = {
              ['<c-d>'] = 'delete_buffer',
            },
            n = {
              ['d'] = 'delete_buffer',
            },
          },
        },
        find_files = {
          -- hidden = true,
          -- Optional: don't ignore .gitignore rules
          -- no_ignore = true,
        },
        live_grep = {
          hidden = true,

          -- Optional: don't ignore .gitignore rules
          -- no_ignore = true,
        },
        current_buffer_fuzzy_find = {
          sorting_strategy = 'ascending', -- Enable ascending sort for consistency
          prompt_title = 'Swiper <3',
        },
      },
      defaults = {
        winblend = 20, -- 15% transparency
        mappings = {
          i = { -- Insert mode mapping
            ['<C-F>'] = 'to_fuzzy_refine',
          },
          n = { -- Normal mode mapping
            ['<C-K>'] = actions.preview_scrolling_up,
            ['<C-J>'] = actions.preview_scrolling_down,
            ['<C-F>'] = 'to_fuzzy_refine',
          },
        },
        sorting_strategy = 'descending',
        initial_mode = 'insert',
        wrap_results = false,
      },
      extensions = {
        ['ui-select'] = {
          require('telescope.themes').get_dropdown(),
        },
        live_grep_args = {
          -- The help keymap (?) is enabled by default
          -- You can customize mappings here if needed:
          -- mappings = {
          --   i = {
          --     ["<C-h>"] = require("telescope-live-grep-args.actions").show_help,
          --   }
          -- }
        },
      },
    }

    -- Enable Telescope extensions if they are installed
    pcall(require('telescope').load_extension, 'fzf')
    pcall(require('telescope').load_extension, 'ui-select')
    pcall(require('telescope').load_extension 'live_grep_args')

    -- See `:help telescope.builtin`
    local builtin = require 'telescope.builtin'
    vim.keymap.set('n', '<leader>sh', builtin.help_tags, { desc = '[S]earch [H]elp' })
    vim.keymap.set('n', '<leader>sk', builtin.keymaps, { desc = '[S]earch [K]eymaps' })
    vim.keymap.set('n', '<leader>sf', builtin.find_files, { desc = '[S]earch [F]iles' })
    vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = '[F]ind [F]iles' })
    vim.keymap.set('n', '<leader>sS', builtin.builtin, { desc = '[S]earch [S]elect Telescope' })
    vim.keymap.set('n', '<leader>sW', builtin.grep_string, { desc = '[S]earch current [W]ord' })
    -- vim.keymap.set('n', '<leader>sg', builtin.live_grep, { desc = '[S]earch by [G]rep' })
    vim.keymap.set('n', '<leader>sD', builtin.diagnostics, { desc = '[S]earch [D]iagnostics' })
    vim.keymap.set('n', '<leader>sr', builtin.resume, { desc = '[S]earch [R]esume' })
    vim.keymap.set('n', '<leader>s.', builtin.oldfiles, { desc = '[S]earch Recent Files ("." for repeat)' })
    vim.keymap.set('n', '<leader>bb', builtin.buffers, { desc = '[B]uffers Find existing buffers' })
    vim.keymap.set('n', '<leader>s"', builtin.registers, { desc = '[S]earch ["]Registers' })
    -- These are also set in LSP attach keymaps - removing duplicates here

    -- Git Telescope keymaps
    vim.keymap.set('n', '<leader>gf', builtin.git_files, { desc = '[G]it [F]iles (tracked)' })
    vim.keymap.set('n', '<leader>pf', builtin.git_files, { desc = '[P]roject [F]iles (git tracked)' }) -- Alias for muscle memory
    vim.keymap.set('n', '<leader>gs', builtin.git_status, { desc = '[G]it [S]tatus (changed files)' })
    vim.keymap.set('n', '<leader>gc', builtin.git_commits, { desc = '[G]it [C]ommits (repo history)' })
    vim.keymap.set('n', '<leader>gb', builtin.git_bcommits, { desc = '[G]it [B]uffer Commits (current file)' })
    vim.keymap.set('n', '<leader>gB', builtin.git_branches, { desc = '[G]it [B]ranches (checkout)' })
    vim.keymap.set('n', '<leader>gS', builtin.git_stash, { desc = '[G]it [S]tash (apply/view)' })

    -- Swiper <3
    local function swiper()
      -- Detect if we're in a terminal buffer
      local is_terminal = vim.bo.buftype == 'terminal'

      -- Get the current buffer number
      local current_bufnr = vim.api.nvim_get_current_buf()

      -- Configure based on buffer type
      if is_terminal then
        -- For terminal buffers, use a horizontal layout like grep preview
        local config = {
          layout_strategy = 'horizontal',
          sorting_strategy = 'ascending', -- Make results go from top to bottom
          layout_config = {
            width = 0.95,
            height = 0.85,
            preview_width = 0.55,
            prompt_position = 'bottom',
          },
          previewer = require('custom.plugins.telescope.previewers.terminal'):new {
            bufnr = current_bufnr,
          },
        }

        -- Run with our custom previewer
        require('telescope.builtin').current_buffer_fuzzy_find(config)
      else
        -- For normal buffers, use the default ivy theme
        local config = {
          sorting_strategy = 'ascending', -- Make results go from top to bottom for consistency
          layout_config = {
            height = 0.6,
            prompt_position = 'bottom',
          },
        }

        -- Run with standard configuration
        require('telescope.builtin').current_buffer_fuzzy_find(require('telescope.themes').get_ivy(config))
      end
    end
    vim.keymap.set('n', '<leader>/', swiper, { desc = '[/] Fuzzy search in buffer', silent = true })
    vim.keymap.set('n', '<leader>ss', swiper, { desc = 'Swiper <3', silent = true })

    vim.keymap.set('n', '<leader>s/', function()
      require('telescope').extensions.live_grep_args.live_grep_args {
        prompt_title = '[S]earch [/] (With Args)',
        disable_coordinates = 'true',
        wrap_results = false,
      }
    end, { desc = '[S]earch [/] (With Args)' })

    vim.keymap.set('n', '<leader>sg', function() -- Alias
      require('telescope').extensions.live_grep_args.live_grep_args {
        prompt_title = '[S]earch [/] (With Args)',
        disable_coordinates = 'true',
        wrap_results = false,
      }
    end, { desc = '[S]earch [/] (With Args)' })

    -- Shortcut for searching your Neovim configuration files
    vim.keymap.set('n', '<leader>sn', function()
      builtin.find_files { cwd = vim.fn.stdpath 'config' }
    end, { desc = '[S]earch [N]eovim files' })
  end,
}
