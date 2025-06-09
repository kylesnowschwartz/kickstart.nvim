return {
  cmd = { 'bash-language-server', 'start' },
  filetypes = { 'bash', 'sh', 'zsh' },
  root_markers = { '.git', vim.uv.cwd() },
  settings = {
    bashIde = {
      globPattern = vim.env.GLOB_PATTERN or '*@(.sh|.inc|.bash|.command)',
      -- Modern formatting options (requires shfmt)
      tabSize = 2,
      insertSpaces = true,
      -- Enable comprehensive features like Ruby LSP
      enableSourceErrorDiagnostics = true,
      enableCodeLens = true,
      includeAllWorkspaceSymbols = true,
      -- Background analysis for better performance
      backgroundAnalysisMaxFiles = 500,
      -- ShellCheck integration for linting
      shellcheckPath = 'shellcheck',
      shellcheckArguments = {
        '--shell=bash',
        '--format=json',
      },
    },
  },
  -- Auto-format on save like Ruby
  on_attach = function(client, bufnr)
    if client.server_capabilities.documentFormattingProvider then
      vim.api.nvim_create_autocmd('BufWritePre', {
        group = vim.api.nvim_create_augroup('BashLspFormatting', {}),
        buffer = bufnr,
        callback = function()
          vim.lsp.buf.format { bufnr = bufnr }
        end,
      })
    end
  end,
}
