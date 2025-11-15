--[[
Ruby LSP Configuration with Hybrid Command Selection
=====================================================

PROBLEM CONTEXT
----------------
Ruby projects use two incompatible methods for specifying Ruby versions:

1. `.ruby-version` file - Read by rbenv/chruby/asdf for automatic version switching
2. `ruby "x.y.z"` in Gemfile - Enforced by bundler when running commands

Many projects use ONLY the Gemfile approach and lack `.ruby-version` files.

THE COMPOSED BUNDLE STRATEGY
-----------------------------
Ruby LSP uses a "composed bundle" to avoid requiring ruby-lsp in project Gemfiles:

1. You run `ruby-lsp` (not `bundle exec ruby-lsp`)
2. Ruby LSP detects your project's Gemfile
3. Creates `.ruby-lsp/Gemfile` containing ruby-lsp + all project dependencies
4. Replaces itself with `BUNDLE_GEMFILE=.ruby-lsp/Gemfile bundle exec ruby-lsp`
5. Gains access to all project gems without polluting the project Gemfile

Source: https://shopify.github.io/ruby-lsp/composed-bundle.html
Official nvim-lspconfig: https://github.com/neovim/nvim-lspconfig (uses `cmd = { 'ruby-lsp' }`)

THE VERSION RESOLUTION PROBLEM
-------------------------------
When using rbenv with the composed bundle strategy:

- rbenv shims resolve Ruby version based on the CURRENT WORKING DIRECTORY
- Resolution priority: RBENV_VERSION env → .ruby-version file → global → system
- Source: https://github.com/rbenv/rbenv#how-it-works

PROBLEM: If a project lacks `.ruby-version`, rbenv falls back to global Ruby,
which may not match the Gemfile's `ruby "x.y.z"` specification.

THE HYBRID SOLUTION
-------------------
This configuration implements a hybrid approach:

1. Check if ruby-lsp is installed in the project's bundle
2. If YES: Use `bundle exec ruby-lsp`
   - Bundler enforces the Gemfile's Ruby version
   - Uses the bundled ruby-lsp (project has it as a dependency)

3. If NO: Use rbenv shim `~/.rbenv/shims/ruby-lsp`
   - rbenv resolves Ruby version from .ruby-version (if present)
   - Falls back to global Ruby (if no .ruby-version)
   - Ruby LSP's composed bundle strategy activates

This bridges the gap between ruby-lsp's design and real-world project structures.

REFERENCES
----------
- Ruby LSP Composed Bundle: https://shopify.github.io/ruby-lsp/composed-bundle.html
- Ruby LSP Editors Guide: https://shopify.github.io/ruby-lsp/editors.html
- rbenv How It Works: https://github.com/rbenv/rbenv#how-it-works
- nvim-lspconfig ruby_lsp: https://github.com/neovim/nvim-lspconfig/blob/master/lua/lspconfig/configs/ruby_lsp.lua
- Community discussions: Multiple GitHub issues and Stack Overflow posts (2024-2025)

NOTES
-----
- Mason-installed ruby-lsp can cause C extension ABI mismatches across Ruby versions
- Recommended: Install ruby-lsp per Ruby version via `gem install ruby-lsp`
- Projects should ideally include both .ruby-version AND Gemfile ruby specification
--]]

--- Check if ruby-lsp gem is installed in the project's bundle
--- @param root_dir string The project root directory
--- @return boolean true if ruby-lsp is in the bundle, false otherwise
local function is_ruby_lsp_in_bundle(root_dir)
  -- No Gemfile means no bundle
  if vim.fn.filereadable(root_dir .. '/Gemfile') ~= 1 then
    return false
  end

  -- Check if bundle show ruby-lsp succeeds (exit code 0)
  local check_cmd = string.format('cd %s && bundle show ruby-lsp >/dev/null 2>&1', vim.fn.shellescape(root_dir))
  local exit_code = vim.fn.system(check_cmd)
  return vim.v.shell_error == 0
end

--- Collect bundle gem paths for the project
--- Used by ruby-lsp to understand project dependencies
--- @param root_dir string The project root directory
--- @return table List of gem paths from bundle
local function collect_bundle_gem_paths(root_dir)
  vim.notify('Collecting bundle gem paths for: ' .. root_dir, vim.log.levels.INFO)
  local gem_paths = {}

  if vim.fn.filereadable(root_dir .. '/Gemfile') == 1 then
    local gem_paths_cmd = 'cd ' .. vim.fn.shellescape(root_dir) .. ' && bundle show --paths 2>/dev/null'
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
  -- Default cmd - will be overridden by on_new_config based on project
  cmd = { vim.fn.expand '~/.rbenv/shims/ruby-lsp' },
  filetypes = { 'ruby' },
  root_markers = { 'Gemfile', '.git' },

  -- Dynamically set the correct command before client starts
  on_new_config = function(config, root_dir)
    if is_ruby_lsp_in_bundle(root_dir) then
      -- ruby-lsp is in the bundle: use bundle exec to ensure correct Ruby version
      config.cmd = { 'bundle', 'exec', 'ruby-lsp' }
      vim.notify('Ruby LSP: Using bundled ruby-lsp via bundle exec', vim.log.levels.INFO)
    else
      -- ruby-lsp not in bundle: use rbenv shim + composed bundle strategy
      config.cmd = { vim.fn.expand '~/.rbenv/shims/ruby-lsp' }
      vim.notify('Ruby LSP: Using rbenv shim with composed bundle', vim.log.levels.INFO)
    end
  end,

  -- Update bundleGemPaths after client initializes
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
