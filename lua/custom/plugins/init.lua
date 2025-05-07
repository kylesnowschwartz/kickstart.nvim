return {
  {
    'rmagatti/auto-session',
    lazy = false,

    ---enables autocomplete for opts
    ---@module "auto-session"
    ---@type AutoSession.Config
    opts = {
      suppressed_dirs = { '~/', '~/Projects', '~/Downloads', '~/Code', '/' },
      -- log_level = 'debug',

      pre_save_cmds = {
        function()
          return require('custom.plugins.auto-session.helpers').cleanup_scratch_buffers()
        end,
      },

      -- Save whether claude-code terminal exists
      save_extra_cmds = {
        function()
          local helpers = require 'custom.plugins.auto-session.helpers'

          local has_claude, _ = helpers.detect_claude_code_terminal()

          -- Return Vim commands to be saved in the extra session file
          if has_claude then
            return { 'let g:had_claude_code_buffer = 1' }
          else
            return { 'let g:had_claude_code_buffer = 0' }
          end
        end,
      },

      -- Restore claude-code terminal after session load
      post_restore_cmds = {
        function()
          local helpers = require 'custom.plugins.auto-session.helpers'
          return helpers.restore_claude_code()
        end,
      },
    },
  },
  {
    'norcalli/nvim-colorizer.lua',
    config = function()
      require('colorizer').setup()
    end,
  },
  {
    'christoomey/vim-tmux-navigator',
    cmd = {
      'TmuxNavigateLeft',
      'TmuxNavigateDown',
      'TmuxNavigateUp',
      'TmuxNavigateRight',
      'TmuxNavigatePrevious',
      'TmuxNavigatorProcessList',
    },
    keys = {
      { '<leader>wh', '<cmd>TmuxNavigateLeft<cr>' },
      { '<leader>wj', '<cmd>TmuxNavigateDown<cr>' },
      { '<leader>wk', '<cmd>TmuxNavigateUp<cr>' },
      { '<leader>wl', '<cmd>TmuxNavigateRight<cr>' },
    },
  },
  {
    'folke/trouble.nvim',
    opts = {
      focus = true,
      win = {
        type = 'split',
        position = 'right',
        size = 0.5, -- Proportion of the editor's width
        -- type = 'float', -- Use a floating window
        -- position = 'bottom', -- Position of the floating window
        -- height = 10, -- Height of the floating window
        -- width = 50, -- Width of the floating window
        -- border = 'rounded', -- Border style: "single", "double", "rounded", "shadow", or a table of border characters
      },
      auto_preview = true,
      fold_open = '▾',
      fold_closed = '▸',
      indent_lines = true,
      use_diagnostic_signs = true,
    },
    cmd = 'Trouble',
    keys = {
      { '<leader>xx', '<cmd>Trouble<cr>', desc = 'Trouble Toggle' },
      { '<leader>xw', '<cmd>Trouble workspace_diagnostics<cr>', desc = 'Trouble Workspace Diagnostics' },
      { '<leader>xd', '<cmd>Trouble document_diagnostics<cr>', desc = 'Trouble Document Diagnostics' },
      { '<leader>xl', '<cmd>Trouble loclist<cr>', desc = 'Trouble Location List' },
      { '<leader>xq', '<cmd>Trouble quickfix<cr>', desc = 'Trouble Quickfix' },
      { '<leader>xr', '<cmd>Trouble lsp_references<cr>', desc = 'Trouble References' },
    },
  },
  {
    'ruifm/gitlinker.nvim',
    dependencies = {
      'nvim-lua/plenary.nvim',
    },
    opts = {
      mappings = '<leader>gyy',
    },
  },
  {
    'NeogitOrg/neogit',
    dependencies = {
      'nvim-lua/plenary.nvim', -- required
      'sindrets/diffview.nvim', -- optional - Diff integration
      'nvim-telescope/telescope.nvim',
    },
    config = true,
    keys = {
      { '<leader>gG', '<cmd>Neogit cwd=%:p:h<cr>', desc = 'Neogit (cwd)' },
      { '<leader>gg', '<cmd>Neogit<cr>', desc = 'Neogit (project)' },
      { '<leader>gl', '<cmd>Neogit log<cr>', desc = 'Neogit Log (project)' },
    },
  },
  {
    'greggh/claude-code.nvim',
    dependencies = {
      'nvim-lua/plenary.nvim', -- Required for git operations
    },
    config = function()
      require('claude-code').setup {
        command = '/Users/kyle/.claude-wrapper',
        window = {
          position = 'vsplit',
          split_ratio = 0.4,
          hide_numbers = true,
        },
        keymaps = {
          toggle = {
            normal = '<leader>cc', -- Normal mode keymap for toggling Claude Code, false to disable
            variants = {
              continue = '<leader>cC', -- Normal mode keymap for Claude Code with continue flag
              resume = '<leader>cR', -- Normal mode keymap for Claude Code with verbose flag
              verbose = '<leader>cV', -- Normal mode keymap for Claude Code with verbose flag
            },
          },
        },
      }
    end,
  },
  {
    'fabridamicelli/cronex.nvim',
    config = function()
      require('cronex').setup {
        file_patterns = { '*.yaml', '*.yml', '*.tf', '*.cfg', '*.config', '*.conf', '*.crontab' },
        extractor = {
          cron_from_line = require('cronex.cron_from_line').cron_from_line_crontab,
          extract = require('cronex.extract').extract,
        },
      }
    end,
  },
}
