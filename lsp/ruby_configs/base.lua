-- ============================================================================
-- Base Ruby LSP Configuration
-- Common settings for all Rails projects
-- ============================================================================

local M = {}

-- Default Rails gems that should be prioritized for indexing
M.priority_gems = {
  'rails',
  'activerecord',
  'actionpack',
  'activesupport',
  'actionview',
  'actionmailer',
  'activejob',
  'railties',
  'rake',
  'bundler',
}

-- Base configuration for Rails projects
M.base_config = {
  -- Rails add-on integration
  addonSettings = {
    ['Ruby LSP Rails'] = {
      enableRuntimeIntrospection = true,
    },
  },

  -- Standard experimental features
  experimental = {
    constantResolution = true,
    scopeResolution = true,
    metaprogrammingAnalysis = true,
    railsIntegration = true,
  },

  -- Basic indexing strategy
  indexing = {
    strategy = 'progressive',
    enableSmartGemIndexing = true,
    excludedPatterns = {
      '**/node_modules/**/*',
      '**/tmp/**/*',
      '**/vendor/**/*',
      '**/coverage/**/*',
      '**/public/assets/**/*',
      '**/log/**/*',
    },
  },

  -- Standard formatting
  formatting = {
    rubyLsp = {
      linters = { 'rubocop' },
      formatters = { 'rubocop' },
    },
  },
}

-- Common excluded patterns for test files (lighter exclusion for standard projects)
M.standard_excludes = {
  '**/spec/fixtures/**/*',
  '**/test/fixtures/**/*',
}

return M
