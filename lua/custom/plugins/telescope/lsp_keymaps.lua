local M = {}

function M.setup_lsp_keymaps(bufnr)
  local map = function(keys, func, desc, mode)
    mode = mode or 'n'
    vim.keymap.set(mode, keys, func, { buffer = bufnr, desc = 'LSP: ' .. desc })
  end

  local builtin = require 'telescope.builtin'

  map('grr', builtin.lsp_references, '[G]oto [R]eferences')
  map('gd', builtin.lsp_definitions, '[G]oto [D]efinition')
  map('grd', builtin.lsp_definitions, '[G]oto [D]efinition')
  map('gri', builtin.lsp_implementations, '[G]oto [I]mplementation')
  map('gy', builtin.lsp_type_definitions, '[G]oto T[y]pe Definition')

  -- Keep code action with tiny-code-action
  map('gra', function()
    require('tiny-code-action').code_action {}
  end, '[C]ode [A]ction')

  -- Keep rename with native handler
  map('grn', vim.lsp.buf.rename, '[R]e[n]ame')

  -- Keep declaration with native handler
  map('grD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
end

return M
