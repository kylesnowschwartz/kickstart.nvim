-- Adds git related signs to the gutter and current line blame
-- Stripped down to essentials - use neogit/tiny-git/diffview for staging/diffing

return {
  {
    'lewis6991/gitsigns.nvim',
    opts = {
      on_attach = function(bufnr)
        local gitsigns = require 'gitsigns'

        local function map(mode, l, r, opts)
          opts = opts or {}
          opts.buffer = bufnr
          vim.keymap.set(mode, l, r, opts)
        end

        -- Only keep blame toggle - everything else handled by neogit/tiny-git/diffview
        map('n', '<leader>Tb', gitsigns.toggle_current_line_blame, { desc = '[T]oggle git show [b]lame line' })
      end,
    },
  },
}
