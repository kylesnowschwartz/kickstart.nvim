--------------------------------------------------------------------------------
-- ToggleTerm Integration for Claude Code Terminal
--------------------------------------------------------------------------------
--
-- This configuration creates a persistent Claude Code terminal buffer that
-- always stays in normal mode when focused. Key features:
--
-- 1. Uses ToggleTerm to manage a dedicated claude-code terminal in a vertical split
-- 2. Forces normal mode for all terminals, including claude-code
-- 3. Provides keyboard shortcuts:
--    - <leader>cc - Open/close claude-code
--    - <leader>cC - Open with --continue flag (for session restoration)
--    - <leader>cV - Open with --verbose flag
--    - <leader>cR - Open with --resume flag
-- 4. Adds buffer-specific mappings in terminal mode to force normal mode when
--    navigating between windows (<leader>wh, <leader>wj, etc.)
-- 5. Preserves normal mode behavior when switching to/from the buffer
-- 6. Works with auto-session for proper session restoration
--
-- This addresses the issue where claude-code terminal would normally enter
-- insert mode automatically when switching to it from another buffer.
--
--------------------------------------------------------------------------------
return {
  'akinsho/toggleterm.nvim',
  version = '*',
  enabled = false, -- Disabled in favor of claude-code.nvim
  lazy = true,
  config = function()
    local status_ok, toggleterm = pcall(require, 'toggleterm')
    if not status_ok then
      vim.notify('toggleterm not found', vim.log.levels.ERROR)
      return
    end

    toggleterm.setup {
      -- Global settings for all terminals
      size = function(term)
        if term.direction == 'horizontal' then
          return 15
        elseif term.direction == 'vertical' then
          return vim.o.columns * 0.4
        end
      end,
      open_mapping = [[<c-\>]],
      hide_numbers = true,
      start_in_insert = false, -- Always start in normal mode
      insert_mappings = false, -- No insert mode mappings
      terminal_mappings = false, -- Don't auto-enable mappings
      persist_size = true,
      close_on_exit = true,
      direction = 'vertical',

      -- Force normal mode on all terminals when they open
      on_open = function()
        vim.cmd 'stopinsert'
      end,

      -- Float config
      float_opts = {
        border = 'curved',
        winblend = 0,
      },
    }

    -- Define claude-code terminal
    local Terminal = require('toggleterm.terminal').Terminal

    -- Window navigation shortcuts that force normal mode when used in terminal
    local normal_nav_mappings = {
      ['<leader>wh'] = { '<C-\\><C-n><C-w>h', 'Window navigation left' },
      ['<leader>wj'] = { '<C-\\><C-n><C-w>j', 'Window navigation down' },
      ['<leader>wk'] = { '<C-\\><C-n><C-w>k', 'Window navigation up' },
      ['<leader>wl'] = { '<C-\\><C-n><C-w>l', 'Window navigation right' },
      ['<leader>cn'] = { '<C-\\><C-n>', 'Force normal mode' },
      ['<leader>cq'] = { '<C-\\><C-n>:ToggleTerm<CR>', 'Exit Claude Code' },
    }

    -- Create claude-code terminal instance
    local claude_code = Terminal:new {
      cmd = '/Users/kyle/.claude-wrapper',
      dir = 'git_dir',
      hidden = true,
      direction = 'vertical', -- Use vertical split for claude-code
      count = 999, -- Unique ID for this terminal

      -- Float window settings (used if direction is changed to float)
      float_opts = {
        width = math.floor(vim.o.columns * 0.7),
        height = math.floor(vim.o.lines * 0.8),
        border = 'curved',
      },

      -- Setup when terminal opens
      on_open = function(term)
        -- Force normal mode and set buffer name
        vim.cmd 'stopinsert'
        vim.api.nvim_buf_set_name(term.bufnr, 'claude-code')

        -- Add terminal mode mappings for normal mode navigation
        for lhs, mapping in pairs(normal_nav_mappings) do
          local rhs, desc = unpack(mapping)
          vim.api.nvim_buf_set_keymap(term.bufnr, 't', lhs, rhs, { noremap = true, desc = desc })
        end
      end,
    }

    -- Helper function to toggle with flag
    local function toggle_with_flag(flag)
      return function()
        if not claude_code:is_open() then
          -- Save original command
          local original_cmd = claude_code.cmd
          -- Append flag if provided
          if flag then
            claude_code.cmd = original_cmd .. ' --' .. flag
          end
          -- Toggle terminal
          claude_code:toggle()
          -- Reset to original command for next use
          claude_code.cmd = original_cmd
        else
          claude_code:toggle()
        end
      end
    end

    -- Create commands for claude-code
    vim.api.nvim_create_user_command('ClaudeCode', toggle_with_flag(), {})
    vim.api.nvim_create_user_command('ClaudeCodeContinue', toggle_with_flag 'continue', {})
    vim.api.nvim_create_user_command('ClaudeCodeVerbose', toggle_with_flag 'verbose', {})
    vim.api.nvim_create_user_command('ClaudeCodeResume', toggle_with_flag 'resume', {})

    -- Set up key mappings for claude-code
    vim.keymap.set('n', '<leader>cc', '<cmd>ClaudeCode<CR>', { noremap = true, desc = 'Toggle Claude Code' })
    vim.keymap.set('n', '<leader>cC', '<cmd>ClaudeCodeContinue<CR>', { noremap = true, desc = 'Toggle Claude Code (continue)' })
    vim.keymap.set('n', '<leader>cV', '<cmd>ClaudeCodeVerbose<CR>', { noremap = true, desc = 'Toggle Claude Code (verbose)' })
    vim.keymap.set('n', '<leader>cR', '<cmd>ClaudeCodeResume<CR>', { noremap = true, desc = 'Toggle Claude Code (resume)' })
    vim.keymap.set('n', '<leader>cq', '<cmd>ClaudeCode<CR>', { noremap = true, desc = 'Exit Claude Code' })
  end,
}

