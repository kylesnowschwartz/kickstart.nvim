local M = {}

function M.setup_lsp_keymaps(bufnr)
  local map = function(keys, func, desc, mode)
    mode = mode or 'n'
    vim.keymap.set(mode, keys, func, { buffer = bufnr, desc = 'LSP: ' .. desc })
  end

  -- Override default LSP mappings with Telescope equivalents
  -- Default: grr -> vim.lsp.buf.references()
  map('grr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')

  -- Default: gra -> vim.lsp.buf.code_action()
  map('gra', function()
    require('tiny-code-action').code_action {}
  end, '[C]ode [A]ction')

  -- Default: grn -> vim.lsp.buf.rename()
  map('grn', vim.lsp.buf.rename, '[R]e[n]ame')

  -- Default: gri -> vim.lsp.buf.implementation()
  map('gri', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')

  -- Default: grd -> vim.lsp.buf.definition()
  map('grd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')

  -- Default: grD -> vim.lsp.buf.declaration()
  map('grD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')

  -- Default: gy -> vim.lsp.buf.type_definition()
  map('gy', require('telescope.builtin').lsp_type_definitions, '[G]oto T[y]pe Definition')

  -- Keep some custom leader-based mappings for discoverability
  -- map('<leader>lds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')
  -- map('<leader>lws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')
end

return M
