-- ============================================================================
-- Modular Ruby LSP Configuration
-- Dynamically loads project-specific configurations
-- ============================================================================

-- Load project-specific configurations using dofile for lsp/ directory
local config_dir = vim.fn.stdpath 'config' .. '/lsp/ruby_configs/'
local configs = {
  standard = dofile(config_dir .. 'standard.lua'),
  marketplace = dofile(config_dir .. 'marketplace.lua'),
}

-- Project detection logic
local project_detectors = {
  marketplace = function(root_dir)
    return root_dir and (root_dir:match '/marketplace$' or root_dir:match '/marketplace/')
  end,
  -- Add more project detectors here as needed
}

local function detect_project_config(root_dir)
  for project_name, detector in pairs(project_detectors) do
    if detector(root_dir) then
      return project_name, configs[project_name]
    end
  end
  return 'standard', configs.standard
end

-- Helper function to collect bundle gem paths with project-specific prioritization
local function collect_bundle_gem_paths(root_dir)
  vim.notify('Collecting bundle gem paths for: ' .. root_dir, vim.log.levels.INFO)
  local all_gem_paths = {}
  local priority_gem_paths = {}

  -- Get project-specific configuration
  local project_name, project_config = detect_project_config(root_dir)
  local priority_gems = project_config.priority_gems

  if vim.fn.filereadable(root_dir .. '/Gemfile') == 1 then
    local gem_paths_cmd = 'cd ' .. root_dir .. ' && bundle show --paths 2>/dev/null'
    local gem_paths_output = vim.fn.system(gem_paths_cmd)

    if gem_paths_output and gem_paths_output ~= '' then
      local priority_pattern = '(' .. table.concat(priority_gems, '|') .. ')'

      for path in string.gmatch(gem_paths_output, '[^\r\n]+') do
        if vim.fn.isdirectory(path) == 1 then
          table.insert(all_gem_paths, path)

          -- Check if this is a priority gem (for faster initial indexing)
          if path:match(priority_pattern) then
            table.insert(priority_gem_paths, path)
          end
        end
      end
    end
  end

  local total_gems = #all_gem_paths
  local priority_gems = #priority_gem_paths

  vim.notify(
    string.format(
      '[%s] Found %d gems (%d priority, %d others) - using smart indexing',
      project_name:upper(),
      total_gems,
      priority_gems,
      total_gems - priority_gems
    ),
    vim.log.levels.INFO
  )

  return all_gem_paths
end

-- Detect if we're in the Marketplace project
local function is_marketplace_project(root_dir)
  if not root_dir then
    return false
  end
  return root_dir:match '/marketplace$' or root_dir:match '/marketplace/'
end

-- Count Ruby files for performance monitoring
local function count_ruby_files(root_dir)
  if not root_dir then
    return 0
  end
  local count_cmd = string.format('fd -e rb . "%s" | wc -l', root_dir)
  local result = vim.fn.system(count_cmd)
  return tonumber(result) or 0
end

-- Performance monitoring for LSP startup
local function monitor_lsp_performance(client, root_dir)
  local file_count = count_ruby_files(root_dir)
  vim.notify(string.format('Ruby LSP initializing with %d Ruby files', file_count), vim.log.levels.INFO)

  if file_count > 5000 then
    vim.notify('Large codebase detected - LSP startup may take 10-30 seconds', vim.log.levels.WARN)
  end

  -- Monitor for common issues
  vim.defer_fn(function()
    local rails_addon_active = false
    if client.server_capabilities then
      vim.notify('Ruby LSP ready - Rails add-on status: ' .. (rails_addon_active and 'Active' or 'Checking...'), vim.log.levels.INFO)
    end
  end, 5000)
end

-- Get project-specific LSP configuration
local function get_project_config(root_dir)
  local project_name, project_config = detect_project_config(root_dir)

  local lsp_config = vim.tbl_deep_extend('force', {
    -- Base LSP settings
    addonSettings = project_config.config.addonSettings,
    enabledFeatureFlags = {
      all = true,
      experimentalFeaturesEnabled = true,
    },
    initializationOptions = project_config.config,
    formatter = 'rubocop',
    linters = project_config.config.formatting.rubyLsp.linters,
  }, {})

  return lsp_config, project_name
end

