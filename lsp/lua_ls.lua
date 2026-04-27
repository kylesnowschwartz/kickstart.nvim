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
        -- `vim` is the Neovim API global; lazydev only attaches to files
        -- under our config root, so declare it here for any lua file lua_ls
        -- happens to traverse (third-party plugin sources in ~/Code, etc.).
        globals = { 'vim' },
        -- Plugin source files frequently reference undeclared LuaCATS types
        -- and incomplete @class definitions; suppress the noise so our own
        -- diagnostics stay legible.
        disable = { 'missing-fields', 'undefined-doc-name', 'undefined-doc-param' },
      },
    },
  },
}
