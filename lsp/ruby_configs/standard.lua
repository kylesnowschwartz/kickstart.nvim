-- ============================================================================
-- Standard Ruby LSP Configuration
-- Configuration for typical Rails projects
-- ============================================================================

local base = require 'lsp.ruby_configs.base'
local M = {}

-- Standard priority gems (just the base ones)
M.priority_gems = base.priority_gems

-- Standard configuration (minimal extensions to base)
M.config = vim.tbl_deep_extend('force', base.base_config, {
  -- Conservative indexing for standard projects
  indexing = {
    strategy = 'progressive',
    enableSmartGemIndexing = true,
    maxConcurrentIndexers = 4, -- More conservative
    excludedPatterns = base.base_config.indexing.excludedPatterns,
  },

  -- Standard performance settings
  performance = {
    enableFileWatcher = true,
    incrementalSync = true,
    backgroundIndexing = false, -- More conservative
  },
})

-- Light excludes for standard projects (don't exclude all tests)
M.excludes = base.standard_excludes

return M
