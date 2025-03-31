-- Custom Keymaps
--
----------------------------------------------------------------------------------
-- TERMINAL COMMANDS (leader + t)
--------------------------------------------------------------------------------
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>:bd!<CR>', { desc = 'Close [T]erminal' })
-- vim.keymap.set('n', '<leader><Esc><Esc>', '<C-\\><C-n>:bd!<CR>', { desc = 'Close terminal' })

--------------------------------------------------------------------------------
-- BUFFER COMMANDS (leader + b)
--------------------------------------------------------------------------------
-- Delete (kill) current buffer
vim.keymap.set('n', '<leader>bd', ':bdelete<CR>', { desc = '[B]uffer [d]elete' })
vim.keymap.set('n', '<ESC><ESC>', ':bdelete<CR>', { desc = '[B]uffer [d]elete' })

-- Remap Macros
vim.keymap.set('n', 'q', '<Nop>', { noremap = true, desc = 'Disabled default macro key' })
vim.keymap.set('n', '<leader>m', 'q', { noremap = true, desc = 'Start recording macro' })

-- Quick kill help menus
vim.api.nvim_create_autocmd('FileType', {
  pattern = 'help',
  callback = function()
    vim.keymap.set('n', 'q', ':q<CR>', { buffer = true, desc = '[Q]uit help window' })
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

-- Prompt to open/edit a new file (substituting current directory path, etc.)
-- TODO: Figure out find file vs format
-- vim.keymap.set('n', '<leader>ff', ':edit <C-R>=substitute(expand("%:p:h"), $HOME, "~", "")<CR>/', { desc = '[F]ile [f]ind file prompt' })

-- Write (save) current file
vim.keymap.set('n', '<leader>fs', ':write<CR>', { desc = '[F]ile [s]ave' })

-- Write all open files
vim.keymap.set('n', '<leader>fS', ':wall<CR>', { desc = '[F]ile [S]ave all' })

-- Yank relative file path
vim.keymap.set('n', '<leader>fyy', ':let @+ = expand("%")<CR>', { desc = '[F]ile [Y]ank rel path' })

-- Yank absolute file path
vim.keymap.set('n', '<leader>fyY', ':let @+ = expand("%:p")<CR>', { desc = '[F]ile [Y]ank abs path' })

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

-- Jump among splits
vim.keymap.set('n', '<leader>wh', '<C-W>h', { desc = '[W]indow left' })
vim.keymap.set('n', '<leader>wj', '<C-W>j', { desc = '[W]indow down' })
vim.keymap.set('n', '<leader>wk', '<C-W>k', { desc = '[W]indow up' })
vim.keymap.set('n', '<leader>wl', '<C-W>l', { desc = '[W]indow right' })

-- Switch split windows (rotate focus)
vim.keymap.set('n', '<leader>ww', '<C-W><C-W>', { desc = '[W]indow cycle' })

-- Maximize current windows
vim.keymap.set('n', '<leader>wm', ':only<CR>', { desc = '[W]indow cycle' })
--------------------------------------------------------------------------------
-- TOGGLES (leader + t)
--------------------------------------------------------------------------------
-- Toggle line numbers
vim.keymap.set('n', '<leader>tn', ':set number!<CR>', { desc = '[T]oggle [n]umber' })

-- Toggle line wrapping
vim.keymap.set('n', '<leader>tl', ':set wrap!<CR>', { desc = '[T]oggle [l]ine wrap' })

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
vim.keymap.set('x', 'S', [[:<C-u>lua MiniSurround.add('visual')<CR>]], { silent = true })

--------------------------------------------------------------------------------
-- TROUBLE
--------------------------------------------------------------------------------
vim.keymap.set('n', '<leader>tt', ':Trouble<CR>', { desc = '[T]rouble [T]oggle' })
vim.keymap.set('n', '<leader>tq', ':Trouble quickfix<CR>', { desc = '[T]rouble [Q]uickfix' })
vim.keymap.set('n', '<leader>tl', ':Trouble loclist<CR>', { desc = '[T]rouble [L]ocation List' })
vim.keymap.set('n', '<leader>tr', ':Trouble lsp_references<CR>', { desc = '[T]rouble [R]eferences (LSP)' })
vim.keymap.set('n', '<leader>td', ':Trouble document_diagnostics<CR>', { desc = '[T]rouble [D]ocument Diagnostics' })
vim.keymap.set('n', '<leader>tD', ':Trouble workspace_diagnostics<CR>', { desc = '[T]rouble Workspace [D]iagnostics' })
vim.keymap.set('n', '<leader>tx', ':TroubleRefresh<CR>', { desc = '[T]rouble Refre[X]h' })
-- vim.keymap.set('n', '<leader>to', ':Trouble fold_open_all<CR>', { desc = '[T]rouble Fold [O]pen All' })
-- vim.keymap.set('n', '<leader>tc', ':Trouble fold_close_all<CR>', { desc = '[T]rouble Fold [C]lose All' })

vim.api.nvim_create_autocmd('FileType', {
  pattern = 'trouble',
  callback = function()
    vim.keymap.set('n', '<Tab>', function()
      require('trouble').fold_toggle()
    end, { buffer = true, desc = 'Trouble: Fold Toggle' })
  end,
})
