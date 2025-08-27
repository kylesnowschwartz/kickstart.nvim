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

Custom keymaps are defined in @/Users/kyle/.config/nvim/lua/custom/keymaps.lua

### File Operations (`<leader>f`)

### Buffer Management (`<leader>b`)

### Search Operations (`<leader>s`)

### Window Management (`<leader>w`)

### Git Operations (`<leader>g`)

### Diagnostics/Trouble (`<leader>x`)

## LSP Configuration

### Enabled Language Servers

- **ruby_ls**: Ruby development with bundle gem paths integration
- **ts_ls**: TypeScript/JavaScript development
- **lua_ls**: Lua development with Neovim API support
- **bash_ls**: Bash scripting
- **html_ls**: HTML development

### LSP Keybindings (available when LSP is attached)

### Formatting

- `<leader>F` - Format buffer using conform.nvim
- Auto-format on save (disabled for C/C++)
- Ruby: rubocop via bundle exec
- JS/TS: eslint_d
- Lua: stylua
- YAML/JSON/Markdown: prettier

## Terminal Integration

### Claude Code Integration

### Terminal Commands

## Session Management

Auto-session is configured with:

- Automatic session save/restore per directory
- Scratch buffer cleanup before save
- Claude-code terminal state preservation
- Suppressed directories: `~/`, `~/Projects`, `~/Downloads`, `~/Code`, `/`

## Plugin Ecosystem

### Essential Plugins

- **Telescope**: Fuzzy finding with extensions (fzf-native, ui-select, undo, live-grep-args)
- **Gitsigns**: Git integration with current line blame
- **Which-key**: Keybinding discovery and documentation
- **Mini.nvim**: Multiple utilities (surround, statusline, ai textobjects, trailspace)
- **Treesitter**: Syntax highlighting and code analysis
- **Auto-session**: Session management
- **Yazi**: File manager integration
- **ClaudeCode**: File manager integration

## File Manager Integration

Yazi file manager and neo-tree

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
