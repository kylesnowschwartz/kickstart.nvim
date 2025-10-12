--  NOTE: Must happen before plugins are loaded (otherwise wrong leader will be used)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Set to true if you have a Nerd Font installed and selected in the terminal
vim.g.have_nerd_font = true

-- [[ Setting options ]]
-- See `:help vim.opt`
-- NOTE: You can change these options as you wish!
--  For more options, you can see `:help option-list`

-- Make line numbers default
vim.opt.number = true
-- You can also add relative line numbers, to help with jumping.
--  Experiment for yourself to see if you like it!
vim.opt.relativenumber = false
-- relative numbers only in Normal mode and absolute numbers while typing
local autocmd = vim.api.nvim_create_autocmd -- define the helper *first*
-- local number_toggle = vim.api.nvim_create_augroup('number_toggle', { clear = true })
-- autocmd('InsertEnter', {
--   group = number_toggle,
--   callback = function()
--     vim.opt.relativenumber = false
--   end,
-- })
--
-- autocmd('InsertLeave', {
--   group = number_toggle,
--   callback = function()
--     vim.opt.relativenumber = true
--   end,
-- })

-- Enable mouse mode, can be useful for resizing splits for example!
vim.opt.mouse = 'a'

-- Don't show the mode, since it's already in the status line
vim.opt.showmode = false

vim.schedule(function()
  vim.opt.clipboard = 'unnamedplus'
end)

-- Enable break indent
vim.opt.breakindent = true

-- Save undo history
vim.opt.undofile = true

-- Auto-reload files when changed externally
vim.opt.autoread = true

-- Auto-refresh files when they change externally
local autorefresh_group = vim.api.nvim_create_augroup('autorefresh', { clear = true })

-- Check for external file changes on various events
autocmd({ 'FocusGained', 'BufEnter', 'CursorHold', 'CursorHoldI' }, {
  group = autorefresh_group,
  callback = function()
    if vim.fn.mode() ~= 'c' then
      vim.cmd 'checktime'
    end
  end,
})

-- Auto-reload when file changes externally (without prompting)
autocmd('FileChangedShell', {
  group = autorefresh_group,
  callback = function()
    vim.v.fcs_choice = 'reload'
  end,
})

-- provides an experimental commandline and message UI intended to replace the message grid in the TUI
require('vim._extui').enable {
  enable = true, -- Whether to enable or disable the UI.
  msg = { -- Options related to the message module.
    ---@type 'cmd'|'msg' Where to place regular messages, either in the
    ---cmdline or in a separate ephemeral message window.
    target = 'msg',
    timeout = 4000, -- Time a message is visible in the message window.
  },
}

-- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Keep signcolumn on by default
vim.opt.signcolumn = 'yes'

-- Decrease update time
vim.opt.updatetime = 250

-- Decrease mapped sequence wait time
vim.opt.timeoutlen = 300

-- Configure how new splits should be opened
vim.opt.splitright = true
vim.opt.splitbelow = true

-- Sets how neovim will display certain whitespace characters in the editor.
--  See `:help 'list'`
--  and `:help 'listchars'`
vim.opt.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

-- Preview substitutions live, as you type!
vim.opt.inccommand = 'split'

-- Show which line your cursor is on
vim.opt.cursorline = true

-- Minimal number of screen lines to keep above and below the cursor.
vim.opt.scrolloff = 10

-- if performing an operation that would fail due to unsaved changes in the buffer (like `:q`),
-- instead raise a dialog asking if you wish to save the current file(s)
-- See `:help 'confirm'`
vim.opt.confirm = true

-- Folding configuration
vim.opt.foldmethod = 'indent'
vim.opt.foldlevel = 99
vim.opt.foldenable = true

-- Open special buffers in splits
vim.opt.switchbuf = 'vsplit'

-- [[ Basic Keymaps ]]
--  See `:help vim.keymap.set()`

-- Clear highlights on search when pressing <Esc> in normal mode
--  See `:help hlsearch`
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- Diagnostic keymaps
-- vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })
-- Move diagnostic location list under the <leader>e group
vim.keymap.set('n', '<leader>el', vim.diagnostic.setloclist, { desc = 'Open diagnostic [L]ocation list' })

-- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
-- for people to discover. Otherwise, you normally need to press <C-\><C-n>, which
-- is not what someone will guess without a bit more experience.
--
-- NOTE: This won't work in all terminal emulators/tmux/etc. Try your own mapping
-- or just use <C-\><C-n> to exit terminal mode
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

--  Uncomment the following line and add your keymaps to `lua/custom/keymaps/*.lua` to get going.
require 'custom.keymaps'

-- [[ Basic Autocommands ]]
--  See `:help lua-guide-autocommands`

