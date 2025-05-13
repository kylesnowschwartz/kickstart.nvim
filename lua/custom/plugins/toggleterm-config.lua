-- Configuration for ToggleTerm with claude-code integration
return {
  'akinsho/toggleterm.nvim',
  version = '*',
  lazy = false,
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
      shade_filetypes = {},
      shade_terminals = true,
      start_in_insert = false, -- Always start in normal mode
      insert_mappings = false, -- No insert mode mappings
      terminal_mappings = false, -- Don't auto-enable mappings
      persist_size = true,
      direction = 'vertical',
      close_on_exit = true,
      shell = vim.o.shell,
      float_opts = {
        border = 'curved',
        winblend = 0,
        highlights = {
          border = 'Normal',
          background = 'Normal',
        },
      },
      -- Custom handlers
      on_open = function(term)
        -- Always enter normal mode for all terminals when they open
        vim.cmd 'stopinsert'
      end,
    }

    -- Define claude-code terminal
    local Terminal = require('toggleterm.terminal').Terminal

    -- Create claude-code terminal instance
    local claude_code = Terminal:new {
      cmd = '/Users/kyle/.claude-wrapper',
      dir = 'git_dir',
      hidden = true,
      direction = 'vertical',
      float_opts = {
        width = math.floor(vim.o.columns * 0.7),
        height = math.floor(vim.o.lines * 0.8),
      },
      count = 999, -- Use a specific number to ensure we can find it
      on_open = function(term)
        -- Custom buffer-specific settings
        vim.cmd 'stopinsert'
        vim.api.nvim_buf_set_name(term.bufnr, 'claude-code')

        -- Add key mappings for this buffer
        vim.api.nvim_buf_set_keymap(term.bufnr, 'n', '<leader>cc', '', {
          noremap = true,
          silent = true,
          callback = function()
            toggleterm.toggle(999)
          end,
          desc = 'Toggle Claude Code terminal',
        })

        -- Add terminal mode mappings to always return to normal mode
        -- when navigating between windows
        vim.api.nvim_buf_set_keymap(term.bufnr, 't', '<leader>wh', '<C-\\><C-n><C-w>h', { noremap = true, desc = 'Window navigation left' })
        vim.api.nvim_buf_set_keymap(term.bufnr, 't', '<leader>wj', '<C-\\><C-n><C-w>j', { noremap = true, desc = 'Window navigation down' })
        vim.api.nvim_buf_set_keymap(term.bufnr, 't', '<leader>wk', '<C-\\><C-n><C-w>k', { noremap = true, desc = 'Window navigation up' })
        vim.api.nvim_buf_set_keymap(term.bufnr, 't', '<leader>wl', '<C-\\><C-n><C-w>l', { noremap = true, desc = 'Window navigation right' })

        -- Add a key to force normal mode if needed
        vim.api.nvim_buf_set_keymap(term.bufnr, 't', '<leader>cn', '<C-\\><C-n>', { noremap = true, desc = 'Force normal mode' })
      end,
      on_exit = function(_)
        -- Clean up when the terminal exits
      end,
    }

    -- Function to toggle claude-code terminal
    function _CLAUDE_CODE_TOGGLE()
      claude_code:toggle()
    end

    -- Create commands for claude-code
    vim.api.nvim_create_user_command('ClaudeCode', function()
      claude_code:toggle()
    end, {})

    vim.api.nvim_create_user_command('ClaudeCodeContinue', function()
      -- For session restoration - toggle with continue flag
      if not claude_code:is_open() then
        local cmd = claude_code.cmd .. ' --continue'
        claude_code.cmd = cmd
        claude_code:toggle()
        -- Reset cmd for next use
        claude_code.cmd = '/Users/kyle/.claude-wrapper'
      end
    end, {})

    vim.api.nvim_create_user_command('ClaudeCodeVerbose', function()
      local cmd = claude_code.cmd .. ' --verbose'
      claude_code.cmd = cmd
      claude_code:toggle()
      -- Reset cmd for next use
      claude_code.cmd = '/Users/kyle/.claude-wrapper'
    end, {})

    vim.api.nvim_create_user_command('ClaudeCodeResume', function()
      local cmd = claude_code.cmd .. ' --resume'
      claude_code.cmd = cmd
      claude_code:toggle()
      -- Reset cmd for next use
      claude_code.cmd = '/Users/kyle/.claude-wrapper'
    end, {})

    -- Set up key mappings for claude-code
    vim.keymap.set('n', '<leader>cc', '<cmd>ClaudeCode<CR>', { noremap = true, desc = 'Toggle Claude Code' })
    vim.keymap.set('n', '<leader>cC', '<cmd>ClaudeCodeContinue<CR>', { noremap = true, desc = 'Toggle Claude Code (continue)' })
    vim.keymap.set('n', '<leader>cV', '<cmd>ClaudeCodeVerbose<CR>', { noremap = true, desc = 'Toggle Claude Code (verbose)' })
    vim.keymap.set('n', '<leader>cR', '<cmd>ClaudeCodeResume<CR>', { noremap = true, desc = 'Toggle Claude Code (resume)' })
  end,
}

