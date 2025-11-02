local M = {}

---Detect the default base branch for the git repository
---Tries the following strategies in order:
---1. Query origin/HEAD (the authoritative default branch)
---2. Check if origin/main exists
---3. Check if origin/master exists
---@return string|nil The base branch name (e.g., "origin/main") or nil if not found
function M.get_base_branch()
  -- Strategy 1: Get the default branch from origin/HEAD (most reliable)
  local handle = io.popen 'git symbolic-ref refs/remotes/origin/HEAD 2>/dev/null'
  if handle then
    local result = handle:read '*a'
    handle:close()
    local base_branch = result:match 'refs/remotes/(.+)'
    if base_branch and base_branch ~= '' then
      base_branch = base_branch:gsub('\n', '')
      return base_branch
    end
  end

  -- Strategy 2: Fallback to checking if origin/main exists
  local test_main = io.popen 'git rev-parse --verify origin/main 2>/dev/null'
  if test_main then
    local main_result = test_main:read '*a'
    test_main:close()
    if main_result ~= '' then
      return 'origin/main'
    end
  end

  -- Strategy 3: Fallback to checking if origin/master exists
  local test_master = io.popen 'git rev-parse --verify origin/master 2>/dev/null'
  if test_master then
    local master_result = test_master:read '*a'
    test_master:close()
    if master_result ~= '' then
      return 'origin/master'
    end
  end

  -- No valid base branch found
  return nil
end

---Open diffview intelligently based on repository state
---If a remote base branch exists, compare against it (origin/main...HEAD)
---Otherwise, show local working tree changes (DiffviewOpen with no args)
function M.open_diff()
  local base_branch = M.get_base_branch()
  if base_branch then
    -- Compare against remote base branch
    vim.cmd('DiffviewOpen ' .. base_branch .. '...HEAD')
  else
    -- No remote or no base branch found - show local changes
    vim.cmd 'DiffviewOpen'
  end
end

return M
