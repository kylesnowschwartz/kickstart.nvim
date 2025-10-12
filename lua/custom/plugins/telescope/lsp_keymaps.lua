local M = {}

function M.setup_lsp_keymaps(bufnr)
  local map = function(keys, func, desc, mode)
    mode = mode or 'n'
    vim.keymap.set(mode, keys, func, { buffer = bufnr, desc = 'LSP: ' .. desc })
  end

  map('grr', vim.lsp.buf.references, '[G]oto [R]eferences')
  map('grd', vim.lsp.buf.definition, '[G]oto [D]efinition')
  map('gri', vim.lsp.buf.implementation, '[G]oto [I]mplementation')
  map('gy', vim.lsp.buf.type_definition, '[G]oto T[y]pe Definition')

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
