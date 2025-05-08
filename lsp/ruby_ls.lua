-- Ruby LSP configuration
vim.notify("Loading Ruby LSP configuration from lsp/ruby_ls.lua", vim.log.levels.INFO)

-- Pre-compute bundle gem paths outside the LSP config
local bundle_gem_paths = {}
local bundle_gemfile = vim.fn.getcwd() .. '/Gemfile'
if vim.fn.filereadable(bundle_gemfile) == 1 then
  local status, gem_paths_output = pcall(function()
    local handle = io.popen('cd ' .. vim.fn.getcwd() .. ' && bundle show --paths 2>/dev/null')
    if handle then
      local output = handle:read '*a'
      handle:close()
      return output
    end
    return ''
  end)

  if status and gem_paths_output ~= '' then
    for path in string.gmatch(gem_paths_output, '[^\r\n]+') do
      if vim.fn.isdirectory(path) == 1 then
        table.insert(bundle_gem_paths, path)
      end
    end

    if #bundle_gem_paths > 0 then
      vim.notify('Ruby LSP: Added ' .. #bundle_gem_paths .. ' bundled gems to LSP configuration', vim.log.levels.INFO)
    end
  end
end

-- Return the configuration table for ruby_ls
return {
  cmd = { 'bundle', 'exec', 'ruby-lsp' },
  filetypes = { 'ruby' },
  root_markers = { 'Gemfile', '.git' },
  -- Handler for determining if we should start the server
  on_new_config = function(new_config, new_root_dir)
    -- Don't start if no Gemfile exists and ruby-lsp is not available
    if vim.fn.filereadable(new_root_dir .. '/Gemfile') ~= 1 and vim.fn.executable('ruby-lsp') ~= 1 then
      return false
    end
    return true
  end,
  settings = {
    rubocop = {
      useBundler = true,
      configPath = '.rubocop.yml',
    },
    formatter = {
      useBundler = true,
      name = 'rubocop',
    },
    experimentalFeaturesEnabled = true,
    enabledFeatures = {
      'documentHighlights',
      'documentSymbols',
      'foldingRanges',
      'selectionRanges',
      'semanticHighlighting',
      'formatting',
      'codeActions',
      'hover',
      'inlayHint',
      'onTypeFormatting',
      'diagnostics',
      'completion',
      'codeLens',
    },
    bundleGemPaths = bundle_gem_paths,
  },
}