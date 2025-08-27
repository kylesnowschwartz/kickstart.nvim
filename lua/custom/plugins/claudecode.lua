return {
  'coder/claudecode.nvim',
  dependencies = { 'folke/snacks.nvim' },
  opts = {
    terminal_cmd = '/Users/kyle/.claude-wrapper',
    log_level = 'info',
    terminal = {
      split_side = 'left',
      split_width_percentage = 0.30,
      snacks_win_opts = {
        position = 'left',
        width = 0.30,
        height = 0,
        wo = {
          winblend = 0,
        },
        keys = {
          claude_hide = {
            '<C-,>',
            function(self)
              self:hide()
            end,
            mode = { 't', 'n' },
            desc = 'Hide Claude',
          },
          claude_float = {
            '<C-f>',
            function(self)
              local is_float = self:is_floating()

              print('DEBUG: Current mode is_float =', is_float)
              print('DEBUG: Window config =', vim.inspect(vim.api.nvim_win_get_config(self.win)))

              local claudecode_terminal = require 'claudecode.terminal'
              claudecode_terminal.close()

              vim.schedule(function()
                local shared_keys = {
                  claude_hide = {
                    '<C-,>',
                    function(term_self)
                      term_self:hide()
                    end,
                    mode = { 't', 'n' },
                    desc = 'Hide Claude',
                  },
                  claude_float = {
                    '<C-f>',
                    function(term_self)
                      local is_float = term_self:is_floating()
                      print('DEBUG: Recursive toggle - Current mode is_float =', is_float)

                      claudecode_terminal.close()

                      vim.schedule(function()
                        local recursive_opts = {}
                        if is_float then
                          recursive_opts = {
                            split_side = 'left',
                            split_width_percentage = 0.30,
                            snacks_win_opts = {
                              position = 'left',
                              width = 0.30,
                              height = 0,
                              relative = 'editor',
                              wo = { winblend = 0 },
                              keys = shared_keys,
                            },
                          }
                        else
                          recursive_opts = {
                            snacks_win_opts = {
                              position = 'float',
                              width = 0.8,
                              height = 0.8,
                              relative = 'editor',
                              wo = { winblend = 10 },
                              keys = shared_keys,
                            },
                          }
                        end
                        claudecode_terminal.open(recursive_opts, '--continue')
                      end)
                    end,
                    mode = { 't', 'n' },
                    desc = 'Toggle Float/Embedded Mode',
                  },
                }

                local opts_override = {}

                if is_float then
                  opts_override = {
                    split_side = 'left',
                    split_width_percentage = 0.30,
                    snacks_win_opts = {
                      position = 'left',
                      width = 0.30,
                      height = 0,
                      relative = 'editor',
                      wo = { winblend = 0 },
                      keys = shared_keys,
                    },
                  }
                  print('DEBUG: Opening embedded with opts_override =', vim.inspect(opts_override))
                else
                  opts_override = {
                    snacks_win_opts = {
                      position = 'float',
                      width = 0.8,
                      height = 0.8,
                      relative = 'editor',
                      wo = { winblend = 10 },
                      keys = shared_keys,
                    },
                  }
                  print('DEBUG: Opening float with opts_override =', vim.inspect(opts_override))
                end

                claudecode_terminal.open(opts_override, '--continue')
              end)
            end,
            mode = { 't', 'n' },
            desc = 'Toggle Float/Embedded Mode',
          },
        },
      },
    },
  },
  keys = {
    { '<leader>a', nil, desc = 'AI/Claude Code' },
    { '<leader>ac', '<cmd>ClaudeCodeFocus<cr>', desc = 'Toggle Claude (Float)', mode = { 'n', 'v' } },
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
