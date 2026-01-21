return {
  { -- Highlight, edit, and navigate code
    'nvim-treesitter/nvim-treesitter',
    branch = 'main', -- Use rewritten branch (requires Neovim 0.11+ nightly)
    lazy = false, -- Required: does not support lazy-loading
    build = ':TSUpdate',
    config = function()
      require('nvim-treesitter').setup {
        install_dir = vim.fn.stdpath 'data' .. '/site',
      }

      local parsers = {
        'bash',
        'c',
        'css',
        'diff',
        'editorconfig',
        'git_config',
        'git_rebase',
        'gitattributes',
        'gitcommit',
        'gitignore',
        'go',
        'gomod',
        'gosum',
        'gowork',
        'html',
        'javascript',
        'json',
        'lua',
        'luadoc',
        'make',
        'markdown',
        'markdown_inline',
        'python',
        'query',
        'regex',
        'ruby',
        'rust',
        'scss',
        'toml',
        'tsx',
        'typescript',
        'vim',
        'vimdoc',
        'xml',
        'yaml',
      }

      -- Install parsers after lazy.nvim is fully loaded
      vim.api.nvim_create_autocmd('User', {
        pattern = 'LazyDone',
        once = true,
        callback = function()
          require('nvim-treesitter').install(parsers)
        end,
      })

      -- Enable treesitter features per filetype
      vim.api.nvim_create_autocmd('FileType', {
        pattern = {
          'bash',
          'sh',
          'c',
          'css',
          'diff',
          'go',
          'gomod',
          'html',
          'javascript',
          'json',
          'lua',
          'make',
          'markdown',
          'python',
          'ruby',
          'rust',
          'scss',
          'toml',
          'tsx',
          'typescript',
          'vim',
          'xml',
          'yaml',
        },
        callback = function()
          -- Enable highlighting (provided by Neovim)
          vim.treesitter.start()

          -- Enable folding (provided by Neovim)
          vim.wo.foldmethod = 'expr'
          vim.wo.foldexpr = 'v:lua.vim.treesitter.foldexpr()'

          -- Enable indentation (experimental, provided by nvim-treesitter)
          vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        end,
      })

      -- Start with folds open by default
      vim.opt.foldenable = false
    end,
  },

  { -- Textobjects: select, move, swap based on syntax
    'nvim-treesitter/nvim-treesitter-textobjects',
    branch = 'main',
    event = 'VeryLazy',
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
    config = function()
      require('nvim-treesitter-textobjects').setup {
        select = {
          lookahead = true, -- Jump forward to textobj if not on one
        },
        move = {
          set_jumps = true, -- Add movements to jumplist
        },
      }

      local map = vim.keymap.set

      -- Textobject selections (visual and operator-pending modes)
      map({ 'x', 'o' }, 'af', function()
        require('nvim-treesitter-textobjects.select').select_textobject('@function.outer', 'textobjects')
      end, { desc = 'outer function' })
      map({ 'x', 'o' }, 'if', function()
        require('nvim-treesitter-textobjects.select').select_textobject('@function.inner', 'textobjects')
      end, { desc = 'inner function' })
      map({ 'x', 'o' }, 'ac', function()
        require('nvim-treesitter-textobjects.select').select_textobject('@class.outer', 'textobjects')
      end, { desc = 'outer class' })
      map({ 'x', 'o' }, 'ic', function()
        require('nvim-treesitter-textobjects.select').select_textobject('@class.inner', 'textobjects')
      end, { desc = 'inner class' })
      map({ 'x', 'o' }, 'aa', function()
        require('nvim-treesitter-textobjects.select').select_textobject('@parameter.outer', 'textobjects')
      end, { desc = 'outer argument' })
      map({ 'x', 'o' }, 'ia', function()
        require('nvim-treesitter-textobjects.select').select_textobject('@parameter.inner', 'textobjects')
      end, { desc = 'inner argument' })

      -- Movement: jump between functions and classes
      map({ 'n', 'x', 'o' }, ']f', function()
        require('nvim-treesitter-textobjects.move').goto_next_start('@function.outer', 'textobjects')
      end, { desc = 'Next function start' })
      map({ 'n', 'x', 'o' }, '[f', function()
        require('nvim-treesitter-textobjects.move').goto_previous_start('@function.outer', 'textobjects')
      end, { desc = 'Previous function start' })
      map({ 'n', 'x', 'o' }, ']F', function()
        require('nvim-treesitter-textobjects.move').goto_next_end('@function.outer', 'textobjects')
      end, { desc = 'Next function end' })
      map({ 'n', 'x', 'o' }, '[F', function()
        require('nvim-treesitter-textobjects.move').goto_previous_end('@function.outer', 'textobjects')
      end, { desc = 'Previous function end' })
      map({ 'n', 'x', 'o' }, ']c', function()
        require('nvim-treesitter-textobjects.move').goto_next_start('@class.outer', 'textobjects')
      end, { desc = 'Next class start' })
      map({ 'n', 'x', 'o' }, '[c', function()
        require('nvim-treesitter-textobjects.move').goto_previous_start('@class.outer', 'textobjects')
      end, { desc = 'Previous class start' })
    end,
  },

  { -- Sticky context: shows function/class at top of window
    'nvim-treesitter/nvim-treesitter-context',
    event = 'VeryLazy',
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
    opts = {
      max_lines = 3, -- Max lines of context to show
      min_window_height = 20, -- Only show when window is tall enough
    },
    keys = {
      {
        '[C',
        function()
          require('treesitter-context').go_to_context()
        end,
        desc = 'Go to context',
      },
    },
  },
}
