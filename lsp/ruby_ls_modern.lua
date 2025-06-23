-- ============================================================================
-- Modern Ruby LSP Configuration
-- Uses Neovim 0.11+ vim.lsp.config API with modular project detection
-- ============================================================================

-- Load project-specific configurations
local configs = {
  standard = require 'ruby_configs.standard',
  marketplace = require 'ruby_configs.marketplace',
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
  local priority_gems_count = #priority_gem_paths

  vim.notify(
    string.format(
      '[%s] Found %d gems (%d priority, %d others) - using smart indexing',
      project_name:upper(),
      total_gems,
      priority_gems_count,
      total_gems - priority_gems_count
    ),
    vim.log.levels.INFO
  )

  return all_gem_paths
end

-- Configure Ruby LSP using modern vim.lsp.config API
vim.lsp.config('ruby_lsp', {
  -- Server command
  cmd = { 'ruby-lsp' },

  -- File types to attach to
  filetypes = { 'ruby' },

  -- Root markers for workspace detection
  root_markers = { 'Gemfile', '.git', '.ruby-version' },

  -- Dynamic root_dir function for project-specific optimization
  root_dir = function(bufnr, on_dir)
    local root = vim.fs.root(bufnr, { 'Gemfile', '.git' })
    if root then
      on_dir(root)
    end
  end,

  -- Capabilities with modern client support
  capabilities = (function()
    local capabilities = vim.lsp.protocol.make_client_capabilities()

    -- Enable completion support
    capabilities.textDocument.completion.completionItem.snippetSupport = true
    capabilities.textDocument.completion.completionItem.resolveSupport = {
      properties = { 'documentation', 'detail', 'additionalTextEdits' },
    }

    -- Enable semantic tokens
    capabilities.textDocument.semanticTokens = {
      multilineTokenSupport = true,
      overlappingTokenSupport = false,
      serverCancelSupport = true,
      augmentsSyntaxTokens = true,
    }

    return capabilities
  end)(),

  -- Project-specific settings function
  settings = function(bufnr)
    local root_dir = vim.lsp.get_clients({ bufnr = bufnr, name = 'ruby_lsp' })[1]?.root_dir
    if not root_dir then
      return {}
    end

    local project_name, project_config = detect_project_config(root_dir)

    return {
      -- Ruby LSP settings based on project type
      ruby_lsp = project_config.config,

      -- Bundle gem paths for navigation
      bundleGemPaths = collect_bundle_gem_paths(root_dir),
    }
  end,

  -- Initialize client with project-specific add-on settings
  before_init = function(params, config)
    local root_dir = config.root_dir
    if not root_dir then
      return
    end

    local project_name, project_config = detect_project_config(root_dir)

    -- Apply project-specific initialization options
    params.initializationOptions = vim.tbl_deep_extend('force', params.initializationOptions or {}, project_config.config)

    vim.notify(string.format('[%s] Ruby LSP initializing with project-specific optimizations', project_name:upper()), vim.log.levels.INFO)
  end,

  -- Enhanced on_init callback
  on_init = function(client, initialize_result)
    -- Enable auto-completion
    vim.lsp.completion.enable(true, client.id, 0, { autotrigger = true })

    -- Log server capabilities for debugging
    vim.defer_fn(function()
      local rails_addon_active = client.server_capabilities?.experimental?.railsIntegration or false
      vim.notify(string.format('Ruby LSP ready - Rails add-on: %s', rails_addon_active and 'Active' or 'Checking...'), vim.log.levels.INFO)
    end, 2000)
  end,

  -- Enhanced handlers for better error reporting
  handlers = {
    ['textDocument/hover'] = function(err, result, ctx, config)
      if err then
        vim.notify('LSP Hover Error: ' .. tostring(err.message), vim.log.levels.WARN)
      end
      return vim.lsp.handlers['textDocument/hover'](err, result, ctx, config)
    end,

    ['textDocument/definition'] = function(err, result, ctx, config)
      if err then
        vim.notify('LSP Definition Error: ' .. tostring(err.message), vim.log.levels.WARN)
      elseif not result or #result == 0 then
        local word = vim.fn.expand '<cword>'
        vim.notify(string.format('No definition found for "%s" - check if it\'s indexed properly', word), vim.log.levels.INFO)
      end
      return vim.lsp.handlers['textDocument/definition'](err, result, ctx, config)
    end,

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
})

-- Enable the Ruby LSP
vim.lsp.enable 'ruby_lsp'

-- Set up LspAttach autocmd for buffer-local configurations
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('ruby_lsp_attach', { clear = true }),
  pattern = '*.rb',
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if not client or client.name ~= 'ruby_lsp' then
      return
    end

    local bufnr = args.buf

    -- Enable formatting on save if supported
    if client:supports_method 'textDocument/formatting' then
      vim.api.nvim_create_autocmd('BufWritePre', {
        group = vim.api.nvim_create_augroup('ruby_lsp_format', { clear = false }),
        buffer = bufnr,
        callback = function()
          vim.lsp.buf.format { bufnr = bufnr, id = client.id, timeout_ms = 3000 }
        end,
      })
    end

    -- Set up buffer-local keymaps (optional - global defaults are usually sufficient)
    local opts = { noremap = true, silent = true, buffer = bufnr }
    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
    vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
  end,
})

return {} -- Return empty table as this is a config file
