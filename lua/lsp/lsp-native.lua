-- Native LSP configuration for Neovim 0.11+
return {
  {
    -- `lazydev` configures Lua LSP for your Neovim config, runtime and plugins
    'folke/lazydev.nvim',
    ft = 'lua',
    opts = {
      library = {
        -- Load luvit types when the `vim.uv` word is found
        { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
      },
    },
  },
  {
    -- Mason for installing language servers
    'mason-org/mason.nvim',
    version = '1.11.0',
    opts = {},
  },
  {
    -- Useful status updates for LSP
    'j-hui/fidget.nvim',
    opts = {},
  },

  -- Setup native LSP functionality
  {
    'saghen/blink.cmp',
    event = 'VimEnter',
    version = '1.*',
    dependencies = {
      -- Snippet Engine
      {
        'L3MON4D3/LuaSnip',
        version = '2.*',
        build = (function()
          -- Build Step is needed for regex support in snippets.
          -- This step is not supported in many windows environments.
          -- Remove the below condition to re-enable on windows.
          if vim.fn.has 'win32' == 1 or vim.fn.executable 'make' == 0 then
            return
          end
          return 'make install_jsregexp'
        end)(),
        dependencies = {
          {
            'rafamadriz/friendly-snippets',
            config = function()
              require('luasnip.loaders.from_vscode').lazy_load()
            end,
          },
        },
        opts = {},
      },
      'folke/lazydev.nvim',
    },
    --- @type blink.cmp.Config
    opts = {
      keymap = { preset = 'super-tab' },
      appearance = {
        nerd_font_variant = 'mono',
      },
      sources = {
        default = { 'lsp', 'path', 'snippets', 'lazydev', 'buffer', 'cmdline' },
        providers = {
          lazydev = { module = 'lazydev.integrations.blink', score_offset = 100 },
        },
      },
      snippets = { preset = 'luasnip' },
      fuzzy = { implementation = 'prefer_rust_with_warning' },
      signature = { enabled = true },
      completion = {
        documentation = {
          auto_show = true,
          auto_show_delay_ms = 200,
        },
      },
    },
    opts_extend = { 'sources.default' },
    config = function(_, opts)
      -- Initialize blink.cmp
      require('blink.cmp').setup(opts)

      -- Enable Vim's native LSP completion
      vim.lsp.completion.enable()

      -- Configure diagnostic display
      vim.diagnostic.config {
        severity_sort = true,
        float = { border = 'rounded', source = 'if_many' },
        underline = { severity = vim.diagnostic.severity.ERROR },
        signs = vim.g.have_nerd_font and {
          text = {
            [vim.diagnostic.severity.ERROR] = '󰅚 ',
            [vim.diagnostic.severity.WARN] = '󰀪 ',
            [vim.diagnostic.severity.INFO] = '󰋽 ',
            [vim.diagnostic.severity.HINT] = '󰌶 ',
          },
        } or {},
        virtual_text = {
          source = 'if_many',
          spacing = 2,
          format = function(diagnostic)
            local diagnostic_message = {
              [vim.diagnostic.severity.ERROR] = diagnostic.message,
              [vim.diagnostic.severity.WARN] = diagnostic.message,
              [vim.diagnostic.severity.INFO] = diagnostic.message,
              [vim.diagnostic.severity.HINT] = diagnostic.message,
            }
            return diagnostic_message[diagnostic.severity]
          end,
        },
      }

      -- LSP servers setup
      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('native-lsp-attach', { clear = true }),
        callback = function(event)
          local map = function(keys, func, desc, mode)
            mode = mode or 'n'
            vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
          end

          -- Load telescope LSP keymaps if available
          local telescope_keymaps_ok, telescope_keymaps = pcall(require, 'custom.plugins.telescope.lsp_keymaps')
          if telescope_keymaps_ok then
            telescope_keymaps.setup_lsp_keymaps(event.buf)
          end

          -- Common LSP keymaps
          map('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
          map('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction', { 'n', 'x' })
          map('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')

          -- Document highlighting
          local client = vim.lsp.get_client_by_id(event.data.client_id)
          if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight) then
            local highlight_group = vim.api.nvim_create_augroup('native-lsp-highlight', { clear = false })
            vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
              buffer = event.buf,
              group = highlight_group,
              callback = vim.lsp.buf.document_highlight,
            })

            vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
              buffer = event.buf,
              group = highlight_group,
              callback = vim.lsp.buf.clear_references,
            })

            vim.api.nvim_create_autocmd('LspDetach', {
              group = vim.api.nvim_create_augroup('native-lsp-detach', { clear = true }),
              callback = function(event2)
                vim.lsp.buf.clear_references()
                vim.api.nvim_clear_autocmds { group = 'native-lsp-highlight', buffer = event2.buf }
              end,
            })
          end

          -- Inlay hints toggle
          if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then
            map('<leader>th', function()
              vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf })
            end, '[T]oggle Inlay [H]ints')
          end
        end,
      })

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

      -- Configure LSP servers using the new vim.lsp.config API
      
      -- Lua LSP Configuration
      vim.lsp.config['lua_ls'] = {
        cmd = vim.fn.exepath 'lua-language-server' and { vim.fn.exepath 'lua-language-server' }
          or { vim.fn.stdpath 'data' .. '/mason/bin/lua-language-server' },
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

      -- TypeScript LSP Configuration
      vim.lsp.config['tsserver'] = {
        cmd = { 'typescript-language-server', '--stdio' },
        filetypes = { 'typescript', 'javascript', 'javascriptreact', 'typescriptreact', 'vue', 'json' },
        root_markers = { 'tsconfig.json', 'package.json', 'jsconfig.json', '.git' },
      }

      -- Ruby LSP Configuration
      vim.lsp.config['ruby_ls'] = {
        cmd = { 'bundle', 'exec', 'ruby-lsp' },
        filetypes = { 'ruby' },
        root_markers = { 'Gemfile', '.git' },
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

      -- Enable LSP configurations
      vim.lsp.enable('lua_ls')
      vim.lsp.enable('tsserver')
      vim.lsp.enable('ruby_ls')
    end,
  },

  { -- Autoformat (kept from original config)
    'stevearc/conform.nvim',
    event = { 'BufWritePre' },
    cmd = { 'ConformInfo' },
    keys = {
      {
        '<leader>F',
        function()
          require('conform').format { async = true, lsp_format = 'fallback' }
        end,
        mode = '',
        desc = '[F]ormat buffer',
      },
    },
    opts = {
      notify_on_error = false,
      format_on_save = function(bufnr)
        local disable_filetypes = { c = true, cpp = true }
        if disable_filetypes[vim.bo[bufnr].filetype] then
          return nil
        else
          return {
            timeout_ms = 5000,
            lsp_format = 'fallback',
          }
        end
      end,
      formatters_by_ft = {
        lua = { 'stylua' },
        javascript = { 'eslint_d' },
        javascriptreact = { 'eslint_d' },
        typescript = { 'eslint_d' },
        typescriptreact = { 'eslint_d' },
        ruby = { 'rubocop' },
        yaml = { 'prettier' },
        json = { 'prettier' },
      },
      formatters = {
        rubocop = {
          command = 'bundle',
          prepend_args = { 'exec', 'rubocop' },
          args = { '-A', '--stderr', '--stdin', '$FILENAME', '--format', 'quiet' },
          exit_codes = { 0, 1 },
          timeout_ms = 10000,
        },
      },
    },
  },
}