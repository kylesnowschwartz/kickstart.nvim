-- fff.nvim: Rust-backed long-lived file index + picker.
-- Replaces Telescope's find_files / live_grep / grep_string / git_files / git_status.
-- Other Telescope pickers (LSP, git history, undo, registers, buffers, Swiper)
-- remain on Telescope. Keybinds are wired in lua/custom/plugins/telescope/init.lua
-- to keep all search keymaps colocated.
return {
  'dmtrKovalenko/fff.nvim',
  build = function()
    -- Downloads a prebuilt Rust binary, falls back to cargo build.
    require('fff.download').download_or_build_binary()
  end,
  lazy = false, -- the plugin lazy-initialises itself via lazy_sync
  opts = {
    lazy_sync = true,
    debug = {
      enabled = false,
      show_scores = false,
    },
    -- Frecency and history DBs use sensible defaults
    -- (stdpath('cache')/fff_nvim, stdpath('data')/fff_queries).
  },
}
