return {
  'folke/snacks.nvim',
  enabled = true,
  event = 'VimEnter',
  opts = {
    picker = {
      enabled = true,
      layout = {
        cycle = true,
        preset = function()
          return vim.o.columns >= 120 and 'default' or 'vertical'
        end,
      },
      matcher = {
        fuzzy = true,
        smartcase = true,
        ignorecase = true,
        sort_empty = false,
        filename_bonus = true,
        file_pos = true,
      },
      sort = {
        fields = { 'score:desc', '#text', 'idx' },
      },
      ui_select = true,
      actions = require('trouble.sources.snacks').actions, -- equivalent of `<C-T>` with Trouble
      win = {
        input = {
          keys = {
            ['<C-t>'] = {
              'trouble_open',
              mode = { 'i', 'n' },
            },
          },
        },
        list = {
          keys = {
            ['<C-K>'] = 'preview_scroll_up',
            ['<C-J>'] = 'preview_scroll_down',
            ['<C-T>'] = 'trouble_open',
          },
        },
      },
    },
  },
  keys = {
    {
      '<leader>sh',
      function()
        Snacks.picker.help()
      end,
      desc = '[S]earch [H]elp',
    },
    {
      '<leader>sk',
      function()
        Snacks.picker.keymaps()
      end,
      desc = '[S]earch [K]eymaps',
    },
    {
      '<leader>sf',
      function()
        Snacks.picker.files()
      end,
      desc = '[S]earch [F]iles',
    },
    {
      '<leader>ff',
      function()
        Snacks.picker.files()
      end,
      desc = '[F]ind [F]iles',
    },
    {
      '<leader>sS',
      function()
        Snacks.picker.lsp_workspace_symbols()
      end,
      desc = '[S]earch [S]elect Telescope',
    },
    {
      '<leader>sW',
      function()
        Snacks.picker.grep_word()
      end,
      desc = '[S]earch current [W]ord',
    },
    {
      '<leader>sg',
      function()
        Snacks.picker.grep()
      end,
      desc = '[S]earch by [G]rep',
    },
    {
      '<leader>sD',
      function()
        Snacks.picker.diagnostics_buffer()
      end,
      desc = '[S]earch [D]iagnostics',
    },
    {
      '<leader>sr',
      function()
        Snacks.picker.resume()
      end,
      desc = '[S]earch [R]esume',
    },
    {
      '<leader>s.',
      function()
        Snacks.picker.recent()
      end,
      desc = '[S]earch Recent Files ("." for repeat)',
    },
    {
      '<leader>bb',
      function()
        Snacks.picker.buffers()
      end,
      desc = '[B]uffers Find existing buffers',
    },
    {
      '<leader>s"',
      function()
        Snacks.picker.registers()
      end,
      desc = '[S]earch ["]Registers',
    },
    {
      '<leader>sw',
      function()
        Snacks.picker.lsp_workspace_symbols()
      end,
      desc = '[S]earch [W]orkspace Symbols',
    },
    {
      '<leader>sd',
      function()
        Snacks.picker.lsp_symbols()
      end,
      desc = '[S]earch [D]ocument Symbols',
    },
    {
      '<leader>gf',
      function()
        Snacks.picker.git_log_file()
      end,
      desc = '[G]it [F]iles (tracked)',
    },
    {
      '<leader>gs',
      function()
        Snacks.picker.git_status()
      end,
      desc = '[G]it [S]tatus (changed files)',
    },
    {
      '<leader>gc',
      function()
        Snacks.picker.git_log()
      end,
      desc = '[G]it [C]ommits (repo history)',
    },
    {
      '<leader>gb',
      function()
        Snacks.picker.git_log_file()
      end,
      desc = '[G]it [B]uffer Commits (current file)',
    },
    {
      '<leader>gB',
      function()
        Snacks.picker.git_branches()
      end,
      desc = '[G]it [B]ranches (checkout)',
    },
    {
      '<leader>gS',
      function()
        Snacks.picker.git_stash()
      end,
      desc = '[G]it [S]tash (apply/view)',
    },
    {
      '<leader>/',
      function()
        Snacks.picker.lines()
      end,
      desc = '[/] Fuzzy search in buffer',
      silent = true,
    },
    {
      '<leader>ss',
      function()
        Snacks.picker.lines()
      end,
      desc = 'Swiper <3',
      silent = true,
    },
    {
      '<leader>s/',
      function()
        Snacks.picker.grep_buffers()
      end,
      desc = '[S]earch [/] in Open Files',
    },
    {
      '<leader>sn',
      function()
        Snacks.picker.files { cwd = vim.fn.stdpath 'config' }
      end,
      desc = '[S]earch [N]eovim files',
    },
    {
      '<leader>su',
      function()
        Snacks.picker.undo()
      end,
      desc = '[S]earch [U]ndo history',
    },
  },
}
