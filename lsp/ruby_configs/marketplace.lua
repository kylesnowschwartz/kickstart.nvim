-- ============================================================================
-- Marketplace-Specific Ruby LSP Configuration
-- Optimizations for large-scale marketplace application
-- ============================================================================

local base = require 'ruby_configs.base'
local M = {}

-- Marketplace-specific priority gems (extends base)
M.priority_gems = vim.list_extend(vim.deepcopy(base.priority_gems), {
  'sidekiq', -- Heavy background job usage
  'mysql2', -- Primary database adapter
  'redis', -- Caching and sessions
})

-- Marketplace-specific configuration (extends base config)
M.config = vim.tbl_deep_extend('force', base.base_config, {
  -- Enhanced experimental features for complex marketplace logic
  experimental = {
    constantResolution = true,
    scopeResolution = true,
    metaprogrammingAnalysis = true,
    railsIntegration = true,
    advancedTypeInference = true, -- Additional for marketplace complexity
  },

  -- Aggressive indexing optimizations for large codebase
  indexing = {
    strategy = 'progressive',
    enableSmartGemIndexing = true,
    maxConcurrentIndexers = 8, -- Higher for marketplace
    excludedPatterns = {
      -- Standard exclusions from base
      '**/node_modules/**/*',
      '**/tmp/**/*',
      '**/vendor/**/*',
      '**/coverage/**/*',
      '**/public/assets/**/*',
      '**/log/**/*',

      -- Marketplace-specific aggressive exclusions for performance
      '**/spec/**/*_spec.rb',
      '**/test/**/*_test.rb',
      '**/features/**/*.feature',
      '**/engines/*/spec/**/*',
      '**/engines/*/test/**/*',
      '**/doc/**/*',
      '**/docs/**/*',
      '**/tmp/**/*',
      '**/vendor/bundle/**/*',
      '**/vendor/cache/**/*',
    },
  },

  -- Performance tuning for large codebase
  performance = {
    enableFileWatcher = true,
    incrementalSync = true,
    backgroundIndexing = true,
  },
})

-- Enhanced excludes for marketplace (more aggressive)
M.excludes = {
  -- All test-related files for faster startup
  '**/spec/**/*_spec.rb',
  '**/test/**/*_test.rb',
  '**/features/**/*.feature',
  '**/engines/*/spec/**/*',
  '**/engines/*/test/**/*',

  -- Documentation and generated files
  '**/doc/**/*',
  '**/docs/**/*',
  '**/coverage/**/*',
  '**/vendor/bundle/**/*',

  -- Large generated/compiled assets
  '**/public/packs/**/*',
  '**/public/assets/**/*',
  '**/app/assets/builds/**/*',
}

return M
