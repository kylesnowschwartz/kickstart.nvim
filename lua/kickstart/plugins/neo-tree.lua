-- Neo-tree is a Neovim plugin to browse the file system
-- https://github.com/nvim-neo-tree/neo-tree.nvim

return {
  'nvim-neo-tree/neo-tree.nvim',
  version = '*',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-tree/nvim-web-devicons', -- not strictly required, but recommended
    'MunifTanjim/nui.nvim',
  },
  lazy = false,
  keys = {
    { '\\', ':Neotree reveal<CR>', desc = 'NeoTree reveal', silent = true },
  },
  opts = {
    filesystem = {
      filtered_items = {
        visible = true, -- show filtered (hidden) items
        hide_dotfiles = false, -- show dotfiles
        hide_gitignored = false, -- optional: show gitignored files too
      },
      window = {
        mappings = {
          ['\\'] = 'close_window',
          ['y'] = {
            function(state)
              local node = state.tree:get_node()
              if not node or node.type == 'message' then
                return
              end
              local path = node:get_id()
              vim.fn.setreg('+', path, 'c')
              vim.notify('Copied path: ' .. path, vim.log.levels.INFO)
            end,
            desc = 'Copy full path to clipboard',
          },
          ['Y'] = 'copy_to_clipboard',
          ['<tab>'] = function(state)
            local node = state.tree:get_node()
            if require('neo-tree.utils').is_expandable(node) then
              state.commands['toggle_node'](state)
            else
              state.commands['open'](state)
              vim.cmd 'Neotree reveal'
            end
          end,
          -- Play audio files on Enter instead of opening them
          ['<CR>'] = function(state)
            local node = state.tree:get_node()

            -- Audio file extensions to handle (case-insensitive)
            local audio_extensions = {
              wav = true,
              mp3 = true,
              m4a = true,
              aac = true,
              ogg = true,
              flac = true,
            }

            if node.type == 'file' and node.ext and audio_extensions[node.ext:lower()] then
              -- Cross-platform audio playback
              local play_cmd
              if vim.fn.has 'mac' == 1 then
                play_cmd = { 'afplay', node:get_id() }
              elseif vim.fn.has 'unix' == 1 then
                play_cmd = { 'paplay', node:get_id() }
              elseif vim.fn.has 'win32' == 1 then
                play_cmd = { 'powershell', '-c', "(New-Object Media.SoundPlayer '" .. node:get_id() .. "').PlaySync()" }
              end

              if play_cmd then
                vim.fn.jobstart(play_cmd, {
                  detach = true,
                  on_exit = function(_, exit_code)
                    if exit_code ~= 0 then
                      vim.notify('Failed to play audio file: ' .. node.name, vim.log.levels.ERROR)
                    end
                  end,
                })
                vim.notify('Playing: ' .. node.name, vim.log.levels.INFO)
              else
                vim.notify('Audio playback not supported on this platform', vim.log.levels.WARN)
              end
              return
            end

            -- Default file opening behavior for non-audio files
            require('neo-tree.sources.filesystem.commands').open(state)
          end,
        },
      },
    },
  },
}
