return {
  cmd = { 'astro-ls', '--stdio' },
  filetypes = { 'astro' },
  root_markers = { 'astro.config.mjs', 'astro.config.mts', 'astro.config.js', 'astro.config.ts', 'package.json', '.git' },
  init_options = {
    typescript = {
      -- This will be resolved automatically if tsdk is in node_modules
      -- tsdk = '', -- Path to TypeScript SDK (auto-detected from node_modules)
    },
  },
}
