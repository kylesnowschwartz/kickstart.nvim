local function collect_bundle_gem_paths(root_dir)
  vim.notify('Collecting bundle gem paths for: ' .. root_dir, vim.log.levels.INFO)
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

return {
  cmd = { 'ruby-lsp' }, -- Do not use bundle exec to allow for Mason or Bundled installations interchangebly
  filetypes = { 'ruby' },
  root_markers = { 'Gemfile', '.git' },

  -- Update bundleGemPaths based on the detected root directory
  on_init = function(client, _)
    local root = client.config.root_dir
    if root then
      client.config.settings = client.config.settings or {}
      client.config.settings.bundleGemPaths = collect_bundle_gem_paths(root)
    end
    return true
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
    -- This will be dynamically updated in on_init with the correct paths for the project root
    bundleGemPaths = {},
  },
}
