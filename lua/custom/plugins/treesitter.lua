return {
  { -- Highlight, edit, and navigate code
    'nvim-treesitter/nvim-treesitter',
    branch = 'main', -- Use rewritten branch (requires Neovim 0.11+ nightly)
    lazy = false, -- Required: does not support lazy-loading
    build = ':TSUpdate',
    config = function()
      -- Setup is optional - using default install directory: stdpath('data')/site/
      -- require('nvim-treesitter').setup() -- Not needed for defaults

      -- Install parsers for supported languages (temporary - remove after first run)
      require('nvim-treesitter').install {
        'bash',
        'c',
        'css',
        'scss',
        'diff',
        'html',
        'json',
        'lua',
        'luadoc',
        'markdown',
        'markdown_inline',
        'javascript',
        'typescript',
        'query',
        'vim',
        'vimdoc',
        'python',
        'ruby',
        'rust',
        'go',
        'gomod',
        'gosum',
        'gowork',
      }

      -- Enable treesitter features per filetype
      vim.api.nvim_create_autocmd('FileType', {
        pattern = { 'bash', 'c', 'diff', 'html', 'lua', 'markdown', 'vim', 'ruby', 'go', 'gomod' },
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
    -- There are additional nvim-treesitter modules that you can use to interact
    -- with nvim-treesitter. You should go explore a few and see what interests you:
    --
    --    - Incremental selection: Included, see `:help nvim-treesitter-incremental-selection-mod`
    --    - Show your current context: https://github.com/nvim-treesitter/nvim-treesitter-context
    --    - Treesitter + textobjects: https://github.com/nvim-treesitter/nvim-treesitter-textobjects
  },
}
