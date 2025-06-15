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
    opts = {},
    config = function()
      require('mason').setup()

      -- Auto-install formatters and tools
      local ensure_installed = {
        'stylua', -- Lua
        'prettier', -- JS/TS/CSS/HTML/JSON/YAML/Markdown
        'eslint_d', -- JS/TS linting
        'black', -- Python
        'isort', -- Python import sorting
        'shfmt', -- Shell scripts
      }

      local registry = require 'mason-registry'
      registry.refresh(function()
        for _, tool in ipairs(ensure_installed) do
          local p = registry.get_package(tool)
          if not p:is_installed() then
            p:install()
          end
        end
      end)
    end,
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
              -- Disable autosnippets first
              require('luasnip').config.set_config {
                enable_autosnippets = false,
                store_selection_keys = nil,
              }
              -- Then load snippets for completion dropdown only
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

      -- Enable Vim's native LSP completion for all attached LSP clients
      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('lsp-completion', { clear = true }),
        callback = function(args)
          local client = vim.lsp.get_client_by_id(args.data.client_id)
          if client and client:supports_method 'textDocument/completion' then
            vim.lsp.completion.enable(true, client.id, args.buf, {
              autotrigger = false, -- Changed to false to require manual triggering
            })
          end
        end,
      })

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

      vim.notify('Loading LSP configuration', vim.log.levels.INFO)
      -- Set global configuration for all language servers
      vim.lsp.config('*', {
        -- Default root marker for all LSP servers
        root_markers = { '.git' },
        -- Common capabilities for all servers
        capabilities = {
          textDocument = {
            completion = {
              completionItem = {
                snippetSupport = true,
                commitCharactersSupport = true,
                deprecatedSupport = true,
                tagSupport = {
                  valueSet = { 1 }, -- Deprecated
                },
                preselectSupport = true,
                resolveSupport = {
                  properties = {
                    'documentation',
                    'detail',
                    'additionalTextEdits',
                  },
                },
              },
            },
          },
        },
      })

      -- Enable LSP configurations - these will use the runtime path loaded configurations
      vim.lsp.enable 'lua_ls'
      vim.lsp.enable 'ts_ls'
      vim.lsp.enable 'ruby_ls'
      vim.lsp.enable 'bash_ls'
      vim.lsp.enable 'html_ls'
      -- TODO: vim.lsp.enable({ "ts_ls", "cssls", "tailwindcssls" })
      -- https://github.com/Rishabh672003/Neovim/blob/main/lua/rj/lsp.lua
    end,
  },

  { -- Autoformat (kept from original config)
    'stevearc/conform.nvim',
    event = { 'BufWritePre' },
    cmd = { 'ConformInfo' },
    keys = {
      {
        '<leader>FF',
        function()
          require('conform').format { async = true, lsp_format = 'fallback' }
        end,
        mode = '',
        desc = '[F]ormat [F]ile',
      },
    },
    opts = {
      notify_on_error = false,
      -- log_level = vim.log.levels.DEBUG, -- Uncomment for debugging
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
        python = { 'isort', 'black' },
        javascript = { { 'eslint_d', 'prettier' } },
        javascriptreact = { { 'eslint_d', 'prettier' } },
        typescript = { { 'eslint_d', 'prettier' } },
        typescriptreact = { { 'eslint_d', 'prettier' } },
        ruby = { 'rubocop' },
        yaml = { 'prettier' },
        json = { 'prettier' },
        markdown = { 'prettier_markdown' },
        css = { 'prettier' },
        scss = { 'prettier' },
        html = { 'prettier' },
        sh = { 'shfmt' },
        bash = { 'shfmt' },
        zsh = { 'shfmt' },
      },
      formatters = {
        rubocop = {
          command = 'bundle',
          prepend_args = { 'exec', 'rubocop' },
          args = { '-A', '--stderr', '--stdin', '$FILENAME', '--format', 'quiet' },
          exit_codes = { 0, 1 },
          timeout_ms = 10000,
        },
        prettier_markdown = function()
          local prettier_base = require 'conform.formatters.prettier'
          local tw = vim.api.nvim_get_option_value('textwidth', { buf = 0 })

          if tw > 0 then
            return vim.tbl_deep_extend('force', prettier_base, {
              args = { '--stdin-filepath', '$FILENAME', '--prose-wrap', 'always', '--print-width', tostring(tw) },
            })
          else
            return prettier_base
          end
        end,
      },
    },
  },
}