-- Enhanced on_init function with project-specific optimizations
local function enhanced_on_init(client, initialize_result)
  local root = client.config.root_dir
  if not root then
    return true
  end

  -- Collect bundle gem paths (existing functionality)
  client.config.settings = client.config.settings or {}
  client.config.settings.bundleGemPaths = collect_bundle_gem_paths(root)

  -- Apply project-specific configuration
  local config_updates, project_name = get_project_config(root)

  -- Update client configuration
  for key, value in pairs(config_updates) do
    client.config.init_options = client.config.init_options or {}
    client.config.init_options[key] = value
  end

  -- Send addon settings via workspace configuration
  if config_updates.addonSettings then
    client.config.settings = client.config.settings or {}
    client.config.settings.addonSettings = config_updates.addonSettings

    -- Send configuration to server after initialization
    vim.defer_fn(function()
      if client.request then
        client.request('workspace/didChangeConfiguration', {
          settings = client.config.settings,
        }, function(err, result)
          if err then
            vim.notify('Failed to send addon settings: ' .. tostring(err.message), vim.log.levels.WARN)
          else
            vim.notify('Runtime introspection settings applied successfully', vim.log.levels.INFO)
          end
        end)
      end
    end, 1000)
  end

  -- Performance monitoring
  monitor_lsp_performance(client, root)

  -- Debug information for troubleshooting
  vim.defer_fn(function()
    vim.notify(string.format('[%s] Project-specific optimizations applied', project_name:upper()), vim.log.levels.INFO)
  end, 2000)

  return true
end

-- Main LSP configuration
return {
  cmd = { 'ruby-lsp' }, -- Do not use bundle exec to allow for Mason or Bundled installations interchangeably
  filetypes = { 'ruby' },
  root_markers = { 'Gemfile', '.git' },

  -- Enhanced initialization with marketplace optimizations
  on_init = enhanced_on_init,

  -- Enhanced settings with marketplace awareness
  settings = {
    -- RuboCop configuration
    rubocop = {
      configPath = '.rubocop.yml',
    },

    -- Default formatter
    formatter = {
      name = 'rubocop',
    },

    -- Enable experimental features
    experimentalFeaturesEnabled = true,

    -- Core features - optimized loading order for performance
    enabledFeatures = {
      -- Essential features loaded first
      'completion',
      'hover',
      'diagnostics',
      'documentSymbols',

      -- Navigation features
      'documentHighlights',
      'semanticHighlighting',

      -- Formatting and editing
      'formatting',
      'codeActions',
      'inlayHint',
      'onTypeFormatting',

      -- Advanced features
      'foldingRanges',
      'selectionRanges',
      'codeLens',
    },

    -- Bundle gem paths (dynamically updated in on_init)
    bundleGemPaths = {},

    -- Enhanced Ruby-specific settings
    ruby = {
      experimental = true,
      semanticHighlighting = true,
      completion = {
        enableSnippets = true,
      },
    },
  },

  -- Enhanced capabilities for better Rails integration
  capabilities = (function()
    local capabilities = vim.lsp.protocol.make_client_capabilities()

    -- Enable enhanced completion
    capabilities.textDocument.completion.completionItem.snippetSupport = true
    capabilities.textDocument.completion.completionItem.resolveSupport = {
      properties = { 'documentation', 'detail', 'additionalTextEdits' },
    }

    -- Enable workspace configuration
    capabilities.workspace.configuration = true
    capabilities.workspace.didChangeConfiguration = { dynamicRegistration = true }

    return capabilities
  end)(),

  -- Custom handlers for debugging scope/constant resolution issues
  handlers = {
    -- Enhanced hover handler with debugging
    ['textDocument/hover'] = function(err, result, ctx, config)
      if err then
        vim.notify('LSP Hover Error: ' .. tostring(err.message), vim.log.levels.WARN)
      end
      return vim.lsp.handlers['textDocument/hover'](err, result, ctx, config)
    end,

    -- Enhanced definition handler with debugging
    ['textDocument/definition'] = function(err, result, ctx, config)
      if err then
        vim.notify('LSP Definition Error: ' .. tostring(err.message), vim.log.levels.WARN)
      elseif not result or #result == 0 then
        -- Debug why definition wasn't found
        local word = vim.fn.expand '<cword>'
        vim.notify(string.format('Definition not found for "%s" - check if it\'s a Rails scope or metaprogrammed method', word), vim.log.levels.INFO)
      end
      return vim.lsp.handlers['textDocument/definition'](err, result, ctx, config)
    end,

    -- Enhanced references handler
    ['textDocument/references'] = function(err, result, ctx, config)
      if err then
        vim.notify('LSP References Error: ' .. tostring(err.message), vim.log.levels.WARN)
      elseif not result or #result == 0 then
        local word = vim.fn.expand '<cword>'
        vim.notify(string.format('No references found for "%s" - check if it\'s indexed properly', word), vim.log.levels.INFO)
      end
      return vim.lsp.handlers['textDocument/references'](err, result, ctx, config)
    end,
  },
}
