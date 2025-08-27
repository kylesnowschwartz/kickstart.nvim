# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Development Commands

### Plugin Management

- **Install/Update Plugins**: `:Lazy` - Opens lazy.nvim interface
- **Check Plugin Health**: `:checkhealth lazy` - Diagnose plugin issues
- **Profile Startup**: `:Lazy profile` - Analyze startup performance

### LSP Development

- **Check LSP Status**: `:LspInfo` - View attached language servers
- **Restart LSP**: `:LspRestart` - Restart all LSP clients
- **Format Code**: `<leader>FF` - Format current buffer with conform.nvim
- **Code Actions**: Built-in via tiny-code-action.nvim with Telescope picker

### Session Management

- **Auto-restore**: Sessions automatically save/restore per directory
- **Manual Session**: Use auto-session commands for manual control

### Configuration Testing

- **Reload Config**: Restart Neovim (no hot-reload with lazy.nvim)
- **Check Health**: `:checkhealth` - Comprehensive system health check

## Architecture Overview

This is a sophisticated Neovim configuration based on kickstart.nvim with extensive customizations for modern development workflows. The configuration follows a modular architecture with clear separation of concerns.

### Key Components

- **Plugin Manager**: lazy.nvim with lazy loading for optimal startup performance
- **LSP**: Native Neovim 0.11+ LSP configuration with individual server configs in `lsp/` directory
- **Completion**: blink.cmp with LuaSnip snippets, configured for manual triggering (super-tab preset)
- **Fuzzy Finding**: Telescope with multiple extensions (fzf-native, ui-select, undo, live-grep-args)
- **Session Management**: auto-session with claude-code integration and scratch buffer cleanup
- **Ruby Development**: Specialized setup with vim-rails, vim-test, and ruby-lsp
- **File Management**: Yazi integration for file browsing
- **Git Integration**: Neogit, tiny-git, gitsigns, and gitlinker for comprehensive git workflow

### Directory Structure

```
init.lua                    # Main entry point with basic Vim options and plugin loading
lua/custom/                 # Custom configurations
├── keymaps.lua            # All custom keybindings organized by category
├── ghostty.lua            # Ghostty terminal integration
└── plugins/               # Custom plugin configurations
    ├── init.lua           # Plugin definitions and setup
    ├── claudecode.lua     # Claude Code integration
    ├── yazi.lua           # File manager integration
    ├── telescope/         # Telescope-related configurations
    │   ├── init.lua       # Main telescope config
    │   └── lsp_keymaps.lua # LSP-specific telescope keymaps
    └── auto-session/      # Session management helpers
        └── helpers.lua    # Session cleanup utilities
lua/lsp/                   # LSP server configurations
├── init.lua               # Main LSP setup with blink.cmp and conform.nvim
├── ruby_ls.lua            # Ruby LSP with bundle gem paths
├── ts_ls.lua              # TypeScript LSP configuration
├── lua_ls.lua             # Lua LSP with Neovim API support
├── bash_ls.lua            # Bash LSP configuration
└── html_ls.lua            # HTML LSP configuration
lsp/                       # Legacy LSP configs (individual server files)
```

## Keybinding System

The configuration uses a structured keybinding approach with `<Space>` as the leader key, organized by functional categories. All custom keymaps are defined in `lua/custom/keymaps.lua` and documented through which-key.

### Key Categories

- **File Operations** (`<leader>f`): File management, save, config editing
- **Buffer Management** (`<leader>b`): Buffer navigation, scratch buffers, kill operations
- **Search Operations** (`<leader>s`): Search, replace, telescope functions
- **Window Management** (`<leader>w`): Splits, navigation, resize operations
- **Git Operations** (`<leader>g`): Neogit, tiny-git integration
- **Terminal** (`<leader>t`): Terminal management via snacks.nvim
- **Formatting** (`<leader>F`): Text formatting, alignment, modelines
- **Diagnostics/Trouble** (`<leader>x`): LSP diagnostics, quickfix, references

### Special Features

- **Smart Terminal Escape**: Double `<Esc><Esc>` within 200ms switches terminal to normal mode
- **Macro Remapping**: `q` disabled, `<leader>M` and `M` for macro recording
- **Surround Operations**: `cs` (change), `ds` (delete), `S` (visual surround)
- **File Manager**: Yazi integration with `<leader>y` prefix

## LSP Configuration

### Native LSP (Neovim 0.11+)

This configuration uses Neovim's native LSP system with vim.lsp.config() and vim.lsp.enable():

### Enabled Language Servers

- **ruby_ls**: Ruby development with bundle gem paths integration
- **ts_ls**: TypeScript/JavaScript development
- **lua_ls**: Lua development with Neovim API support
- **bash_ls**: Bash scripting
- **html_ls**: HTML development

