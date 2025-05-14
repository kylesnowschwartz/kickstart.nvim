local M = {}

local inspect = vim.inspect

local function log_debug(message)
  local output = type(message) == 'table' and inspect(message) or tostring(message)
  vim.notify('[Claude Terminal Restore] ' .. output, vim.log.levels.INFO)
end

function M.detect_claude_code_terminal()
  for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_is_valid(bufnr) then
      local bufname = vim.api.nvim_buf_get_name(bufnr)
      if bufname:match 'claude%-code' then
        return true, bufnr
      end
    end
  end
  return false, nil
end

function M.cleanup_scratch_buffers()
  for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_is_valid(bufnr) and vim.b[bufnr] and vim.b[bufnr].scratch_buffer then
      vim.api.nvim_buf_delete(bufnr, { force = true })
    end
  end
end

function M.restore_claude_code()
  -- Using vim.defer_fn to ensure the session is fully restored before we manipulate buffers
  vim.defer_fn(function()
    if vim.g.had_claude_code_buffer == 1 then
      log_debug 'Session had claude-code terminal, restoring...'

      -- Detect if there's already a claude-code terminal (from the session)
      local has_claude, bufnr = M.detect_claude_code_terminal()

      -- If we found an existing claude-code terminal, delete it first
      if has_claude and bufnr then
        log_debug('Deleting existing claude-code terminal buffer: ' .. bufnr)
        vim.api.nvim_buf_delete(bufnr, { force = true })
      end

      -- Use claude-code.nvim to create a new claude-code terminal with continue flag
      vim.cmd('ClaudeCodeContinue')

      -- Verify that the terminal was created successfully
      vim.defer_fn(function()
        local success, new_bufnr = M.detect_claude_code_terminal()
        if success then
          log_debug('Claude Code terminal successfully restored with buffer: ' .. new_bufnr)
        else
          log_debug 'Failed to restore Claude Code terminal'
        end
      end, 300)
    end
  end, 100) -- Increased delay to ensure session is fully loaded
end

return M
