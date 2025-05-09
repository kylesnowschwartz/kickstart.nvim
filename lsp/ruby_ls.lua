-- Return the configuration table for ruby_ls
-- Cache to store detected LSP configurations by root directory
local lsp_config_cache = {}

local function collect_bundle_gem_paths(root_dir)
  local gem_paths = {}
  if vim.fn.filereadable(root_dir .. '/Gemfile') == 1 then
    local gem_paths_cmd = 'cd ' .. root_dir .. ' && bundle show --paths 2>/dev/null'
    local gem_paths_output = vim.fn.system(gem_paths_cmd)

    if gem_paths_output and gem_paths_output ~= '' then
      for path in string.gmatch(gem_paths_output, '[^\r\n]+') do
        if vim.fn.isdirectory(path) == 1 then
          table.insert(gem_paths, path)
        end
      end
    end
  end
  return gem_paths
end

-- Initialize with current working directory (will be updated when on_new_config runs)
local cwd = vim.fn.getcwd()
local initial_gem_paths = collect_bundle_gem_paths(cwd)

return {
  cmd = { 'ruby-lsp' }, -- Default command, will be overridden in on_new_config if needed
  filetypes = { 'ruby' },
  root_markers = { 'Gemfile', '.git' },

  -- Handler for determining if we should start the server
  on_new_config = function(new_config, new_root_dir)
    -- Check cache first to avoid repeated detection
    if lsp_config_cache[new_root_dir] then
      local cached = lsp_config_cache[new_root_dir]
      new_config.cmd = cached.cmd
      new_config.settings = cached.settings
      return true
    end

    -- Initialize settings safely
    new_config.settings = new_config.settings or {}
    new_config.settings.rubocop = new_config.settings.rubocop or {}
    new_config.settings.formatter = new_config.settings.formatter or {}

    -- Fast path: Check for bundled ruby-lsp
    if vim.fn.filereadable(new_root_dir .. '/Gemfile') == 1 then
      -- Use vim.fn.system instead of io.popen for better performance
      local bundle_check_cmd = 'cd ' .. new_root_dir .. ' && bundle show ruby-lsp 2>/dev/null'
      local output = vim.fn.system(bundle_check_cmd)

      if output and output ~= '' then
        -- Using bundled ruby-lsp
        new_config.cmd = { 'bundle', 'exec', 'ruby-lsp' }
        new_config.settings.rubocop.useBundler = true
        new_config.settings.formatter.useBundler = true

        -- Cache this configuration
        lsp_config_cache[new_root_dir] = {
          cmd = new_config.cmd,
          settings = vim.deepcopy(new_config.settings),
        }

        -- Get gem paths for this specific root directory
        local bundle_gem_paths = collect_bundle_gem_paths(new_root_dir)

        -- Add the gem paths to settings
        if #bundle_gem_paths > 0 then
          new_config.settings.bundleGemPaths = bundle_gem_paths

          -- Update cache with gem paths
          if lsp_config_cache[new_root_dir] then
            lsp_config_cache[new_root_dir].settings.bundleGemPaths = bundle_gem_paths
          end
        end

        return true
      end
    end

    -- Check for installations in order of preference
    local mason_ruby_lsp = vim.fn.expand '~/.local/share/nvim/mason/bin/ruby-lsp'

    if vim.fn.executable(mason_ruby_lsp) == 1 then
      -- Use Mason installation
      new_config.cmd = { mason_ruby_lsp }
      new_config.settings.rubocop.useBundler = false
      new_config.settings.formatter.useBundler = false

      -- Cache this configuration
      lsp_config_cache[new_root_dir] = {
        cmd = new_config.cmd,
        settings = vim.deepcopy(new_config.settings),
      }

      return true
    elseif vim.fn.executable 'ruby-lsp' == 1 then
      -- Use system installation
      new_config.cmd = { 'ruby-lsp' }
      new_config.settings.rubocop.useBundler = false
      new_config.settings.formatter.useBundler = false

      -- Cache this configuration
      lsp_config_cache[new_root_dir] = {
        cmd = new_config.cmd,
        settings = vim.deepcopy(new_config.settings),
      }

      return true
    end

    -- No ruby-lsp found
    vim.notify('Ruby LSP: No ruby-lsp installation found', vim.log.levels.ERROR)
    return false
  end,

  settings = {
    rubocop = {
      configPath = '.rubocop.yml',
    },
    formatter = {
      name = 'rubocop',
    },
    experimentalFeaturesEnabled = true,
    -- Core features loaded immediately, non-essential features can be lazy-loaded
    enabledFeatures = {
      'diagnostics',
      'completion',
      'hover',
      'documentHighlights',
      'documentSymbols',
      'semanticHighlighting',
      'formatting',
      'codeActions',
      'inlayHint',
      'onTypeFormatting',
      'foldingRanges',
      'selectionRanges',
      'codeLens',
    },
    -- Include initial gem paths from the current working directory
    bundleGemPaths = initial_gem_paths,
  },
}
