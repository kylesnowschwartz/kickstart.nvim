-- Common configuration values
local EMBEDDED_WIDTH = 0.30
local FLOAT_WIDTH = 0.8
local FLOAT_HEIGHT = 0.8
local EMBEDDED_BLEND = 0
local FLOAT_BLEND = 10

-- Common keybindings
local HIDE_KEY = '<C-,>'
local TOGGLE_KEY = '<C-S-f>'
local FOCUS_KEY = '<C-f>'
local KEY_MODES = { 't', 'n' }

-- Common positions
local POSITION_LEFT = 'left'
local POSITION_FLOAT = 'float'
local RELATIVE_EDITOR = 'editor'

-- Key descriptions
local HIDE_DESC = 'Hide Claude'
local TOGGLE_DESC = 'Toggle Float/Embedded Mode'
local FOCUS_DESC = 'Toggle Focus (Claude/Editor)'

-- Create hide key configuration
local function create_hide_key(action_fn)
  return {
    HIDE_KEY,
    action_fn,
    mode = KEY_MODES,
    desc = HIDE_DESC,
  }
end

-- Create focus toggle key configuration
local function create_focus_key()
  return {
    FOCUS_KEY,
    function(self)
      local current_win = vim.api.nvim_get_current_win()
      if self.win == current_win then
        -- Currently in terminal - switch to previous window
        vim.cmd 'wincmd p'
      else
        -- Not in terminal - focus the terminal and enter insert mode
        self:focus()
        vim.cmd 'startinsert'
      end
    end,
    mode = KEY_MODES,
    desc = FOCUS_DESC,
  }
end

-- Define the functions in proper order to avoid circular references
local function create_embedded_opts(keys)
  return {
    position = POSITION_LEFT,
    width = EMBEDDED_WIDTH,
    height = 0,
    relative = RELATIVE_EDITOR,
    wo = { winblend = EMBEDDED_BLEND },
    keys = keys,
  }
end

local function create_float_opts(keys)
  return {
    position = POSITION_FLOAT,
    width = FLOAT_WIDTH,
    height = FLOAT_HEIGHT,
    relative = RELATIVE_EDITOR,
    wo = { winblend = FLOAT_BLEND },
    keys = keys,
  }
end

local function create_embedded_config(keys)
  return {
    split_side = POSITION_LEFT,
    split_width_percentage = EMBEDDED_WIDTH,
    auto_close = false, -- Disable auto_close to prevent error messages during toggle
    snacks_win_opts = create_embedded_opts(keys),
  }
end

local function create_float_config(keys)
  return {
    auto_close = false, -- Disable auto_close to prevent error messages during toggle
    snacks_win_opts = create_float_opts(keys),
  }
end

-- Forward declaration for circular reference
local create_toggle_key

-- Single shared toggle function that works from any mode
local function toggle_claude_mode(self)
  local is_float = self:is_floating()
  local claudecode_terminal = require 'claudecode.terminal'

  claudecode_terminal.close()

  vim.schedule(function()
    -- Create the same keys for the new window
    local keys = {
      claude_hide = create_hide_key(function(term_self)
        term_self:hide()
      end),
      claude_float = create_toggle_key(),
      claude_focus = create_focus_key(),
    }

    local opts = is_float and create_embedded_config(keys) or create_float_config(keys)
    claudecode_terminal.open(opts, '--continue')
  end)
end

-- Create toggle key configuration
create_toggle_key = function()
  return {
    TOGGLE_KEY,
    toggle_claude_mode,
    mode = KEY_MODES,
    desc = TOGGLE_DESC,
  }
end

return {
  'coder/claudecode.nvim',
  dependencies = { 'folke/snacks.nvim' },
  opts = {
    terminal_cmd = '/home/kyle/.claude-wrapper',
    log_level = 'info',
    terminal = {
      split_side = POSITION_LEFT,
      split_width_percentage = EMBEDDED_WIDTH,
      auto_close = false, -- Disable auto_close to prevent error messages during toggle
      snacks_win_opts = {
        position = POSITION_LEFT,
        width = EMBEDDED_WIDTH,
        height = 0,
        wo = {
          winblend = EMBEDDED_BLEND,
        },
        keys = {
          claude_hide = create_hide_key(function(self)
            self:hide()
          end),
          claude_float = create_toggle_key(),
          claude_focus = create_focus_key(),
        },
      },
    },
  },
  keys = {
    { '<leader>a', nil, desc = 'AI/Claude Code' },
    { '<leader>ac', '<cmd>ClaudeCodeFocus<cr>', desc = 'Focus Claude', mode = { 'n', 'v' } },
    { '<leader>aR', '<cmd>ClaudeCode --resume<cr>', desc = 'Resume Claude' },
    { '<leader>aC', '<cmd>ClaudeCode --continue<cr>', desc = 'Continue Claude' },
    { '<leader>ab', '<cmd>ClaudeCodeAdd %<cr>', desc = 'Add current buffer' },
    { '<leader>as', '<cmd>ClaudeCodeSend<cr>', mode = 'v', desc = 'Send to Claude' },
    {
      '<leader>as',
      '<cmd>ClaudeCodeTreeAdd<cr>',
      desc = 'Add file',
      ft = { 'NvimTree', 'neo-tree', 'oil' },
    },
    { '<leader>aa', '<cmd>ClaudeCodeDiffAccept<cr>', desc = 'Accept diff' },
    { '<leader>ad', '<cmd>ClaudeCodeDiffDeny<cr>', desc = 'Deny diff' },
  },
}
