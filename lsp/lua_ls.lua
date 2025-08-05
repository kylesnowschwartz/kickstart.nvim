return {
  cmd = vim.fn.exepath 'lua-language-server' and { vim.fn.exepath 'lua-language-server' } or { vim.fn.stdpath 'data' .. '/mason/bin/lua-language-server' },
  filetypes = { 'lua' },
  root_markers = { '.luarc.json', '.luarc.jsonc', 'init.lua', '.git' },
  settings = {
    Lua = {
      runtime = {
        version = 'LuaJIT',
      },
      completion = {
        callSnippet = 'Replace',
      },
      diagnostics = {
        disable = { 'missing-fields' },
      },
    },
  },
}
