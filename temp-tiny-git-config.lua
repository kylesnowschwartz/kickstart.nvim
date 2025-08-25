-- default config
--
--
--
--
--
--
--
require('tinygit').setup {
  stage = { -- requires `telescope.nvim`
    contextSize = 1, -- larger values "merge" hunks. 0 is not supported.
    stagedIndicator = '󰐖',
    keymaps = { -- insert & normal mode
      stagingToggle = '<Space>', -- stage/unstage hunk
      gotoHunk = '<CR>',
      resetHunk = '<C-r>',
    },
    moveToNextHunkOnStagingToggle = false,

    -- accepts the common telescope picker config
    telescopeOpts = {
      layout_strategy = 'horizontal',
      layout_config = {
        horizontal = {
          preview_width = 0.65,
          height = { 0.7, min = 20 },
        },
      },
    },
  },
  commit = {
    keepAbortedMsgSecs = 300,
    border = getBorder(), -- `vim.o.winborder` on nvim 0.11, otherwise "rounded"
    spellcheck = false, -- vim's builtin spellcheck
    wrap = 'hard', ---@type "hard"|"soft"|"none"
    keymaps = {
      normal = { abort = 'q', confirm = '<CR>' },
      insert = { confirm = '<C-CR>' },
    },
    subject = {
      -- automatically apply formatting to the subject line
      autoFormat = function(subject) ---@type nil|fun(subject: string): string
        subject = subject:gsub('%.$', '') -- remove trailing dot https://commitlint.js.org/reference/rules.html#body-full-stop
        return subject
      end,

      -- disallow commits that do not use an allowed type
      enforceType = false,
			-- stylua: ignore
			types = {
				"fix", "feat", "chore", "docs", "refactor", "build", "test",
				"perf", "style", "revert", "ci", "break",
			},
    },
    body = {
      enforce = false,
    },
  },
  push = {
    preventPushingFixupCommits = false,
    confirmationSound = true, -- currently macOS only, PRs welcome

    -- If pushed commits contain references to issues, open them in the browser
    -- (not used when force-pushing).
    openReferencedIssues = false,
  },
  github = {
    icons = {
      openIssue = '🟢',
      closedIssue = '🟣',
      notPlannedIssue = '⚪',
      openPR = '🟩',
      mergedPR = '🟪',
      draftPR = '⬜',
      closedPR = '🟥',
    },
  },
  history = {
    diffPopup = {
      width = 0.8, -- between 0-1
      height = 0.8,
      border = getBorder(), -- `vim.o.winborder` on nvim 0.11, otherwise "rounded"
    },
    autoUnshallowIfNeeded = false,
  },
  appearance = {
    mainIcon = '󰊢',
    backdrop = {
      enabled = true,
      blend = 40, -- 0-100
    },
  },
  statusline = {
    blame = {
      ignoreAuthors = {}, -- hide component if from these authors (useful for bots)
      hideAuthorNames = {}, -- show component, but hide names (useful for your own name)
      maxMsgLen = 40,
      icon = 'ﰖ',
    },
    branchState = {
      icons = {
        ahead = '󰶣',
        behind = '󰶡',
        diverge = '󰃻',
      },
    },
  },
}
