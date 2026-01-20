# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

VibeMux is a tmux configuration with intuitive key bindings, nested session support, and automatic session management. It consists of three files:

- `tmux.conf` - Main tmux configuration
- `install.sh` - One-line installer script (bash/zsh, Linux/macOS)
- `tmux-session.sh` - POSIX shell script for automatic tmux session prompts

## Supported Platforms

- **Linux**: bash, zsh
- **macOS**: bash, zsh

The installer auto-detects your shell and uses the appropriate rc file:
- `~/.bashrc` - bash on Linux
- `~/.bash_profile` - bash on macOS
- `~/.zshrc` - zsh on any platform

## Architecture

**Installation flow**: `install.sh` clones the repo to `~/VibeMux`, creates `~/.tmux.conf` that sources `~/VibeMux/tmux.conf`, and optionally adds `tmux-session.sh` to your shell's rc file.

**Nested tmux mechanism**: The config uses `M-F11`/`M-F12` as internal signals between nested instances. When switching to inner mode (`Shift+Up`), the outer tmux unbinds its keys, changes prefix to `Ctrl+B`, and sends `M-F12` to tell the inner tmux to activate. The status bar color (green=outer active, blue=inner active) indicates which instance has control.

**Session management**: `tmux-session.sh` is sourced from your shell rc file. On terminal start (outside tmux), it either auto-attaches to the first existing session or prompts to create a new one.

## Testing Changes

```bash
# Test tmux.conf changes in current session
tmux source-file ~/VibeMux/tmux.conf

# Or use the keybinding (Ctrl+A then r)
Prefix + r

# Test install.sh (requires clean environment)
rm -rf ~/VibeMux ~/.tmux.conf
./install.sh

# Test tmux-session.sh
source ~/VibeMux/tmux-session.sh
```

## Key Bindings Reference

**Prefix**: `Ctrl+A`

| Binding | Action |
|---------|--------|
| `Ctrl+T` | New window (no prefix) |
| `Shift+Left/Right` | Navigate windows |
| `Shift+Ctrl+Left/Right` | Swap window positions |
| `Ctrl+Up/Down` | Scroll mode / page up/down |
| `Prefix + \|` | Split horizontal |
| `Prefix + -` | Split vertical |
| `Prefix + r` | Reload config |
| `Shift+Up` | Inner mode (blue status) |
| `Shift+Down` | Outer mode (green status) |
