-- Custom Keymaps
--
----------------------------------------------------------------------------------
-- TERMINAL COMMANDS
--------------------------------------------------------------------------------
-- Single ESC to enter normal mode, <Esc><Esc> to close terminal
vim.keymap.set('t', '<Esc>', '<C-\\><C-n>', { desc = 'Terminal: Enter normal mode' })
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>:bd!<CR>', { desc = 'Terminal: Close terminal' })

-- Open a terminal buffer
vim.keymap.set('n', '<leader>tt', ':terminal<CR>i', { desc = '[T]erminal: Open [t]erminal' })

--------------------------------------------------------------------------------
-- BUFFER COMMANDS (leader + b)
--------------------------------------------------------------------------------
-- Delete (kill) current buffer
vim.keymap.set('n', '<leader>bd', ':bdelete<CR>', { desc = '[B]uffer [d]elete' })

-- Remap Macros
vim.keymap.set('n', 'q', '<Nop>', { noremap = true, desc = 'Disabled default macro key' })
vim.keymap.set('n', '<leader>m', 'q', { noremap = true, desc = 'Start recording macro' })

-- Quick kill help menus
vim.api.nvim_create_autocmd('FileType', {
  pattern = 'help',
  callback = function()
    vim.keymap.set('n', 'q', ':q<CR>', { buffer = true, desc = '[Q]uit help window', silent = true })
  end,
})
vim.api.nvim_create_autocmd('FileType', {
  pattern = 'help',
  callback = function()
    vim.keymap.set('n', '<ESC><ESC>', ':q<CR>', { buffer = true, desc = '[Q]uit help window', silent = true })
  end,
})

-- Go to next/previous buffer
vim.keymap.set('n', '<leader>bn', ':bn<CR>', { desc = '[B]uffer [n]ext' })
vim.keymap.set('n', '<leader>bp', ':bp<CR>', { desc = '[B]uffer [p]revious' })

-- Reload current buffer (like re-edit)
vim.keymap.set('n', '<leader>bR', ':edit<CR>', { desc = '[B]uffer [R]eload current file' })

-- Open scratch buffer
vim.keymap.set('n', '<leader>bs', function()
  vim.cmd 'enew' -- Create a new empty buffer.
  -- Set scratch buffer options.
  vim.opt_local.buftype = 'nofile'
  vim.opt_local.bufhidden = 'hide' -- Keeps buffer in memory when switching.
  vim.opt_local.swapfile = false
  -- Prevent auto-session from saving this buffer.
  vim.b.auto_session_enabled = false
  -- Generate a unique buffer name, e.g., using the current date/time.
  local name = 'Scratch-' .. os.date '%m%d-%H:%M:%S'
  vim.cmd('file ' .. name)

  -- Custom variable to track scratch buffers
  vim.b.scratch_buffer = true
  -- Autocmd to change bufhidden to 'wipe' only when exiting Neovim.
  vim.api.nvim_create_autocmd('VimLeavePre', {
    buffer = 0, -- Apply to the current buffer
    callback = function()
      vim.opt_local.bufhidden = 'delete'
      vim.cmd 'bdelete!'
    end,
  })
end, { desc = '[B]uffer [S]cratch' })

-- Save scratch buffer
vim.keymap.set('n', '<leader>bw', ':setlocal buftype= | w<CR>', { desc = '[B]uffer [W]rite Scratch' })

--------------------------------------------------------------------------------
-- FILE COMMANDS (leader + f)
--------------------------------------------------------------------------------
-- Edit Neovim config (replace with your actual init.lua path, if desired)
vim.keymap.set('n', '<leader>fed', ':e $MYVIMRC<CR>', { desc = '/init.lua' })

-- Edit Neovim config (replace with your actual init.lua path, if desired)
vim.keymap.set('n', '<leader>fec', ':e /Users/kyle/.config/nvim/lua/custom/keymaps.lua<CR>', { desc = 'custom/keymaps.lua' })

-- Edit Neovim config (replace with your actual init.lua path, if desired)
vim.keymap.set('n', '<leader>fep', ':e /Users/kyle/.config/nvim/lua/custom/plugins/init.lua<CR>', { desc = 'custom/plugins/init.lua' })

-- Reloading not supported with lazy.nvim
-- vim.keymap.set('n', '<leader>feR', ':source $MYVIMRC', { desc = 'reload init.lua' })

-- Note: We use Telescope for file finding with <leader>ff and <leader>pf
-- so this keybinding is unnecessary

-- Write (save) current file
vim.keymap.set('n', '<leader>fs', ':write<CR>', { desc = '[F]ile [s]ave' })

-- Write all open files
vim.keymap.set('n', '<leader>fS', ':wall<CR>', { desc = '[F]ile [S]ave all' })

-- Yank relative file path
vim.keymap.set('n', '<leader>fyy', function()
  local path = vim.fn.expand '%'
  vim.fn.setreg('+', path)
  vim.api.nvim_echo({ { path, 'Normal' } }, false, {})
end, { desc = '[F]ile [Y]ank rel path' })

-- Yank absolute file path
vim.keymap.set('n', '<leader>fyY', function()
  local path = vim.fn.expand '%:p'
  vim.fn.setreg('+', path)
  vim.api.nvim_echo({ { path, 'Normal' } }, false, {})
end, { desc = '[F]ile [Y]ank abs path' })

--------------------------------------------------------------------------------
-- QUITTING (leader + q)
--------------------------------------------------------------------------------
-- Quit all
vim.keymap.set('n', '<leader>qq', ':quitall<CR>', { desc = '[Q]uit [a]ll' })

