--  NOTE: Must happen before plugins are loaded (otherwise wrong leader will be used)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
vim.g.have_nerd_font = true -- Set to true if you have a Nerd Font installed and selected

-- UI =========================================================================
vim.opt.number = true -- Show line numbers
vim.opt.relativenumber = false -- Use absolute line numbers
vim.opt.cursorline = true -- Highlight current line
vim.opt.signcolumn = 'yes' -- Always show sign column to prevent layout shift
vim.opt.showmode = false -- Don't show mode in command line (statusline shows it)
vim.opt.list = true -- Show certain whitespace characters
vim.opt.scrolloff = 10 -- Minimal lines above/below cursor
vim.opt.colorcolumn = '+1' -- Shows column right after textwidth
vim.opt.breakindent = true -- Indent wrapped lines to match line start
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣', extends = '…', precedes = '…' } -- Define whitespace characters

-- Input ======================================================================
vim.opt.mouse = 'a' -- Enable mouse for all modes (useful for resizing splits)
vim.opt.timeoutlen = 300 -- Time to wait for mapped sequence (ms)
vim.opt.confirm = true -- Ask to save changes instead of failing
vim.opt.mousescroll = 'ver:3,hor:6' -- Customizes mouse scroll speed (smoother scrolling)

-- Display ====================================================================
vim.opt.breakindentopt = 'list:-1' -- Adds padding for list continuations when wrapping
vim.opt.linebreak = true -- Wraps at word boundaries (looks cleaner when wrap is on)
vim.opt.pumheight = 10 -- Limits popup menu height to 10 items (prevents giant completion menus)
vim.opt.ruler = false -- Disables cursor position in cmdline (statusline shows it anyway)
vim.opt.shortmess = 'CFOSWaco' -- Reduces verbose completion/search messages
vim.opt.splitkeep = 'screen' -- Keeps content stable during split operations (less jarring)
vim.opt.winborder = 'single' -- Adds borders to floating windows

-- Clipboard ==================================================================
vim.schedule(function()
  vim.opt.clipboard = 'unnamedplus' -- Use system clipboard (scheduled to avoid startup delay)
end)

-- Files ======================================================================
vim.opt.undofile = true -- Save undo history to file
vim.opt.autoread = true -- Auto-reload files changed externally

-- Autocommand helper
local autocmd = vim.api.nvim_create_autocmd

-- Auto-refresh files when they change externally
local autorefresh_group = vim.api.nvim_create_augroup('autorefresh', { clear = true })
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

-- Search =====================================================================
vim.opt.ignorecase = true -- Case-insensitive search by default
vim.opt.smartcase = true -- Case-sensitive if search contains uppercase
vim.opt.inccommand = 'split' -- Preview substitutions live as you type
vim.opt.incsearch = true -- Show matches while typing search

-- Editing ====================================================================
vim.opt.formatoptions = 'rqnl1j' -- Smart comment formatting and joining
vim.opt.virtualedit = 'block' -- Allow cursor past EOL in visual block mode
vim.opt.spelloptions = 'camel' -- Spell-check CamelCase words correctly
vim.opt.infercase = true -- Smart case handling in keyword completion

-- Splits =====================================================================
vim.opt.splitright = true -- Vertical splits open to the right
vim.opt.splitbelow = true -- Horizontal splits open below
vim.opt.switchbuf = 'usetab' -- Reuse existing tabs when switching buffers
-- vim.opt.switchbuf = 'vsplit' -- Open special buffers in vertical splits

-- Performance ================================================================
vim.opt.updatetime = 250 -- Faster completion and swap file writes (ms)

-- Folding ====================================================================
vim.opt.foldmethod = 'indent' -- Use indentation for folding
vim.opt.foldlevel = 10 -- Change to 99 to start with all folds open
vim.opt.foldenable = true -- Enable folding
vim.opt.foldnestmax = 10 -- Maximum 10 nested fold levels (prevents performance issues)
vim.opt.foldtext = '' -- Use default fold display with syntax highlighting

-- Experimental UI ============================================================
-- Provides an experimental commandline and message UI
require('vim._extui').enable {
  enable = true, -- Whether to enable or disable the UI.
  msg = { -- Options related to the message module.
    ---@type 'cmd'|'msg' Where to place regular messages, either in the
    ---cmdline or in a separate ephemeral message window.
    target = 'msg',
    timeout = 4000, -- Time a message is visible in the message window.
  },
}

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
        { '<leader>go', group = '[O]cto/GitHub' },
        { '<leader>gy', group = 'Git [Y]ank URL', mode = { 'n', 'v' } },
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

        -- Non-leader mappings
        { 'c', group = '[C]hange' },
        { 'd', group = '[D]elete' },
        { 'cs', desc = 'Change [S]urround' },
        { 'ds', desc = 'Delete [S]urround' },
        { 'gr', group = 'LSP [R]eferences' },

        -- g commands (built-in Vim)
        { 'g', group = '[G]o / Misc' },
        { 'gq', desc = 'Format motion (textwidth)' },
        { 'gw', desc = 'Format motion (no cursor move)' },
        { 'gu', desc = 'Lowercase motion' },
        { 'gU', desc = 'Uppercase motion' },
        { 'g~', desc = 'Toggle case motion' },
        { 'gJ', desc = 'Join lines (no space)' },
        { 'gv', desc = 'Reselect last visual' },
        { 'gn', desc = 'Select next search match' },
        { 'gN', desc = 'Select prev search match' },
        { 'g;', desc = 'Go to older change' },
        { 'g,', desc = 'Go to newer change' },
        { 'gi', desc = 'Insert at last insert pos' },
        { 'ga', desc = 'Align (mini.align)' },
        { 'gf', desc = 'Go to file under cursor' },
        { 'gx', desc = 'Open URL under cursor' },
        { 'g<C-g>', desc = 'Show cursor position info' },
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

      -- Align text interactively
      --
      -- Examples:
      --  - gaip= - [G]o [A]lign [I]nner [P]aragraph around '='
      --  - gai'-- - [G]o [A]lign [I]nside quotes around '--'
      require('mini.align').setup()

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
