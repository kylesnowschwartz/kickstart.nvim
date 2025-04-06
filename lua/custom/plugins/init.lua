-- You can add your own plugins here or in other files in this directory!
--  I promise not to create any merge conflicts in this directory :)
--
-- See the kickstart.nvim README for more information
return {
  {
    'rmagatti/auto-session',
    lazy = false,

    ---enables autocomplete for opts
    ---@module "auto-session"
    ---@type AutoSession.Config
    opts = {
      suppressed_dirs = { '~/', '~/Projects', '~/Downloads', '~/Code', '/' },
      pre_save_cmds = {
        function()
          -- Remove scratch buffers before saving the session
          for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
            if vim.api.nvim_buf_is_valid(bufnr) and vim.b[bufnr] and vim.b[bufnr].scratch_buffer then
              vim.api.nvim_buf_delete(bufnr, { force = true })
            end
          end
        end,
      },
      -- log_level = 'debug',
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
    }, -- for default options, refer to the configuration section for custom setup.
    cmd = 'Trouble',
    keys = {},
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
}
