-- Custom Keymaps
--
----------------------------------------------------------------------------------
-- MOTION REMAPS
--------------------------------------------------------------------------------
-- Make j/k move by display lines (don't skip wrapped lines)
vim.keymap.set('n', 'j', 'gj', { desc = 'Move down (display line)' })
vim.keymap.set('n', 'k', 'gk', { desc = 'Move up (display line)' })
vim.keymap.set('n', 'gj', 'j', { desc = 'Move down (actual line)' })
vim.keymap.set('n', 'gk', 'k', { desc = 'Move up (actual line)' })

----------------------------------------------------------------------------------
-- TERMINAL COMMANDS
--------------------------------------------------------------------------------
-- Snacks terminal handles escape behavior with smart double-escape pattern
-- Single <Esc> passes through to terminal (Claude Code can halt)
-- Double <Esc><Esc> within 200ms switches to normal mode

-- Open a terminal buffer using snacks.nvim
vim.keymap.set('n', '<leader>tt', function()
  require('snacks').terminal()
end, { desc = '[T]erminal: Open [t]erminal' })

-- Disable line numbers in terminal buffers
vim.api.nvim_create_autocmd('TermOpen', {
  group = vim.api.nvim_create_augroup('terminal_settings', { clear = true }),
  callback = function()
    vim.opt_local.number = false
    vim.opt_local.relativenumber = false
  end,
})

--------------------------------------------------------------------------------
-- TAB COMMANDS
--------------------------------------------------------------------------------
-- Close current tab
vim.keymap.set('n', '<leader>td', ':tabclose<CR>', { desc = '[T]ab [d]elete (close)' })

--------------------------------------------------------------------------------
-- BUFFER COMMANDS (leader + b)
--------------------------------------------------------------------------------
-- Delete (kill) current buffer
-- vim.keymap.set('n', '<leader>bd', ':bdelete<CR>', { desc = '[B]uffer [d]elete' })
-- Close buffer without closing window (cycles to previous buffer)
vim.keymap.set('n', '<leader>bd', ':bp | bd #<CR>', { desc = '[B]uffer [k]ill (preserve window)' })

-- Remap Macros
vim.keymap.set('n', 'q', '<Nop>', { noremap = true, desc = 'Disabled default macro key' })
vim.keymap.set('n', '<leader>M', 'q', { noremap = true, desc = 'Start recording macro' })
vim.keymap.set('n', 'M', 'q', { noremap = true, desc = 'Stop recording macro' })

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

-- Yank buffer qualified name (full path)
vim.keymap.set('n', '<leader>byy', function()
  local path = vim.fn.expand '%:p'
  vim.fn.setreg('+', path)
  vim.api.nvim_echo({ { path, 'Normal' } }, false, {})
end, { desc = '[B]uffer [Y]ank qualified name' })

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
  local path = vim.fn.fnamemodify(vim.fn.expand '%:p', ':.')
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

-- Switch split windows (rotate focus)
vim.keymap.set('n', '<leader>ww', '<C-W><C-W>', { desc = '[W]indow cycle' })

-- Maximize current window
vim.keymap.set('n', '<leader>wm', ':only<CR>', { desc = '[W]indow [m]aximize' })

--------------------------------------------------------------------------------
-- SPACEMACS WINDOW COMMANDS (leader + w)
--------------------------------------------------------------------------------
-- Window navigation
vim.keymap.set('n', '<leader>wh', '<C-w>h', { desc = '[W]indow navigate left' })
vim.keymap.set('n', '<leader>wj', '<C-w>j', { desc = '[W]indow navigate down' })
vim.keymap.set('n', '<leader>wk', '<C-w>k', { desc = '[W]indow navigate up' })
vim.keymap.set('n', '<leader>wl', '<C-w>l', { desc = '[W]indow navigate right' })

-- Window movement (not navigation)
vim.keymap.set('n', '<leader>wH', '<C-w>H', { desc = '[W]indow move window to left' })
vim.keymap.set('n', '<leader>wJ', '<C-w>J', { desc = '[W]indow move window to bottom' })
vim.keymap.set('n', '<leader>wK', '<C-w>K', { desc = '[W]indow move window to top' })
vim.keymap.set('n', '<leader>wL', '<C-w>L', { desc = '[W]indow move window to right' })

-- Window maximize (alternative)
vim.keymap.set('n', '<leader>w_', '<C-w>_', { desc = '[W]indow maximize horizontally' })
vim.keymap.set('n', '<leader>w|', '<C-w>|', { desc = '[W]indow maximize vertically' })

-- Tab alternate window
vim.keymap.set('n', '<leader><Tab>', '<C-^>', { desc = 'Switch to alternate window' })
-- Toggle between current and previous window (like 'last' on a remote)
vim.keymap.set('n', '<leader>w<Tab>', '<C-w>p', { desc = '[W]indow toggle to previous' })

-- Window resize
vim.keymap.set('n', '<leader>w[', ':vertical resize -5<CR>', { desc = '[W]indow shrink horizontally' })
vim.keymap.set('n', '<leader>w]', ':vertical resize +5<CR>', { desc = '[W]indow enlarge horizontally' })
vim.keymap.set('n', '<leader>w{', ':resize -5<CR>', { desc = '[W]indow shrink vertically' })
vim.keymap.set('n', '<leader>w}', ':resize +5<CR>', { desc = '[W]indow enlarge vertically' })

-- Window rotation
vim.keymap.set('n', '<leader>wr', '<C-w>r', { desc = '[W]indow [r]otate forward' })
vim.keymap.set('n', '<leader>wR', '<C-w>R', { desc = '[W]indow [R]otate backward' })

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
-- FORMATTING (leader + F)
--------------------------------------------------------------------------------
-- NOTE: Use gq{motion} directly for text formatting (see which-key hints for g)
--   gqap = format paragraph, gqq = format line, gqip = format inner paragraph
-- NOTE: Use ga{motion}{char} for alignment via mini.align
--   gaip= = align inner paragraph on '=', ga|= in visual mode, etc.

-- Reflow paragraph (join lines then reformat to new width)
vim.keymap.set('n', '<leader>Fr', 'vipJgwap', { desc = '[F]ormat [r]eflow paragraph' })
vim.keymap.set('v', '<leader>Fr', function()
  local tw = vim.bo.textwidth > 0 and vim.bo.textwidth or 80
  vim.cmd("'<,'>!fmt -w " .. tw)
end, { desc = '[F]ormat [r]eflow selection (exact)' })

-- Prettier formatting (preserves Markdown structure)
vim.keymap.set('n', '<leader>FP', function()
  local file = vim.fn.expand '%'
  if file == '' then
    print 'No file to format'
    return
  end
  local tw = vim.bo.textwidth > 0 and vim.bo.textwidth or 80
  vim.cmd('silent !prettier --write --prose-wrap always --print-width ' .. tw .. ' ' .. vim.fn.shellescape(file))
  vim.cmd 'edit!'
end, { desc = '[F]ormat with [P]rettier' })

vim.keymap.set('v', '<leader>FP', function()
  vim.cmd("'<,'>!prettier --stdin-filepath=" .. vim.fn.shellescape(vim.fn.expand '%'))
end, { desc = '[F]ormat selection with [P]rettier' })

-- Helper function to get appropriate comment syntax for modelines
local function get_modeline_comment(content)
  local ft = vim.bo.filetype
  local comment_map = {
    markdown = '<!-- ' .. content .. ' -->',
    html = '<!-- ' .. content .. ' -->',
    xml = '<!-- ' .. content .. ' -->',
    lua = '-- ' .. content,
    python = '# ' .. content,
    ruby = '# ' .. content,
    bash = '# ' .. content,
    sh = '# ' .. content,
    zsh = '# ' .. content,
    fish = '# ' .. content,
    vim = '" ' .. content,
    javascript = '// ' .. content,
    typescript = '// ' .. content,
    c = '// ' .. content,
    cpp = '// ' .. content,
    rust = '// ' .. content,
    go = '// ' .. content,
    java = '// ' .. content,
  }

  -- Default to # for unknown types (works for txt, conf, etc.)
  return comment_map[ft] or '# ' .. content
end

-- Modeline insertion for text wrapping
vim.keymap.set('n', '<leader>Fm', function()
  local content = 'vim: set textwidth=80 wrap linebreak:'
  local line = get_modeline_comment(content)
  vim.api.nvim_put({ line }, 'l', true, true)
end, { desc = '[F]ormat add [m]odeline (wrap 80)' })

vim.keymap.set('n', '<leader>FM', function()
  local tw = vim.fn.input 'Textwidth (default 80): '
  if tw == '' then
    tw = '80'
  end
  local content = string.format('vim: set textwidth=%s wrap linebreak:', tw)
  local line = get_modeline_comment(content)
  vim.api.nvim_put({ line }, 'l', true, true)
end, { desc = '[F]ormat add custom [M]odeline' })

--------------------------------------------------------------------------------
-- YANK/PASTE
--------------------------------------------------------------------------------
-- Swap p and P in visual mode - lowercase p should do the smart thing (paste without clobbering clipboard)
vim.keymap.set('v', 'p', 'P', { desc = 'Paste without yanking deleted text' })
vim.keymap.set('v', 'P', 'p', { desc = 'Paste and yank deleted text' })

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
-- TINY GIT
--------------------------------------------------------------------------------
vim.keymap.set('n', '<leader>tga', ':Tinygit interactiveStaging<CR>', { desc = 'Tiny [g]it [a]dd' })
vim.keymap.set('n', '<leader>tgc', ':Tinygit smartCommit<CR>', { desc = 'Tiny [g]it [c]ommit' })
vim.keymap.set('n', '<leader>tgp', ':Tinygit push<CR>', { desc = 'Tiny [g]it [p]ush' })

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
-- CODEDIFF
--------------------------------------------------------------------------------
-- Open CodeDiff view (git diff explorer)
vim.keymap.set('n', '<leader>gd', ':CodeDiff<CR>', { desc = 'Git [d]iff (CodeDiff)' })

--------------------------------------------------------------------------------
-- MESSAGES
--------------------------------------------------------------------------------
-- Add a keymap to copy from :messages buffer to clipboard
vim.keymap.set('n', '<leader>cm', function()
  -- Create a new split and redirect messages into it
  vim.cmd 'botright new'
  vim.cmd 'redir @a'
  vim.cmd 'silent messages'
  vim.cmd 'redir END'
  vim.cmd 'put a'
  vim.cmd 'normal! ggdd'
  vim.cmd 'setlocal buftype=nofile bufhidden=wipe noswapfile nomodified'
  vim.cmd 'file Messages'

  -- Set local options for this buffer
  vim.opt_local.number = false
  vim.opt_local.relativenumber = false

  -- Add a helpful mapping to copy all messages
  vim.keymap.set('n', 'yG', function()
    -- Yank from start to end
    vim.cmd 'normal! ggVGy'
    print 'Messages copied to clipboard'
  end, { buffer = true, desc = 'Yank all messages' })

  -- Add quit mapping
  vim.keymap.set('n', 'q', ':q<CR>', { buffer = true, desc = 'Close messages window', silent = true })

  print 'Press yG to copy all messages to clipboard, q to close'
end, { desc = 'Open [M]essages buffer with copy support' })

--------------------------------------------------------------------------------
-- FOLDING COMMANDS
--------------------------------------------------------------------------------
-- Leader-based fold commands
vim.keymap.set('n', '<leader>z', 'za', { desc = 'Toggle fold' })
vim.keymap.set('n', '<leader>zo', 'zR', { desc = 'Open all folds' })
vim.keymap.set('n', '<leader>zc', 'zM', { desc = 'Close all folds' })

--------------------------------------------------------------------------------
-- THEMERY
--------------------------------------------------------------------------------
vim.keymap.set('n', '<leader>Tt', ':Themery<CR>', { desc = 'Toggle Themery' })