-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.highlight.on_yank()`
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.hl.on_yank()
  end,
})

-- Reset terminal when leaving Neovim
vim.api.nvim_create_autocmd('VimLeave', {
  desc = 'Reset terminal when leaving Neovim',
  group = vim.api.nvim_create_augroup('reset-terminal', { clear = true }),
  callback = function()
    vim.cmd 'silent !reset'
  end,
})

-- Set Python indentation to 2 spaces
vim.api.nvim_create_autocmd('FileType', {
  desc = 'Set Python indentation to 2 spaces',
  pattern = 'python',
  group = vim.api.nvim_create_augroup('python-indent', { clear = true }),
  callback = function()
    vim.opt_local.tabstop = 2
    vim.opt_local.shiftwidth = 2
    vim.opt_local.softtabstop = 2
    vim.opt_local.expandtab = true
  end,
})

-- [[ Install `lazy.nvim` plugin manager ]]
--    See `:help lazy.nvim.txt` or https://github.com/folke/lazy.nvim for more info
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
  local out = vim.fn.system { 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath }
  if vim.v.shell_error ~= 0 then
    error('Error cloning lazy.nvim:\n' .. out)
  end
end ---@diagnostic disable-next-line: undefined-field
vim.opt.rtp:prepend(lazypath)

-- NOTE: Here is where you install your plugins.
require('lazy').setup({
  'NMAC427/guess-indent.nvim', -- Detect tabstop and shiftwidth automatically

  { -- Adds git related signs to the gutter, as well as utilities for managing changes
    'lewis6991/gitsigns.nvim',
    opts = {
      signs = {
        add = { text = '+' },
        change = { text = '~' },
        delete = { text = '_' },
        topdelete = { text = '‾' },
        changedelete = { text = '~' },
      },
      current_line_blame = true,
    },
  },

  { -- Useful plugin to show you pending keybinds.
    'folke/which-key.nvim',
    event = 'VimEnter', -- Sets the loading event to 'VimEnter'
    opts = {
      -- delay between pressing a key and opening which-key (milliseconds)
      -- this setting is independent of vim.opt.timeoutlen
      delay = 0,
      icons = {
        -- set icon mappings to true if you have a Nerd Font
        mappings = vim.g.have_nerd_font,
        -- If you are using a Nerd Font: set icons.keys to an empty table which will use the
        -- default which-key.nvim defined Nerd Font icons, otherwise define a string table
        keys = vim.g.have_nerd_font and {} or {
          Up = '<Up> ',
          Down = '<Down> ',
          Left = '<Left> ',
          Right = '<Right> ',
          C = '<C-…> ',
          M = '<M-…> ',
          D = '<D-…> ',
          S = '<S-…> ',
          CR = '<CR> ',
          Esc = '<Esc> ',
          ScrollWheelDown = '<ScrollWheelDown> ',
          ScrollWheelUp = '<ScrollWheelUp> ',
          NL = '<NL> ',
          BS = '<BS> ',
          Space = '<Space> ',
          Tab = '<Tab> ',
          F1 = '<F1>',
          F2 = '<F2>',
          F3 = '<F3>',
          F4 = '<F4>',
          F5 = '<F5>',
          F6 = '<F6>',
          F7 = '<F7>',
          F8 = '<F8>',
          F9 = '<F9>',
          F10 = '<F10>',
          F11 = '<F11>',
          F12 = '<F12>',
        },
      },

      -- Document existing key chains
      spec = {
        { '<leader>b', group = '[b]uffer' },
        { '<leader>c', group = '[C]ode', mode = { 'n', 'x' } },
        { '<leader>d', group = '[D]ocument' },
        { '<leader>gy', group = 'Git [Y]ank URL', mode = { 'n', 'v' } },
        { '<leader>h', group = 'Git [H]unk', mode = { 'n', 'v' } },
        { '<leader>p', group = '[P]roject' },
        { '<leader>r', group = '[R]ename/[R]uby' },
        { '<leader>rt', group = '[R]uby [T]esting' },
        { '<leader>s', group = '[S]earch' },
        { '<leader>T', group = '[T]oggle' },
        { '<leader>t', group = '[T]erminal' },
        { '<leader>W', group = '[W]orkspace' },
        { '<leader>w', group = '[W]indow' },
        { '<leader>x', group = 'Trouble/Diagnostics' },
        { '<leader>z', group = '[Z]folding' },
        { '<leader>f', group = '[F]ile' },
        { '<leader>fe', group = '[E]dit' },
        { '<leader>F', group = '[F]ormat' },
        { '<leader>q', group = '[Q]uit' },
        { '<leader>e', group = '[E]rror/Location' },
        { '<leader>y', group = '[Y]azi' },
        { '<leader>yZ', group = '[Y]azi Resume' },

        -- 🔧 New non-leader mappings:
        { 'c', group = '[C]hange' },
        { 'd', group = '[D]elete' },
        { 'cs', desc = 'Change [S]urround' },
        { 'ds', desc = 'Delete [S]urround' },
      },
    },
  },

  -- Fuzzy Find
  require 'custom.plugins.telescope.init',

  -- Native LSP Config for Neovim 0.11+
  require 'lsp',

  {
    'EdenEast/nightfox.nvim',
    priority = 1000, -- Make sure to load this before all the other start plugins.
    config = function()
      vim.cmd.colorscheme 'nightfox'
    end,
  },
  { 'ellisonleao/gruvbox.nvim', priority = 1000, config = true, opts = {} },
  {
    'wurli/cobalt.nvim',
    lazy = false,
    priority = 1000,
    opts = {},
  },

  -- Highlight todo, notes, etc in comments
  { 'folke/todo-comments.nvim', event = 'VimEnter', dependencies = { 'nvim-lua/plenary.nvim' }, opts = { signs = false } },

  { -- Collection of various small independent plugins/modules
    'echasnovski/mini.nvim',
    config = function()
      -- Work with trailing whitespace
      --
      require('mini.trailspace').setup()

      -- Better Around/Inside textobjects
      --
      -- Examples:
      --  - va)  - [V]isually select [A]round [)]paren
      --  - yinq - [Y]ank [I]nside [N]ext [Q]uote
      --  - ci'  - [C]hange [I]nside [']quote
      require('mini.ai').setup { n_lines = 500 }

      -- Add/delete/replace surroundings (brackets, quotes, etc.)
      --
      -- - saiw) - [S]urround [A]dd [I]nner [W]ord [)]Paren
      -- - sd'   - [S]urround [D]elete [']quotes
      -- - sr)'  - [S]urround [R]eplace [)] [']
      require('mini.surround').setup {
        mappings = {
          find = 'sf', -- Find surrounding (to the right)
          replace = 'cs',
          delete = 'ds',
        },
        search_method = 'cover_or_nearest',
      }

      -- Simple and easy statusline.
      --  You could remove this setup call if you don't like it,
      --  and try some other statusline plugin
      local statusline = require 'mini.statusline'
      -- set use_icons to true if you have a Nerd Font
      statusline.setup { use_icons = vim.g.have_nerd_font }

      -- You can configure sections in the statusline by overriding their
      -- default behavior. For example, here we set the section for
      -- cursor location to LINE:COLUMN
      ---@diagnostic disable-next-line: duplicate-set-field
      statusline.section_location = function()
        return '%2l:%-2v'
      end

      -- ... and there is more!
      --  Check out: https://github.com/echasnovski/mini.nvim
    end,
  },

  require 'kickstart.plugins.indent_line',
  require 'kickstart.plugins.autopairs',
  require 'kickstart.plugins.neo-tree',
  require 'kickstart.plugins.gitsigns', -- adds gitsigns recommend keymaps
  { import = 'custom.plugins' },
  require 'custom.plugins.yazi',

  -- Rails development enhancements
  {
    'tpope/vim-rails',
    ft = { 'ruby', 'eruby', 'haml', 'slim' },
    cmd = {
      'Emodel',
      'Eview',
      'Econtroller',
      'Ehelper',
      'Einitializer',
      'Emigration',
      'Eschema',
    },
  },

  -- Add test runner for Ruby
  {
    'vim-test/vim-test',
    keys = {
      { '<leader>rt', '<cmd>TestFile<cr>', desc = '[R]uby [T]est File' },
      { '<leader>rs', '<cmd>TestNearest<cr>', desc = '[R]uby Test [S]ingle' },
      { '<leader>rl', '<cmd>TestLast<cr>', desc = '[R]uby Test [L]ast' },
      { '<leader>ra', '<cmd>TestSuite<cr>', desc = '[R]uby Test [A]ll' },
    },
    config = function()
      vim.g['test#strategy'] = 'neovim'
      vim.g['test#ruby#bundle_exec'] = 1
      vim.g['test#ruby#use_binstubs'] = 0
    end,
  },
}, {
  ui = {
    -- If you are using a Nerd Font: set icons to an empty table which will use the
    -- default lazy.nvim defined Nerd Font icons, otherwise define a unicode icons table
    icons = vim.g.have_nerd_font and {} or {
      cmd = '⌘',
      config = '🛠',
      event = '📅',
      ft = '📂',
      init = '⚙',
      keys = '🗝',
      plugin = '🔌',
      runtime = '💻',
      require = '🌙',
      source = '📄',
      start = '🚀',
      task = '📌',
      lazy = '💤 ',
    },
  },
})

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
