return { -- Fuzzy Finder (files, lsp, etc)
  'nvim-telescope/telescope.nvim',
  enabled = false,
  event = 'VimEnter',
  branch = '0.1.x',
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
      enabled = false,
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
  },
  config = function()
    -- Telescope is a fuzzy finder that comes with a lot of different things that
    -- it can fuzzy find! It's more than just a "file finder", it can search
    -- many different aspects of Neovim, your workspace, LSP, and more!
    --
    -- The easiest way to use Telescope, is to start by doing something like:
    --  :Telescope help_tags
    --
    -- After running this command, a window will open up and you're able to
    -- type in the prompt window. You'll see a list of `help_tags` options and
    -- a corresponding preview of the help.
    --
    -- Two important keymaps to use while in Telescope are:
    --  - Insert mode: <c-/>
    --  - Normal mode: ?
    --
    -- This opens a window that shows you all of the keymaps for the current
    -- Telescope picker. This is really useful to discover what Telescope can
    -- do as well as how to actually do it!

    -- [[ Configure Telescope ]]
    -- See `:help telescope` and `:help telescope.setup()`
    --
    local open_with_trouble = require('trouble.sources.telescope').open

    -- Use this to add more results without clearing the trouble list
    -- local add_to_trouble = require('trouble.sources.telescope').add
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
          -- sort_lastused = true,
          sort_mru = true,
          -- sorting_strategy = 'ascending',
          -- initial_mode = 'normal',
        },
        find_files = {
          hidden = true,
          -- Optional: don't ignore .gitignore rules
          -- no_ignore = true,
        },
        live_grep = {
          hidden = true,
          -- Optional: don't ignore .gitignore rules
          -- no_ignore = true,
        },
        current_buffer_fuzzy_find = {
          -- sorting_strategy = 'ascending',
          prompt_title = false,
        },
      },
      defaults = {
        mappings = {
          i = { -- Insert mode mapping
            ['<C-T>'] = open_with_trouble,
            ['<C-F>'] = 'to_fuzzy_refine',
          },
          n = { -- Normal mode mapping
            ['<C-T>'] = open_with_trouble,
            ['<C-K>'] = actions.preview_scrolling_up,
            ['<C-J>'] = actions.preview_scrolling_down,
            ['<C-F>'] = 'to_fuzzy_refine',
          },
        },
        sorting_strategy = 'descending',
        initial_mode = 'insert',
        wrap_results = true,
      },
      extensions = {
        ['ui-select'] = {
          require('telescope.themes').get_dropdown(),
        },
      },
    }

    -- Enable Telescope extensions if they are installed
    pcall(require('telescope').load_extension, 'fzf')
    pcall(require('telescope').load_extension, 'ui-select')

    -- See `:help telescope.builtin`
    local builtin = require 'telescope.builtin'
    vim.keymap.set('n', '<leader>sh', builtin.help_tags, { desc = '[S]earch [H]elp' })
    vim.keymap.set('n', '<leader>sk', builtin.keymaps, { desc = '[S]earch [K]eymaps' })
    vim.keymap.set('n', '<leader>sf', builtin.find_files, { desc = '[S]earch [F]iles' })
    vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = '[F]ind [F]iles' })
    vim.keymap.set('n', '<leader>sS', builtin.builtin, { desc = '[S]earch [S]elect Telescope' })
    vim.keymap.set('n', '<leader>sW', builtin.grep_string, { desc = '[S]earch current [W]ord' })
    vim.keymap.set('n', '<leader>sg', builtin.live_grep, { desc = '[S]earch by [G]rep' })
    vim.keymap.set('n', '<leader>sD', builtin.diagnostics, { desc = '[S]earch [D]iagnostics' })
    vim.keymap.set('n', '<leader>sr', builtin.resume, { desc = '[S]earch [R]esume' })
    vim.keymap.set('n', '<leader>s.', builtin.oldfiles, { desc = '[S]earch Recent Files ("." for repeat)' })
    vim.keymap.set('n', '<leader>bb', builtin.buffers, { desc = '[B]uffers Find existing buffers' })
    vim.keymap.set('n', '<leader>s"', builtin.registers, { desc = '[S]earch ["]Registers' })
    vim.keymap.set('n', '<leader>sw', builtin.lsp_dynamic_workspace_symbols, { desc = '[S]earch [W]orkspace Symbols' })
    vim.keymap.set('n', '<leader>sd', builtin.lsp_document_symbols, { desc = '[S]earch [D]ocument Symbols' })

    -- Git Telescope keymaps
    vim.keymap.set('n', '<leader>gf', builtin.git_files, { desc = '[G]it [F]iles (tracked)' })
    vim.keymap.set('n', '<leader>gs', builtin.git_status, { desc = '[G]it [S]tatus (changed files)' })
    vim.keymap.set('n', '<leader>gc', builtin.git_commits, { desc = '[G]it [C]ommits (repo history)' })
    vim.keymap.set('n', '<leader>gb', builtin.git_bcommits, { desc = '[G]it [B]uffer Commits (current file)' })
    vim.keymap.set('n', '<leader>gB', builtin.git_branches, { desc = '[G]it [B]ranches (checkout)' })
    vim.keymap.set('n', '<leader>gS', builtin.git_stash, { desc = '[G]it [S]tash (apply/view)' })

    -- Swiper <3
    local function swiper()
      require('telescope.builtin').current_buffer_fuzzy_find(require('telescope.themes').get_ivy {
        previewer = true,
        layout_config = {
          height = 0.6,
          prompt_position = 'bottom',
        },
      })
    end
    vim.keymap.set('n', '<leader>/', swiper, { desc = '[/] Fuzzy search in buffer', silent = true })
    vim.keymap.set('n', '<leader>ss', swiper, { desc = 'Swiper <3', silent = true })

    -- It's also possible to pass additional configuration options.
    --  See `:help telescope.builtin.live_grep()` for information about particular keys
    vim.keymap.set('n', '<leader>s/', function()
      builtin.live_grep {
        grep_open_files = true,
        prompt_title = 'Live Grep in Open Files',
      }
    end, { desc = '[S]earch [/] in Open Files' })

    -- Shortcut for searching your Neovim configuration files
    vim.keymap.set('n', '<leader>sn', function()
      builtin.find_files { cwd = vim.fn.stdpath 'config' }
    end, { desc = '[S]earch [N]eovim files' })
  end,
}
