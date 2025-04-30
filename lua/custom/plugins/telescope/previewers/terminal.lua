-- Custom terminal buffer previewer for Telescope
local previewers = require 'telescope.previewers'
local putils = require 'telescope.previewers.utils'

-- Helper function to strip ANSI color codes for display
local function strip_ansi_colors(str)
  -- This pattern matches ANSI escape sequences for colors
  return str:gsub('\27%[[0-9;]*m', '')
end

-- Terminal buffer previewer for Telescope
local TerminalBufferPreviewer = {}

-- Create a new terminal buffer previewer
function TerminalBufferPreviewer:new(opts)
  opts = opts or {}

  return previewers.new_buffer_previewer {
    title = 'Terminal Preview',
    -- Use a dynamic title that shows the buffer name
    dyn_title = function(_, entry)
      return entry.filename or 'Terminal Buffer'
    end,

    -- Define the preview behavior for terminal buffers
    define_preview = function(self, entry, status)
      -- Get the buffer number from options or use the current buffer
      local terminal_bufnr = opts.bufnr or vim.api.nvim_get_current_buf()

      -- Verify it's a terminal buffer
      if not vim.api.nvim_buf_is_valid(terminal_bufnr) or vim.api.nvim_get_option_value('buftype', { buf = terminal_bufnr }) ~= 'terminal' then
        putils.set_preview_message(self.state.bufnr, status.preview_win, 'Not a valid terminal buffer')
        return
      end

      -- Get buffer lines and info for context
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

      local context_lines = vim.api.nvim_buf_get_lines(terminal_bufnr, start_line, end_line, false)

      -- Format context lines with cursor indicator but no line numbers
      for i, line in ipairs(context_lines) do
        local ctx_lnum = start_line + i
        local prefix = ctx_lnum == lnum and '➤' or ' '

        -- Strip ANSI color codes for display
        local display_line = strip_ansi_colors(line)

        -- Format with cursor indicator but no line numbers
        table.insert(output, string.format('%s %s', prefix, display_line))
      end

      -- Set the output to the preview buffer
      vim.api.nvim_buf_set_lines(self.state.bufnr, 0, -1, false, output)

      -- Find the index of the selected line (should be the one with cursor indicator)
      local highlight_line_idx = nil
      for i, line in ipairs(output) do
        -- Look for the line that has our cursor indicator
        if line:match '^➤%s' then
          highlight_line_idx = i - 1 -- 0-indexed in API
          break
        end
      end

      -- Highlight the selected line if we found it
      if highlight_line_idx then
        vim.api.nvim_buf_add_highlight(self.state.bufnr, 0, 'TelescopePreviewMatch', highlight_line_idx, 0, -1)
      end

      -- Set the filetype for better highlighting
      -- Try to detect if this is a shell terminal or other type
      local term_content = table.concat(context_lines, '\n')

      -- Detect filetype from content
      local detected_ft = 'terminal'
      if term_content:match 'bash' or term_content:match 'zsh' then
        detected_ft = 'bash'
      elseif term_content:match 'irb' or term_content:match 'pry' then
        detected_ft = 'ruby'
      end

      -- Apply detected filetype
      vim.api.nvim_set_option_value('filetype', detected_ft, { buf = self.state.bufnr })

      -- Apply the same highlighting as the grep preview window
      vim.api.nvim_set_option_value('winhl', 'Normal:TelescopePreviewNormal', { win = status.preview_win })
      vim.api.nvim_set_option_value('signcolumn', 'no', { win = status.preview_win })
      vim.api.nvim_set_option_value('foldlevel', 100, { win = status.preview_win })
      vim.api.nvim_set_option_value('wrap', false, { win = status.preview_win })

      -- Add syntax highlighting for common terminal elements
      local namespace = vim.api.nvim_create_namespace 'telescope_terminal_preview'

      -- Apply highlighting to cursor indicators
      for i, line in ipairs(output) do
        -- Highlight cursor indicator
        vim.api.nvim_buf_add_highlight(self.state.bufnr, namespace, 'Comment', i - 1, 0, 1)

        -- Highlight command prompts like $, >, etc.
        if line:match '[%$#>]%s' then
          local prompt_start = line:find('[%$#>]')
          if prompt_start then
            local prompt_end = prompt_start + 1
            vim.api.nvim_buf_add_highlight(self.state.bufnr, namespace, 'TelescopePromptPrefix', i - 1, prompt_start, prompt_end)
          end
        end
      end
    end,
  }
end

return TerminalBufferPreviewer
