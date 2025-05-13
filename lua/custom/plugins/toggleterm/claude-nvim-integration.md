# Claude Code Integration with Neovim

This document describes how Claude Code is integrated with Neovim using ToggleTerm to provide a smooth experience with normal mode as the default.

## Overview

Claude Code is a CLI tool that provides AI assistance directly in your terminal. This integration allows Claude Code to run in a dedicated Neovim terminal buffer that:

1. Always stays in normal mode when navigating to it from other buffers
2. Preserves session state between Neovim restarts
3. Provides convenient keyboard shortcuts for controlling the terminal

## Implementation Details

The integration uses the following components:

1. **ToggleTerm.nvim** - A Neovim plugin for managing terminal windows with custom behavior
2. **Auto-session** - For preserving terminal state between sessions

### Key Files

- `lua/custom/plugins/toggleterm/init.lua` - Main ToggleTerm configuration for Claude Code
- `lua/custom/plugins/init.lua` - Plugin management and integration
- `lua/custom/plugins/auto-session/helpers.lua` - Session restoration helpers

## Features

### Terminal Behavior

- Terminal starts and remains in normal mode for easier navigation
- Uses a vertical split by default, sized to 40% of window width
- Maintains input focus in normal mode when switching between windows

### Keyboard Shortcuts

| Shortcut       | Action                                 |
|----------------|----------------------------------------|
| `<leader>cc`   | Toggle Claude Code terminal             |
| `<leader>cC`   | Open Claude Code with `--continue` flag |
| `<leader>cV`   | Open Claude Code with `--verbose` flag  |
| `<leader>cR`   | Open Claude Code with `--resume` flag   |
| `<leader>cn`   | Force normal mode in Claude terminal    |
| `<leader>cq`   | Exit Claude Code                        |

### Window Navigation from Terminal

All standard window navigation keys have special mappings in the Claude terminal to ensure you remain in normal mode when navigating:

| Shortcut       | Action                                 |
|----------------|----------------------------------------|
| `<leader>wh`   | Navigate to left window (normal mode)  |
| `<leader>wj`   | Navigate to window below (normal mode) |
| `<leader>wk`   | Navigate to window above (normal mode) |
| `<leader>wl`   | Navigate to right window (normal mode) |

## Session Management

The integration saves and restores Claude Code terminal state between Neovim sessions:

- Detects if a Claude Code terminal was open in the previous session
- Automatically restores it with the `--continue` flag
- Ensures the restored terminal remains in normal mode

## Installation and Configuration

The Claude Code integration is configured as part of your Neovim setup. It requires:

1. The Claude Code CLI tool installed and accessible at `~/.claude-wrapper`
2. ToggleTerm.nvim plugin
3. Auto-session plugin (for session persistence)

## Customization

To modify the Claude Code terminal behavior:

- Edit `lua/custom/plugins/toggleterm/init.lua` to change window size, position, or key mappings
- Adjust the appearance by modifying the ToggleTerm configuration parameters

## Troubleshooting

If you encounter issues:

1. Ensure Claude Code CLI is properly installed and executable
2. Check that all required plugins are installed and loaded
3. Verify terminal behavior with `:checkhealth`
