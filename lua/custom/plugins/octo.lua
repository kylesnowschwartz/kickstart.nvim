-- octo.nvim - Edit and review GitHub issues, PRs, and code reviews in Neovim
-- https://github.com/pwntester/octo.nvim

return {
  'pwntester/octo.nvim',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-telescope/telescope.nvim',
    'nvim-tree/nvim-web-devicons',
  },
  cmd = 'Octo',
  event = { 'BufReadCmd octo://*' },
  keys = {
    { '<leader>go', '<cmd>Octo<cr>', desc = 'Octo' },
    { '<leader>goi', '<cmd>Octo issue list<cr>', desc = 'List issues' },
    { '<leader>gop', '<cmd>Octo pr list<cr>', desc = 'List PRs' },
    { '<leader>gor', '<cmd>Octo review start<cr>', desc = 'Start PR review' },
    { '<leader>gos', '<cmd>Octo search<cr>', desc = 'Search GitHub' },
  },
  config = function()
    require('octo').setup {
      picker = 'telescope',
      use_local_fs = false,
      enable_builtin = false,
      default_remote = { 'upstream', 'origin' },
      default_merge_method = 'commit',
      ssh_aliases = {},
      reviews = {
        auto_show_threads = true,
        focus = 'right',
      },
      issues = {
        order_by = {
          field = 'CREATED_AT',
          direction = 'DESC',
        },
      },
      pull_requests = {
        order_by = {
          field = 'CREATED_AT',
          direction = 'DESC',
        },
        always_select_remote_on_create = false,
      },
      file_panel = {
        size = 10,
        use_icons = true,
      },
      mappings_disable_default = false,
    }

    -- Load telescope extension for octo pickers
    require('telescope').load_extension 'octo'

    -- Enable treesitter markdown parser for octo buffers
    vim.treesitter.language.register('markdown', 'octo')

    -- Auto-trigger completion for @ (users) and # (issues/PRs)
    vim.api.nvim_create_autocmd('FileType', {
      pattern = 'octo',
      callback = function()
        vim.keymap.set('i', '@', '@<C-x><C-o>', { silent = true, buffer = true, desc = 'Complete users' })
        vim.keymap.set('i', '#', '#<C-x><C-o>', { silent = true, buffer = true, desc = 'Complete issues' })
      end,
    })
  end,
}
