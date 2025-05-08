return {
  cmd = { 'typescript-language-server', '--stdio' },
  filetypes = { 'typescript', 'javascript', 'javascriptreact', 'typescriptreact', 'vue' },
  root_markers = { 'tsconfig.json', 'package.json', 'jsconfig.json', '.git' },
  -- TypeScript specific settings can be added here
  init_options = {
    hostInfo = 'neovim',
    preferences = {
      includeCompletionsForModuleExports = true,
      includeCompletionsWithSnippetText = true,
    },
  },
}

