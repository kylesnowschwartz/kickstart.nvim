-- Basedpyright LSP configuration
-- Modern Python language server with enhanced type checking (2024-2025)
-- Based on Pyright but includes Pylance features and better performance

local function find_python_executable(root_dir)
  -- Check for virtual environment first
  local venv_paths = {
    root_dir .. '/.venv/bin/python',
    root_dir .. '/venv/bin/python',
    root_dir .. '/.virtualenv/bin/python',
  }

  for _, path in ipairs(venv_paths) do
    if vim.fn.executable(path) == 1 then
      return path
    end
  end

  -- Check for conda environment
  local conda_prefix = os.getenv 'CONDA_PREFIX'
  if conda_prefix then
    local conda_python = conda_prefix .. '/bin/python'
    if vim.fn.executable(conda_python) == 1 then
      return conda_python
    end
  end

  -- Fallback to system python
  return vim.fn.exepath 'python3' or vim.fn.exepath 'python' or 'python'
end

return {
  cmd = { 'basedpyright-langserver', '--stdio' },
  filetypes = { 'python' },
  root_markers = {
    'pyproject.toml',
    'setup.py',
    'setup.cfg',
    'requirements.txt',
    'Pipfile',
    'pyrightconfig.json',
    '.git',
  },

  -- Dynamic python path detection
  on_init = function(client, _)
    local root = client.config.root_dir
    if root then
      local python_path = find_python_executable(root)
      client.config.settings = client.config.settings or {}
      client.config.settings.python = client.config.settings.python or {}
      client.config.settings.python.pythonPath = python_path

      vim.notify('Using Python: ' .. python_path, vim.log.levels.INFO)
    end
    return true
  end,

  settings = {
    python = {
      analysis = {
        -- Enhanced type checking
        autoSearchPaths = true,
        useLibraryCodeForTypes = true,

        -- Performance optimization - only check open files by default
        diagnosticMode = 'openFilesOnly', -- or 'workspace' for full project checking

        -- Type checking strictness
        typeCheckingMode = 'standard', -- 'off', 'basic', 'standard', 'strict'

        -- Include/exclude patterns
        include = {},
        exclude = {
          '**/node_modules',
          '**/__pycache__',
          '.git',
          '**/*.pyc',
        },

        -- Additional features
        autoImportCompletions = true,
        completeFunctionParens = true,

        -- Stub path for better type information
        stubPath = vim.fn.stdpath 'data' .. '/lazy/python-type-stubs/stubs',
      },

      -- Linting options (Basedpyright includes enhanced diagnostics)
      linting = {
        enabled = true,
        pylintEnabled = false, -- Use external linter if preferred
        mypyEnabled = false, -- Basedpyright provides better type checking
      },
    },

    -- Basedpyright specific features
    basedpyright = {
      analysis = {
        -- Enable experimental features from Pylance
        enableExperimentalFeatures = true,

        -- Enhanced auto-imports
        autoImportUserSymbols = true,
        autoImportCompletions = true,
      },
    },
  },
}
