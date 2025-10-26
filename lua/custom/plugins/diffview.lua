-- diffview.nvim - Single tabpage interface for cycling through diffs
-- https://github.com/sindrets/diffview.nvim

return {
  'sindrets/diffview.nvim',
  dependencies = { 'nvim-tree/nvim-web-devicons' }, -- Optional: for file icons
  cmd = {
    'DiffviewOpen',
    'DiffviewClose',
    'DiffviewToggleFiles',
    'DiffviewFocusFiles',
    'DiffviewRefresh',
    'DiffviewFileHistory',
    'DiffviewLog',
  },
  config = function()
    local actions = require 'diffview.actions'

    require('diffview').setup {
      -- Enhanced diff highlighting (recommended)
      enhanced_diff_hl = true,

      -- Enable LSP features in diff buffers (recommended for PR review)
      default_args = {
        DiffviewOpen = { '--imply-local' },
      },

      -- Consistent buffer settings
      hooks = {
        diff_buf_read = function(bufnr)
          vim.opt_local.wrap = false
          vim.opt_local.list = false
        end,
      },

      -- Custom keybindings
      keymaps = {
        view = {
          -- Arrow keys for scrolling diff view (replaces <C-f>/<C-b>)
          { 'n', '<Down>', actions.scroll_view(0.25), { desc = 'Scroll diff down' } },
          { 'n', '<Up>', actions.scroll_view(-0.25), { desc = 'Scroll diff up' } },
        },
        file_panel = {
          -- Disable default arrow key file navigation (use j/k for that)
          { 'n', '<down>', false },
          { 'n', '<up>', false },
          -- Arrow keys scroll the diff view instead
          { 'n', '<Down>', actions.scroll_view(0.25), { desc = 'Scroll diff down' } },
          { 'n', '<Up>', actions.scroll_view(-0.25), { desc = 'Scroll diff up' } },
          -- Override 'o' to open in floating window
          {
            'n',
            'o',
            function()
              local lib = require 'diffview.lib'
              local view = lib.get_current_view()
              if view then
                local file = view.panel:get_item_at_cursor()
                if file and file.path then
                  -- Get absolute path
                  local path = file.absolute_path or file.path
                  require('snacks').win {
                    file = path,
                    width = 0.9,
                    height = 0.9,
                    border = 'rounded',
                    keys = {
                      q = 'close',
                      ['<Esc>'] = 'close',
                    },
                  }
                end
              end
            end,
            { desc = 'Open file in floating window' },
          },
        },
      },
    }
  end,
}
