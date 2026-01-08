-- CodeDiff configuration
-- Git diff explorer with VSCode-style side-by-side view

local M = {}

local help_lines = {
  ' CodeDiff Keymaps',
  ' ───────────────────────────',
  ' View:',
  '   q       quit',
  '   e       toggle explorer',
  '   \\       focus explorer',
  '   ]c [c   next/prev hunk',
  '   ]f [f   next/prev file',
  '   do      diff get',
  '   dp      diff put',
  '',
  ' Explorer:',
  '   <CR>    select file',
  '   K       hover info',
  '   R       refresh',
  '   i       toggle view mode',
  '',
  ' Press ? or q to close',
}

local function show_help()
  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, help_lines)
  vim.bo[buf].modifiable = false

  local width = 32
  local height = #help_lines
  vim.api.nvim_open_win(buf, true, {
    relative = 'editor',
    width = width,
    height = height,
    row = math.floor((vim.o.lines - height) / 2),
    col = math.floor((vim.o.columns - width) / 2),
    style = 'minimal',
    border = 'rounded',
    title = ' Help ',
    title_pos = 'center',
  })

  vim.keymap.set('n', 'q', '<cmd>close<CR>', { buffer = buf, nowait = true })
  vim.keymap.set('n', '?', '<cmd>close<CR>', { buffer = buf, nowait = true })
  vim.keymap.set('n', '<Esc>', '<cmd>close<CR>', { buffer = buf, nowait = true })
end

-- Try to focus codediff explorer in current tab
-- Returns true if found and focused, false otherwise
local function focus_explorer()
  for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
    local buf = vim.api.nvim_win_get_buf(win)
    if vim.bo[buf].filetype == 'codediff-explorer' then
      vim.api.nvim_set_current_win(win)
      return true
    end
  end
  return false
end

function M.setup()
  require('codediff').setup {
    keymaps = {
      view = {
        quit = 'q',
        toggle_explorer = 'e',
        next_hunk = ']c',
        prev_hunk = '[c',
        next_file = ']f',
        prev_file = '[f',
        diff_get = 'do',
        diff_put = 'dp',
      },
      explorer = {
        select = '<CR>',
        hover = 'K',
        refresh = 'R',
        toggle_view_mode = 'i',
      },
    },
  }

  -- Help keymap in explorer
  vim.api.nvim_create_autocmd('FileType', {
    pattern = 'codediff-explorer',
    callback = function()
      vim.keymap.set('n', '?', show_help, { buffer = true, desc = 'CodeDiff help' })
    end,
  })

  -- Global \ keymap: focus codediff explorer if present, else neo-tree
  vim.keymap.set('n', '\\', function()
    if not focus_explorer() then
      vim.cmd 'Neotree toggle'
    end
  end, { desc = 'Focus explorer (CodeDiff or Neo-tree)' })
end

return M
