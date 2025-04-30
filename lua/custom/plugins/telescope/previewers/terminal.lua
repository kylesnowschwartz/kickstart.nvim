-- Custom terminal buffer previewer for Telescope
local from_entry = require "telescope.from_entry"
local previewers = require "telescope.previewers"
local putils = require "telescope.previewers.utils"
local conf = require("telescope.config").values

-- Terminal buffer previewer for Telescope
local TerminalBufferPreviewer = {}

-- Create a new terminal buffer previewer
function TerminalBufferPreviewer:new(opts)
  opts = opts or {}

  return previewers.new_buffer_previewer {
    title = "Terminal Preview",
    -- Use a dynamic title that shows the buffer name
    dyn_title = function(_, entry)
      return entry.filename or "Terminal Buffer"
    end,

    -- Define the preview behavior for terminal buffers
    define_preview = function(self, entry, status)
      -- Get the buffer number from options or use the current buffer
      local terminal_bufnr = opts.bufnr or vim.api.nvim_get_current_buf()
      
      -- Verify it's a terminal buffer
      if not vim.api.nvim_buf_is_valid(terminal_bufnr) or 
         vim.api.nvim_buf_get_option(terminal_bufnr, "buftype") ~= "terminal" then
        putils.set_preview_message(
          self.state.bufnr,
          status.preview_win,
          "Not a valid terminal buffer"
        )
        return
      end

      -- Get buffer lines and info for context
      local text = entry.text or ""
      local lnum = entry.lnum or 0
      local total_lines = vim.api.nvim_buf_line_count(terminal_bufnr)
      
      -- Format output
      local output = {}
      
      -- Calculate how many lines we should show based on window height
      local win_height = vim.api.nvim_win_get_height(status.preview_win)
      local context_size = math.max(20, math.floor(win_height / 2) - 1)
      
      -- Get context lines (as many as will fit reasonably in the window)
      local start_line = math.max(0, lnum - context_size)
      local end_line = math.min(total_lines, lnum + context_size)
      
      local context_lines = vim.api.nvim_buf_get_lines(
        terminal_bufnr,
        start_line,
        end_line,
        false
      )
      
      -- Format context lines with line numbers
      for i, line in ipairs(context_lines) do
        local ctx_lnum = start_line + i
        local prefix = ctx_lnum == lnum and "➤" or " "
        table.insert(output, string.format("%s %3d │ %s", prefix, ctx_lnum, line))
      end
      
      -- Set the output to the preview buffer
      vim.api.nvim_buf_set_lines(self.state.bufnr, 0, -1, false, output)
      
      -- Find the index of the selected line (should be the one with line number == lnum)
      local highlight_line_idx = nil
      for i, line in ipairs(output) do
        -- Look for the line that has our target line number
        if line:match("^%➤%s+%d+%s│") then
          highlight_line_idx = i - 1  -- 0-indexed in API
          break
        end
      end
      
      -- Highlight the selected line if we found it
      if highlight_line_idx then
        vim.api.nvim_buf_add_highlight(
          self.state.bufnr,
          0,
          "TelescopePreviewMatch",
          highlight_line_idx,
          0,
          -1
        )
      end
      
      -- Set the filetype to get syntax highlighting
      vim.api.nvim_buf_set_option(self.state.bufnr, "filetype", "terminal")
      
      -- Apply the same highlighting as the grep preview window
      vim.api.nvim_win_set_option(status.preview_win, "winhl", "Normal:TelescopePreviewNormal")
      vim.api.nvim_win_set_option(status.preview_win, "signcolumn", "no")
      vim.api.nvim_win_set_option(status.preview_win, "foldlevel", 100)
      vim.api.nvim_win_set_option(status.preview_win, "wrap", false)
    end,
  }
end

return TerminalBufferPreviewer