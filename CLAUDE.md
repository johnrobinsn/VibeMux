# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

This is a tmux configuration repository containing a single `tmux.conf` file for customizing the tmux terminal multiplexer.

## Installation

```bash
# Copy to tmux config location
cp tmux.conf ~/.tmux.conf

# Reload configuration (from within tmux)
Prefix + r  (Ctrl+A then r)
```

## Key Bindings

**Prefix**: `Ctrl+A` (changed from default `Ctrl+B`)

| Binding | Action |
|---------|--------|
| `Ctrl+T` | New window (no prefix needed) |
| `Shift+Left/Right` | Navigate between windows |
| `Shift+Ctrl+Left/Right` | Swap window positions |
| `Prefix + \|` | Split pane horizontally |
| `Prefix + -` | Split pane vertically |
| `Prefix + r` | Reload config |
| `Prefix + p` | Previous window |

## Nested tmux Mode

This config supports nested tmux sessions (e.g., local tmux + remote tmux over SSH):

- `Shift+Up`: Switch to "inner" mode - disables outer tmux bindings, changes status bar to blue
- `Shift+Down`: Switch to "outer" mode - restores normal bindings, changes status bar to green

The status bar color indicates which tmux instance is active (green = outer, blue = inner).

## Configuration Details

- Windows and panes start at index 1 (not 0)
- Mouse support enabled
- Automatic window renaming disabled
- New windows/panes open in current directory
- Extended keys support enabled for modern terminals
