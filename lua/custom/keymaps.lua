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

-- Go to next/previous buffer
vim.keymap.set('n', '<leader>bn', ':bn<CR>', { desc = '[B]uffer [n]ext' })
vim.keymap.set('n', '<leader>bp', ':bp<CR>', { desc = '[B]uffer [p]revious' })

-- Reload current buffer (like re-edit)
vim.keymap.set('n', '<leader>bR', ':edit<CR>', { desc = '[B]uffer [R]eload current file' })

--------------------------------------------------------------------------------
-- FILE COMMANDS (leader + f)
--------------------------------------------------------------------------------
-- Edit Neovim config (replace with your actual init.lua path, if desired)
vim.keymap.set('n', '<leader>fed', ':e $MYVIMRC<CR>', { desc = '/init.lua' })

-- Edit Neovim config (replace with your actual init.lua path, if desired)
vim.keymap.set('n', '<leader>fec', ':e /Users/kyle/.config/nvim/lua/custom/keymaps.lua<CR>', { desc = 'custom/keymaps.lua' })

-- Edit Neovim config (replace with your actual init.lua path, if desired)
vim.keymap.set('n', '<leader>fep', ':e /Users/kyle/.config/nvim/lua/custom/plugins.lua<CR>', { desc = 'custom/plugins/init.lua' })

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
vim.keymap.set('n', '<leader>fy', ':let @+ = expand("%")<CR>', { desc = '[F]ile [Y]ank rel path' })

-- Yank absolute file path
vim.keymap.set('n', '<leader>fY', ':let @+ = expand("%:p")<CR>', { desc = '[F]ile [Y]ank abs path' })

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
