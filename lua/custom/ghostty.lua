-- Ghostty documentation viewer for Neovim
-- Integrates with which-key

local M = {}

-- Function to open Ghostty documentation
function M.open_docs()
  -- Check if ghostty command exists
  local has_ghostty = vim.fn.executable 'ghostty' == 1

  if not has_ghostty then
    vim.notify('Ghostty terminal is not installed or not in PATH', vim.log.levels.ERROR)
    return
  end

  -- Create a new buffer in a split
  vim.cmd 'new'

  -- Set buffer name
  vim.api.nvim_buf_set_name(0, 'ghostty-docs')

  -- Fill buffer with Ghostty docs
  vim.cmd 'read !ghostty +show-config --default --docs'

  -- Remove the first empty line
  vim.cmd '1delete'

  -- Set buffer options
  vim.bo.filetype = 'conf'
  vim.bo.buftype = 'nofile'
  vim.bo.modifiable = true
  vim.bo.modified = false

  -- Set up additional key mappings for the docs buffer
  vim.api.nvim_buf_set_keymap(0, 'n', 'q', ':bdelete<CR>', { noremap = true, silent = true })

  -- Enable folding by hash sections (these are window options, not buffer options)
  vim.wo.foldmethod = 'expr'
  vim.wo.foldexpr = 'getline(v:lnum)=~"^#" ? ">1" : "="'
  vim.cmd 'normal! zR' -- Open all folds initially
end

-- Create user command
vim.api.nvim_create_user_command('GhosttyDocs', function()
  M.open_docs()
end, {})

return M
