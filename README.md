# VibeMux

A tmux configuration for a better terminal multiplexer experience. Features intuitive key bindings, mouse support, and seamless nested tmux session handling.

## Quick Install

```bash
curl -fsSL https://raw.githubusercontent.com/johnrobinsn/VibeMux/main/install.sh | bash
```

This will:
- Clone VibeMux to `~/VibeMux`
- Create `~/.tmux.conf` that sources the config
- Add session management to your `.bashrc`

### Requirements

- `tmux` installed
- `git` installed

## Key Bindings

**Prefix**: `Ctrl+A` (changed from default `Ctrl+B`)

### Window Management

| Binding | Action |
|---------|--------|
| `Ctrl+T` | New window (no prefix needed) |
| `Shift+Left` | Previous window |
| `Shift+Right` | Next window |
| `Shift+Ctrl+Left` | Swap window left |
| `Shift+Ctrl+Right` | Swap window right |
| `Prefix + c` | New window |
| `Prefix + p` | Previous window |

### Pane Management

| Binding | Action |
|---------|--------|
| `Prefix + \|` | Split pane horizontally |
| `Prefix + -` | Split pane vertically |

### Scrolling

| Binding | Action |
|---------|--------|
| `Ctrl+Up` | Enter scroll mode / page up |
| `Ctrl+Down` | Page down / exit scroll mode |

### Other

| Binding | Action |
|---------|--------|
| `Prefix + r` | Reload config |

## Session Management

After installation, opening a new terminal will prompt you to:

- **Attach** to an existing tmux session
- **Create** a new session (with optional name)
- **Skip** tmux entirely

This makes it easy to maintain persistent sessions across terminal restarts.

## Nested Tmux Sessions

VibeMux supports nested tmux sessions (e.g., local tmux + remote tmux over SSH). Use these bindings to switch control between outer and inner tmux:

| Binding | Action |
|---------|--------|
| `Shift+Up` | Switch to **inner** mode (status bar turns blue) |
| `Shift+Down` | Switch to **outer** mode (status bar turns green) |

The status bar color indicates which tmux is active:
- **Green** = outer tmux (local)
- **Blue** = inner tmux (remote/nested)

## Configuration Details

- Windows and panes start at index 1 (not 0)
- Mouse support enabled (click windows, panes, resize)
- Automatic window renaming disabled
- New windows/panes open in current directory
- Reduced escape-time for faster key response
- Extended keys support for modern terminals

## Manual Installation

If you prefer manual setup:

```bash
git clone https://github.com/johnrobinsn/VibeMux ~/VibeMux
echo "source-file ~/VibeMux/tmux.conf" > ~/.tmux.conf
echo '[ -f ~/VibeMux/tmux-session.sh ] && source ~/VibeMux/tmux-session.sh' >> ~/.bashrc
```

## Update

```bash
cd ~/VibeMux && git pull
```

Changes take effect immediately for new tmux sessions. To reload in an existing session, press `Prefix + r` (Ctrl+A then r).

## Uninstall

```bash
rm -rf ~/VibeMux
rm ~/.tmux.conf
# Remove the VibeMux line from ~/.bashrc
```

## License

MIT
