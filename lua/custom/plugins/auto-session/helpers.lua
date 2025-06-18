local M = {}

local function log_debug(message)
  local output = type(message) == 'table' and vim.inspect(message) or tostring(message)
  vim.notify('[Claude Terminal Restore] ' .. output, vim.log.levels.INFO)
end

---Get active claude-code instances from the plugin's internal state
---@return table List of active claude-code instances with their details
function M.get_claude_code_instances()
  local ok, claude_code = pcall(require, 'claude-code')
  if not ok or not claude_code.claude_code or not claude_code.claude_code.instances then
    log_debug 'Claude-code plugin not available or no instances'
    return {}
  end

  local active_instances = {}
  for instance_id, bufnr in pairs(claude_code.claude_code.instances) do
    if bufnr and vim.api.nvim_buf_is_valid(bufnr) then
      -- Check if the buffer still has a window (is visible)
      local win_ids = vim.fn.win_findbuf(bufnr)
      local is_visible = #win_ids > 0

      table.insert(active_instances, {
        instance_id = instance_id,
        bufnr = bufnr,
        is_visible = is_visible,
        current_instance = claude_code.claude_code.current_instance == instance_id,
      })
      log_debug('Found active claude-code instance: ' .. instance_id .. ' (buffer: ' .. bufnr .. ', visible: ' .. tostring(is_visible) .. ')')
    end
  end

  log_debug('Total active claude-code instances found: ' .. #active_instances)
  return active_instances
end

function M.cleanup_scratch_buffers()
  for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_is_valid(bufnr) and vim.b[bufnr] and vim.b[bufnr].scratch_buffer then
      vim.api.nvim_buf_delete(bufnr, { force = true })
    end
  end
end

---Generate commands to save claude-code instances state
---@return table List of vim commands to recreate claude-code instances
function M.save_claude_code_state()
  local ok, claude_code = pcall(require, 'claude-code')
  if not ok or not claude_code.claude_code or not claude_code.claude_code.instances then
    log_debug 'Claude-code plugin not available or no instances to save'
    return {}
  end

  local commands = {}
  local active_instances = M.get_claude_code_instances()

  if #active_instances == 0 then
    log_debug 'No active claude-code instances to save'
    return {}
  end

  -- Save the current instance if there is one
  if claude_code.claude_code.current_instance then
    table.insert(commands, 'let g:claude_code_restore_current_instance = "' .. claude_code.claude_code.current_instance .. '"')
  end

  -- Generate restoration commands for each instance
  for _, instance in ipairs(active_instances) do
    log_debug('Saving claude-code instance: ' .. instance.instance_id .. ' (visible: ' .. tostring(instance.is_visible) .. ')')

    -- Create a command that will restore this specific instance
    -- We'll use a lua command to properly recreate the instance
    local restore_cmd = string.format(
      'lua require("custom.plugins.auto-session.helpers").restore_claude_code_instance("%s", %s)',
      instance.instance_id,
      tostring(instance.is_visible)
    )
    table.insert(commands, restore_cmd)
  end

  log_debug('Generated ' .. #commands .. ' claude-code restoration commands')
  return commands
end

---Restore a specific claude-code instance
---@param instance_id string The instance identifier to restore
---@param should_be_visible boolean Whether the instance should be visible
function M.restore_claude_code_instance(instance_id, should_be_visible)
  log_debug('Restoring claude-code instance: ' .. instance_id .. ' (visible: ' .. tostring(should_be_visible) .. ')')

  local ok, claude_code = pcall(require, 'claude-code')
  if not ok then
    log_debug 'Claude-code plugin not available for restoration'
    return
  end

  -- Let claude-code plugin handle its own buffer management

  -- Set the current instance to the one we're restoring
  claude_code.claude_code.current_instance = instance_id

  -- If this instance should be visible, toggle it to create and show it
  if should_be_visible then
    -- Use vim.schedule to ensure this happens after session restoration is complete
    vim.schedule(function()
      -- Check if session restoration created a buffer with the expected claude-code name
      -- Session restoration can create non-terminal buffers that conflict with
      -- the claude-code plugin's terminal buffer naming
      local expected_buffer_name = 'claude-code-' .. instance_id:gsub('[^%w%-_]', '-')

      for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
        if vim.api.nvim_buf_is_valid(bufnr) then
          local bufname = vim.api.nvim_buf_get_name(bufnr)

          -- Only remove buffers that:
          -- 1. Have exactly the expected claude-code buffer name as filename (not path)
          -- 2. Are not terminal buffers (session artifacts)
          -- 3. Are not already managed by claude-code plugin
          local filename = vim.fn.fnamemodify(bufname, ':t')
          if filename == expected_buffer_name and vim.bo[bufnr].buftype ~= 'terminal' then
            -- Double-check this buffer is not in the plugin's instances table
            local ok, claude_code = pcall(require, 'claude-code')
            local is_managed = false
            if ok and claude_code.claude_code and claude_code.claude_code.instances then
              for _, managed_bufnr in pairs(claude_code.claude_code.instances) do
                if managed_bufnr == bufnr then
                  is_managed = true
                  break
                end
              end
            end

            if not is_managed then
              log_debug('Removing session-restored buffer that conflicts with claude-code naming: ' .. bufname)
              vim.api.nvim_buf_delete(bufnr, { force = true })
            end
          end
        end
      end

      -- Use ClaudeCodeContinue command to resume with --continue flag
      vim.cmd 'ClaudeCodeContinue'
    end)
  end
end

function M.restore_claude_code()
  log_debug 'restore_claude_code called - restoration handled by saved commands'

  if vim.g.claude_code_restore_current_instance then
    local ok, claude_code = pcall(require, 'claude-code')
    if ok and claude_code.claude_code then
      claude_code.claude_code.current_instance = vim.g.claude_code_restore_current_instance
      log_debug('Restored current claude-code instance: ' .. vim.g.claude_code_restore_current_instance)
    end
    vim.g.claude_code_restore_current_instance = nil
  end
end

return M
