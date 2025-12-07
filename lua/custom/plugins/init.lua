return {
  {
    'rmagatti/auto-session',
    lazy = false,

    ---enables autocomplete for opts
    ---@module "auto-session"
    ---@type AutoSession.Config
    opts = {
      suppressed_dirs = { '~/', '~/Projects', '~/Downloads', '~/Code', '/' },
      -- log_level = 'debug',

      pre_save_cmds = {
        function()
          return require('custom.plugins.auto-session.helpers').cleanup_scratch_buffers()
        end,
        -- Close all diffview tabs before saving session
        function()
          vim.cmd 'silent! DiffviewClose'
        end,
      },
    },
  },
  {
    'folke/snacks.nvim',
    priority = 1000,
    lazy = false,
    opts = {
      terminal = {
        enabled = true,
        auto_insert = false, -- Don't auto-enter insert mode when focusing terminal
        start_insert = false, -- Don't start in insert mode when opening terminal
        interactive = false, -- Disable all auto-behaviors for manual control
      },
      styles = {
        terminal = {
          keys = {
            term_normal_ctrl_n = {
              '<C-n>',
              function()
                vim.cmd 'stopinsert'
              end,
              mode = 't',
              desc = 'Ctrl+N to normal mode',
            },
          },
        },
      },
    },
  },
  {
    'catgoose/nvim-colorizer.lua',
    config = function()
      require('colorizer').setup()
    end,
  },
  {
    'ruifm/gitlinker.nvim',
    dependencies = {
      'nvim-lua/plenary.nvim',
    },
    opts = {
      mappings = '<leader>gyy',
    },
  },
  {
    'NeogitOrg/neogit',
    dependencies = {
      'nvim-lua/plenary.nvim', -- required
      'sindrets/diffview.nvim', -- optional - Diff integration
      'nvim-telescope/telescope.nvim',
    },
    config = true,
    keys = {
      { '<leader>gG', '<cmd>Neogit cwd=%:p:h<cr>', desc = 'Neogit (cwd)' },
      { '<leader>gg', '<cmd>Neogit<cr>', desc = 'Neogit (project)' },
      { '<leader>gl', '<cmd>Neogit log<cr>', desc = 'Neogit Log (project)' },
    },
  },
  {
    'fabridamicelli/cronex.nvim',
    config = function()
      require('cronex').setup {
        -- file_patterns = { '*.yaml', '*.yml', '*.tf', '*.cfg', '*.config', '*.conf', '*.crontab' },
        file_patterns = { '*.crontab' },
        extractor = {
          cron_from_line = require('cronex.cron_from_line').cron_from_line_crontab,
          extract = require('cronex.extract').extract,
        },
      }
    end,
  },
  {
    'rachartier/tiny-code-action.nvim',
    -- name = 'tiny-code-action.nvim',
    -- dir = '/Users/kyle/Code/meta-claude/tiny-code-action.nvim',
    -- dev = true,
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-telescope/telescope.nvim',
    },
    event = 'LspAttach',
    opts = {
      -- Use delta since you have it installed - much better than vim default
      backend = 'delta',

      -- Use telescope since it's your primary picker throughout config
      picker = 'telescope',

      backend_opts = {
        delta = {
          -- Keep delta headers minimal for cleaner output
          header_lines_to_remove = 4,
          args = {
            '--line-numbers',
            '--side-by-side', -- Good for code actions
            '--width',
            '120', -- Reasonable width
          },
        },
      },

      -- Your config uses Nerd Fonts, so keep the nice icons
      signs = {
        quickfix = { '󰁨', { link = 'DiagnosticWarn' } },
        others = { '󰌶', { link = 'DiagnosticHint' } },
        refactor = { '󱖣', { link = 'DiagnosticInfo' } },
        ['refactor.move'] = { '󰪹', { link = 'DiagnosticInfo' } },
        ['refactor.extract'] = { '󰄵', { link = 'DiagnosticError' } },
        ['source.organizeImports'] = { '󰒺', { link = 'DiagnosticWarn' } },
        ['source.fixAll'] = { '󰃢', { link = 'DiagnosticError' } },
        ['source'] = { '󰏖', { link = 'DiagnosticError' } },
        ['rename'] = { '󰑕', { link = 'DiagnosticWarn' } },
        ['codeAction'] = { '󰌵', { link = 'DiagnosticInfo' } },
      },
    },
  },
  { 'godlygeek/tabular' },
  {
    'github/copilot.vim',
    event = 'InsertEnter',
  },
  {
    'nvim-pack/nvim-spectre',
    dependencies = {
      'nvim-lua/plenary.nvim',
    },
    keys = {
      { '<leader>S', '<cmd>lua require("spectre").toggle()<CR>', desc = 'Toggle [S]pectre' },
      { '<leader>sw', '<cmd>lua require("spectre").open_visual({select_word=true})<CR>', desc = '[S]earch current [w]ord with Spectre' },
      { '<leader>sw', '<cmd>lua require("spectre").open_visual()<CR>', mode = 'v', desc = '[S]earch selection [w]ith Spectre' },
      { '<leader>sp', '<cmd>lua require("spectre").open_file_search({select_word=true})<CR>', desc = '[S]earch in current file with S[p]ectre' },
    },
    opts = {
      color_devicons = true,
      live_update = false, -- Performance: don't auto-update on every keystroke
      open_cmd = 'vnew', -- Open in vertical split
      find_engine = {
        -- Use ripgrep (which you already have for Telescope)
        ['rg'] = {
          cmd = 'rg',
          args = {
            '--color=never',
            '--no-heading',
            '--with-filename',
            '--line-number',
            '--column',
          },
          options = {
            ['ignore-case'] = {
              value = '--ignore-case',
              icon = '[I]',
              desc = 'ignore case',
            },
            ['hidden'] = {
              value = '--hidden',
              desc = 'hidden file',
              icon = '[H]',
            },
          },
        },
      },
      replace_engine = {
        ['sed'] = {
          cmd = 'sed',
          args = nil,
        },
      },
      default = {
        find = {
          cmd = 'rg',
          options = { 'ignore-case' },
        },
        replace = {
          cmd = 'sed',
        },
      },
    },
  },
  {
    'vhyrro/luarocks.nvim',
    priority = 1001, -- this plugin needs to run before anything else
    opts = {
      rocks = { 'magick' },
    },
  },
  {
    -- dir = '/Users/kyle/Code/image.nvim',
    -- name = 'image.nvim',
    -- build = false, -- No build needed for magick_cli
    '3rd/image.nvim',
    config = function()
      -- Skip image.nvim setup in headless mode (like when running tests)
      if #vim.api.nvim_list_uis() == 0 then
        return
      end
      require('image').setup {
        -- Using ueberzug backend - correct choice for iTerm2
        backend = 'ueberzug',
        -- processor = 'magick_cli',
        processor = 'magick_rock',

        -- Optimized for direct image viewing
        max_width_window_percentage = nil, -- Allow full width
        max_height_window_percentage = 80, -- Increased from 50% for better viewing

        -- File patterns for direct image opening
        hijack_file_patterns = { '*.png', '*.jpg', '*.jpeg', '*.gif', '*.webp', '*.avif' },

        -- Disable features not needed for direct viewing
        window_overlap_clear_enabled = false, -- Prevents clearing images when windows overlap
        editor_only_render_when_focused = false, -- Keep images visible when not focused

        -- Disable integrations since you're not using markdown/html
        integrations = {
          markdown = { enabled = false },
          neorg = { enabled = false },
          typst = { enabled = false },
          html = { enabled = false },
          css = { enabled = false },
        },
      }
    end,
  },
  {
    'ravitemer/mcphub.nvim',
    enabled = false,
    dependencies = {
      'nvim-lua/plenary.nvim',
    },
    build = 'npm install -g mcp-hub@latest', -- Installs `mcp-hub` node binary globally
    config = function()
      require('mcphub').setup()
    end,
  },
  {
    'zaldih/themery.nvim',
    lazy = false,
    config = function()
      require('themery').setup {
        themes = { 'gruvbox', 'dawnfox', 'dayfox', 'nightfox', 'cobalt' },
        livePreview = true,
      }
    end,
  },
  {
    'avifenesh/claucode.nvim',
    config = function()
      require('claucode').setup()
    end,
  },
  {
    'chrisgrieser/nvim-tinygit',
    dependencies = 'nvim-telescope/telescope.nvim', -- only for interactive staging
    config = function()
      require('tinygit').setup {
        stage = {
          -- use telescope for interactive staging
          contextSize = 2,
        },
      }
    end,
  },
  { 'RRethy/nvim-treesitter-endwise' },
  {
    'windwp/nvim-ts-autotag',
    event = { 'BufReadPre', 'BufNewFile' },
    opts = {
      opts = {
        enable_close = true, -- Auto close tags
        enable_rename = true, -- Auto rename pairs of tags
        enable_close_on_slash = false, -- Auto close on trailing </
      },
      aliases = {
        ['eruby'] = 'html', -- Support for .html.erb files
      },
    },
  },
}
