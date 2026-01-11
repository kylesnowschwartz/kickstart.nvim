return {
  cmd = { 'astro-ls', '--stdio' },
  filetypes = { 'astro' },
  root_markers = { 'astro.config.mjs', 'astro.config.mts', 'astro.config.js', 'astro.config.ts', 'package.json', '.git' },
  init_options = {
    typescript = {
      tsdk = '/Users/kyle/.npm-global/lib/node_modules/typescript/lib',
    },
  },
}
