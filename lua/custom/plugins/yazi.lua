return {
  'mikavilpas/yazi.nvim',
  event = 'VeryLazy',
  dependencies = {
    { 'nvim-lua/plenary.nvim', lazy = true },
    'folke/snacks.nvim',
  },
  keys = {
    {
      '<leader>yz',
      mode = { 'n', 'v' },
      '<cmd>Yazi<cr>',
      desc = 'Open yazi at the current file',
    },
    {
      '<leader>yZr',
      '<cmd>Yazi toggle<cr>',
      desc = 'Resume the last yazi session',
    },
  },

  opts = {
    -- enable this if you want to open yazi instead of netrw.
    -- Note that if you enable this, you need to call yazi.setup() to
    -- initialize the plugin. lazy.nvim does this for you in certain cases.
    --
    -- If you are also using neotree, you may prefer not to bring it up when
    -- opening a directory:
    -- {
    --   "nvim-neo-tree/neo-tree.nvim",
    --   opts = {
    --     filesystem = {
    --       hijack_netrw_behavior = "disabled",
    --     },
    --   },
    -- }
    -- open_for_directories = false,

    -- the floating window scaling factor. 1 means 100%, 0.9 means 90%, etc.
    -- floating_window_scaling_factor = 0.9,

    -- the transparency of the yazi floating window (0-100). See :h winblend
    yazi_floating_window_winblend = 20,

    -- the type of border to use for the floating window. Can be many values,
    -- including 'none', 'rounded', 'single', 'double', 'shadow', etc. For
    -- more information, see :h nvim_open_win
    -- yazi_floating_window_border = 'rounded',

    -- customize the keymaps that are active when yazi is open and focused. The
    -- defaults are listed below. Note that the keymaps simply hijack input and
    -- they are never sent to yazi, so only try to map keys that are never
    -- needed by yazi.
    --
    -- Also:
    -- - use e.g. `open_file_in_tab = false` to disable a keymap
    -- - you can customize only some of the keymaps (not all of them)
    -- - you can opt out of all keymaps by setting `keymaps = false`
    keymaps = {
      show_help = '?',
      open_file_in_vertical_split = '<c-v>',
      open_file_in_horizontal_split = '<c-x>',
      open_file_in_tab = '<c-t>',
      grep_in_directory = '<c-s>',
      replace_in_directory = '<c-g>',
      cycle_open_buffers = '<tab>',
      copy_relative_path_to_selected_files = '<c-y>',
      send_to_quickfix_list = '<c-q>',
      change_working_directory = '.',
      open_and_pick_window = '<c-o>',
    },

    integrations = {
      --- What should be done when the user wants to grep in a directory
      grep_in_directory = function(directory)
        -- the default implementation uses telescope if available, otherwise nothing
      end,

      grep_in_selected_files = function(selected_files)
        -- similar to grep_in_directory, but for selected files
      end,

      --- Similarly, search and replace in the files in the directory
      replace_in_directory = function(directory)
        -- default: grug-far.nvim
      end,

      replace_in_selected_files = function(selected_files)
        -- default: grug-far.nvim
      end,
    },
  },
}