### Completion System

- **Engine**: blink.cmp with super-tab preset
- **Manual Trigger**: Completion requires manual triggering (`<Tab>` or `<C-Space>`)
- **Snippets**: LuaSnip integration with friendly-snippets
- **Sources**: LSP, path, snippets, lazydev, buffer, cmdline

### Formatting (conform.nvim)

- **Auto-format on save** (disabled for C/C++)
- **Ruby**: rubocop via `bundle exec`
- **JS/TS**: eslint_d → prettier (stops after first success)
- **Lua**: stylua
- **Python**: isort → black
- **Shell**: shfmt (2-space indent)
- **YAML/JSON/Markdown**: prettier (respects textwidth for markdown)

### Code Actions

- **Engine**: tiny-code-action.nvim
- **Picker**: Telescope integration
- **Diff Backend**: delta with side-by-side view
- **Visual Signs**: Nerd Font icons for different action types

## Terminal Integration

- **Terminal Manager**: snacks.nvim with smart escape behavior
- **Claude Code Integration**: Session state preservation via auto-session
- **Keybindings**: `<leader>tt` opens terminal, `<C-n>` for normal mode in terminal

## Session Management

Auto-session is configured with:

- Automatic session save/restore per directory
- Scratch buffer cleanup before save
- Claude-code terminal state preservation
- Suppressed directories: `~/`, `~/Projects`, `~/Downloads`, `~/Code`, `/`

## Plugin Ecosystem

### Essential Plugins

- **Telescope**: Fuzzy finding with extensions (fzf-native, ui-select, undo, live-grep-args)
- **Treesitter**: Syntax highlighting for bash, c, diff, html, lua, markdown, query, vim, ruby
- **Mini.nvim**: Collection of utilities (surround, statusline, ai textobjects, trailspace)
- **Auto-session**: Session management with scratch buffer cleanup
- **Trouble**: Diagnostic and reference viewer with split/float modes
- **Snacks**: Terminal management with smart escape behavior

### Development Tools

- **Gitsigns**: Git integration with current line blame
- **Neogit**: Full-featured Git interface with diffview integration
- **Tiny-git**: Interactive staging, smart commits, push operations
- **Gitlinker**: Generate and browse GitHub URLs for code sections
- **Vim-rails**: Ruby on Rails development enhancements
- **Vim-test**: Test runner with Neovim terminal strategy

### File Management

- **Yazi**: Modern file manager with image preview support
- **Neo-tree**: Traditional file tree explorer (kickstart plugin)
- **Image.nvim**: Direct image viewing in Neovim with ueberzug backend

### Search and Replace

- **Spectre**: Visual search and replace with ripgrep backend
- **Live-grep-args**: Advanced Telescope grep with argument support

### Development Utilities

- **Which-key**: Keybinding discovery with category documentation
- **Guess-indent**: Automatic indentation detection
- **Colorizer**: Color code highlighting
- **Todo-comments**: Highlight TODO, FIXME, etc. in comments
- **Tabular**: Text alignment tool
- **Claude-fzf-history**: Claude Code conversation history browser

## File Manager Integration

### Yazi Configuration

- Modern TUI file manager with image preview
- Keybindings under `<leader>y` prefix
- Integration with Neovim's buffer system

### Neo-tree (Kickstart)

- Traditional sidebar file explorer
- Available as fallback option

## Customization Points

### Adding New LSP Servers

1. Create configuration file in `lsp/` directory (e.g., `lsp/server_name.lua`)
2. Add `vim.lsp.enable 'server_name'` to `lua/lsp/init.lua` around lines 230-236
3. Add formatter configuration to `formatters_by_ft` in `lua/lsp/init.lua:269-286` if needed
4. Install formatter via Mason if required (see `ensure_installed` in `lua/lsp/init.lua:25-32`)

### Adding New Keybindings

1. Edit `lua/custom/keymaps.lua` following the established category structure
2. Update which-key groups in `init.lua:249-278` for proper documentation
3. Consider the existing keybinding patterns and prefixes

### Modifying Plugin Configuration

- **Plugin definitions**: `lua/custom/plugins/init.lua`
- **Telescope configuration**: `lua/custom/plugins/telescope/init.lua`
- **LSP and completion**: `lua/lsp/init.lua`
- **Auto-session helpers**: `lua/custom/plugins/auto-session/helpers.lua`
- **Yazi integration**: `lua/custom/plugins/yazi.lua`

### Ruby Development Workflow

The configuration includes specialized Ruby development features:

- **Rubocop formatting** via `bundle exec` with auto-format on save
- **Ruby LSP** with gem path integration
- **Rails commands** via vim-rails (`:Emodel`, `:Econtroller`, etc.)
- **Test runner** with vim-test supporting RSpec and Minitest
