# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Architecture Overview

This is a sophisticated Neovim configuration based on kickstart.nvim with extensive customizations for modern development workflows. The configuration follows a modular architecture with clear separation of concerns.

### Key Components

- **Plugin Manager**: lazy.nvim with lazy loading for optimal startup performance
- **LSP**: Native Neovim 0.11+ LSP configuration with individual server configs in `lsp/` directory
- **Completion**: blink.cmp with LuaSnip snippets, configured for manual triggering
- **Fuzzy Finding**: Telescope with multiple extensions (fzf-native, ui-select, undo, live-grep-args)
- **Session Management**: auto-session with claude-code integration
- **Ruby Development**: Specialized setup with vim-rails, vim-test, and ruby-lsp

### Directory Structure

```
init.lua                    # Main entry point with basic Vim options and plugin loading
lua/custom/                 # Custom configurations
├── keymaps.lua            # All custom keybindings
├── ghostty.lua            # Ghostty terminal integration
└── plugins/               # Custom plugin configurations
    ├── init.lua           # Plugin definitions and setup
    ├── telescope/         # Telescope-related configurations
    └── auto-session/      # Session management helpers
lua/lsp/                   # LSP server configurations
├── init.lua               # Main LSP setup with blink.cmp
├── ruby_ls.lua            # Ruby LSP configuration
├── ts_ls.lua              # TypeScript LSP configuration
├── lua_ls.lua             # Lua LSP configuration
├── bash_ls.lua            # Bash LSP configuration
└── html_ls.lua            # HTML LSP configuration
lsp/                       # Legacy LSP configs (individual server files)
```

## Keybinding System

The configuration uses a structured keybinding approach with `<Space>` as the leader key, organized by functional categories:

### File Operations (`<leader>f`)

- `<leader>fed` - Edit init.lua
- `<leader>fec` - Edit custom/keymaps.lua
- `<leader>fep` - Edit custom/plugins/init.lua
- `<leader>fs` - Save current file
- `<leader>fS` - Save all files
- `<leader>fyy` - Yank relative file path
- `<leader>fyY` - Yank absolute file path

### Buffer Management (`<leader>b`)

- `<leader>bd` - Kill buffer (preserve window)
- `<leader>bn` - Next buffer
- `<leader>bp` - Previous buffer
- `<leader>bR` - Reload current buffer
- `<leader>bs` - Create scratch buffer
- `<leader>bb` - Telescope buffer picker

### Search Operations (`<leader>s`)

- `<leader>sf` / `<leader>ff` - Find files
- `<leader>sg` / `<leader>s/` - Live grep with args
- `<leader>ss` / `<leader>/` - Search in current buffer (Swiper)
- `<leader>sr` - Resume last search
- `<leader>s.` - Recent files
- `<leader>sh` - Help tags
- `<leader>sk` - Keymaps

### Window Management (`<leader>w`)

- `<leader>w-` - Horizontal split
- `<leader>w/` - Vertical split
- `<leader>wh/j/k/l` - Navigate windows
- `<leader>wH/J/K/L` - Move windows
- `<leader>wd` - Close window
- `<leader>wm` - Maximize window

### Git Operations (`<leader>g`)

- `<leader>gf` / `<leader>pf` - Git files
- `<leader>gs` - Git status
- `<leader>gc` - Git commits
- `<leader>gb` - Git buffer commits
- `<leader>gB` - Git branches
- `<leader>gg` - Neogit
- `<leader>gyy` - Git yank URL

### Ruby Development (`<leader>r`)

- `<leader>rt` - Run test file
- `<leader>rs` - Run single test
- `<leader>rl` - Run last test
- `<leader>ra` - Run all tests

### Diagnostics/Trouble (`<leader>x`)

- `<leader>xx` - Toggle Trouble
- `<leader>xd` - Document diagnostics
- `<leader>xw` - Workspace diagnostics
- `<leader>xr` - LSP references

## LSP Configuration

### Enabled Language Servers

- **ruby_ls**: Ruby development with bundle gem paths integration
- **ts_ls**: TypeScript/JavaScript development
- **lua_ls**: Lua development with Neovim API support
- **bash_ls**: Bash scripting
- **html_ls**: HTML development