-- Quit all (discard changes)
vim.keymap.set('n', '<leader>qQ', ':quitall!<CR>', { desc = '[Q]uit all (force)' })

-- Save all and quit
vim.keymap.set('n', '<leader>qs', ':xa<CR>', { desc = '[Q]uit & [s]ave all' })

--------------------------------------------------------------------------------
-- WINDOW / SPLITS (leader + w)
--------------------------------------------------------------------------------
-- Horizontal / vertical splits
vim.keymap.set('n', '<leader>w-', ':split<CR>', { desc = '[W]indow - horizontal split' })
vim.keymap.set('n', '<leader>w/', ':vsplit<CR>', { desc = '[W]indow / vertical split' })

-- Equalize split sizes
vim.keymap.set('n', '<leader>w=', '<C-W>=', { desc = '[W]indow resize [=]' })

-- Close current split
vim.keymap.set('n', '<leader>wd', ':q<CR>', { desc = '[W]indow [d]elete' })

-- Jump among splits (via vim-tmux-navigator plugin)
-- These are now defined in lua/custom/plugins/init.lua

-- Switch split windows (rotate focus)
vim.keymap.set('n', '<leader>ww', '<C-W><C-W>', { desc = '[W]indow cycle' })

-- Maximize current window
vim.keymap.set('n', '<leader>wm', ':only<CR>', { desc = '[W]indow [m]aximize' })
--------------------------------------------------------------------------------
-- TOGGLES (leader + T for global toggles)
--------------------------------------------------------------------------------
-- Toggle line numbers
vim.keymap.set('n', '<leader>Tn', ':set number!<CR>', { desc = '[T]oggle [n]umber' })

-- Toggle line wrapping
vim.keymap.set('n', '<leader>Tl', ':set wrap!<CR>', { desc = '[T]oggle [l]ine wrap' })

--------------------------------------------------------------------------------
-- ERROR/LOCATION LIST NAVIGATION (leader + e)
--------------------------------------------------------------------------------
vim.keymap.set('n', '<leader>en', ':lnext<CR>', { desc = '[E]rror [n]ext (location list)' })
vim.keymap.set('n', '<leader>ep', ':lprev<CR>', { desc = '[E]rror [p]revious (location list)' })

--------------------------------------------------------------------------------
-- MISC
--------------------------------------------------------------------------------
-- Re-indent entire buffer
vim.keymap.set('n', '<leader>=', 'mzgg=G`z', { desc = 'Reindent entire buffer' })

-- Clear search highlight
vim.keymap.set('n', '<leader>sc', ':nohlsearch<CR>', { desc = '[S]earch [c]lear highlight' })

-- (Optionally) if you still want <Tab> to switch buffers:
-- vim.keymap.set('n', '<Tab>', '<C-^>', { desc = 'Switch to previous buffer' })
--
--------------------------------------------------------------------------------
-- MINI: mini.surround
--------------------------------------------------------------------------------
-- Remap adding surrounding to Visual mode selection
vim.keymap.set('x', 'S', [[:<C-u>lua MiniSurround.add('visual')<CR>]], { desc = '[S]urround' })

--------------------------------------------------------------------------------
-- TROUBLE (leader + x for diagnostic)
--------------------------------------------------------------------------------
vim.keymap.set('n', '<leader>xx', ':Trouble<CR>', { desc = 'Trouble Toggle' })
vim.keymap.set('n', '<leader>xq', ':Trouble quickfix<CR>', { desc = 'Trouble [Q]uickfix' })
vim.keymap.set('n', '<leader>xl', ':Trouble loclist<CR>', { desc = 'Trouble [L]oclist' })
vim.keymap.set('n', '<leader>xr', ':Trouble lsp_references<CR>', { desc = 'Trouble [R]eferences (LSP)' })
vim.keymap.set('n', '<leader>xd', ':Trouble document_diagnostics<CR>', { desc = 'Trouble [D]ocument Diagnostics' })
vim.keymap.set('n', '<leader>xw', ':Trouble workspace_diagnostics<CR>', { desc = 'Trouble [W]orkspace Diagnostics' })
vim.keymap.set('n', '<leader>xf', ':TroubleRefresh<CR>', { desc = 'Trouble Re[f]resh' })
-- vim.keymap.set('n', '<leader>xo', ':Trouble fold_open_all<CR>', { desc = 'Trouble Fold [O]pen All' })
-- vim.keymap.set('n', '<leader>xc', ':Trouble fold_close_all<CR>', { desc = 'Trouble Fold [C]lose All' })

vim.api.nvim_create_autocmd('FileType', {
  pattern = 'trouble',
  callback = function()
    vim.keymap.set('n', '<Tab>', function()
      require('trouble').fold_toggle()
    end, { buffer = true, desc = 'Trouble: Fold Toggle' })
  end,
})

--------------------------------------------------------------------------------
-- GIT LINKER
--------------------------------------------------------------------------------
vim.keymap.set(
  'n',
  '<leader>gyY',
  '<cmd>lua require"gitlinker".get_buf_range_url("n", {action_callback = require"gitlinker.actions".open_in_browser})<cr>',
  { silent = true, desc = 'Git [Y]ank and browse URL (current line)' }
)
vim.keymap.set(
  'v',
  '<leader>gyY',
  '<cmd>lua require"gitlinker".get_buf_range_url("v", {action_callback = require"gitlinker.actions".open_in_browser})<cr>',
  { silent = true, desc = 'Git [Y]ank and browse URL (selection)' }
)

--------------------------------------------------------------------------------
-- CLAUDE CODE
--------------------------------------------------------------------------------
vim.keymap.set('n', '<leader>cc', '<cmd>ClaudeCode<CR>', { desc = 'Toggle Claude Code' })