### LSP Keybindings (available when LSP is attached)

- `<leader>rn` - Rename symbol
- `<leader>ca` - Code actions
- `gD` - Go to declaration
- Telescope integration for references, definitions, implementations

### Formatting

- `<leader>F` - Format buffer using conform.nvim
- Auto-format on save (disabled for C/C++)
- Ruby: rubocop via bundle exec
- JS/TS: eslint_d
- Lua: stylua
- YAML/JSON/Markdown: prettier

## Ruby Development Workflow

### Testing Commands

The configuration includes vim-test integration:

- `<leader>rt` - Test current file
- `<leader>rs` - Test nearest (single test)
- `<leader>rl` - Test last
- `<leader>ra` - Test suite (all tests)

### Rails Support

vim-rails provides navigation commands:

- `:Emodel` - Jump to model
- `:Eview` - Jump to view
- `:Econtroller` - Jump to controller
- `:Ehelper` - Jump to helper
- `:Emigration` - Jump to migration

### Ruby LSP Features

- Bundle gem paths automatically detected
- Rubocop integration for diagnostics and formatting
- Experimental features enabled
- Full feature set: completion, hover, diagnostics, formatting, code actions

## Terminal Integration

### Claude Code Integration

- `<leader>cc` - Toggle Claude Code
- `<leader>cC` - Claude Code with continue flag
- `<leader>cR` - Resume Claude Code
- `<leader>cV` - Verbose Claude Code
- Auto-session integration preserves claude-code terminal state

### Terminal Commands

- `<leader>tt` - Open terminal
- `<Esc>` in terminal - Enter normal mode
- `<Esc><Esc>` in terminal - Close terminal

## Session Management

Auto-session is configured with:

- Automatic session save/restore per directory
- Scratch buffer cleanup before save
- Claude-code terminal state preservation
- Suppressed directories: `~/`, `~/Projects`, `~/Downloads`, `~/Code`, `/`

## Plugin Ecosystem

### Essential Plugins

- **Telescope**: Fuzzy finding with extensions (fzf-native, ui-select, undo, live-grep-args)
- **Trouble**: Diagnostics and quickfix list management
- **Gitsigns**: Git integration with current line blame
- **Which-key**: Keybinding discovery and documentation
- **Mini.nvim**: Multiple utilities (surround, statusline, ai textobjects, trailspace)
- **Treesitter**: Syntax highlighting and code analysis
- **Auto-session**: Session management
- **Yazi**: File manager integration

### Development Tools

- **Neogit**: Git interface
- **Gitlinker**: Generate and open Git URLs
- **Cronex**: Cron expression documentation
- **Colorizer**: Color preview in code

## File Manager Integration

Yazi file manager is integrated with:

- `<leader>f-` - Open yazi at current file
- `<leader>fcw` - Open yazi in working directory
- `<leader>fcr` - Resume last yazi session

## Dependencies

### Required External Tools

- `git`, `make`, `unzip`, C compiler
- `ripgrep` (for telescope grep)
- Clipboard tool (platform-dependent)
- Nerd Font (optional, controlled by `vim.g.have_nerd_font`)

### Language-Specific Dependencies

- **Ruby**: `ruby-lsp`, `rubocop` (via Bundle)
- **JavaScript/TypeScript**: `eslint_d`
- **Lua**: `stylua`
- **General**: `prettier` for YAML/JSON/Markdown

## Customization Points

### Adding New LSP Servers

1. Create configuration file in `lsp/` directory
2. Add `vim.lsp.enable 'server_name'` to `lua/lsp/init.lua:215-220`
3. Add formatter configuration to `lua/lsp/init.lua:252-262` if needed

### Adding New Keybindings

- Edit `lua/custom/keymaps.lua` following the established category structure
- Update which-key groups in `init.lua:201-228` for documentation

### Modifying Plugin Configuration

- Plugin definitions: `lua/custom/plugins/init.lua`
- Telescope configuration: `lua/custom/plugins/telescope/init.lua`
- LSP and completion: `lua/lsp/init.lua`
