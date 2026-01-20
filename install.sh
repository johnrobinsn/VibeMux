#!/bin/bash

set -e

echo "VibeMux Installer"
echo "================="
echo ""

# Detect appropriate shell rc file based on shell and platform
detect_shell_rc() {
    local current_shell
    current_shell=$(basename "$SHELL")

    case "$current_shell" in
        zsh)
            echo "$HOME/.zshrc"
            ;;
        bash)
            # macOS uses .bash_profile for login shells
            if [ "$(uname)" = "Darwin" ]; then
                if [ -f "$HOME/.bash_profile" ]; then
                    echo "$HOME/.bash_profile"
                else
                    echo "$HOME/.bashrc"
                fi
            else
                echo "$HOME/.bashrc"
            fi
            ;;
        *)
            # Default to .bashrc for unknown shells
            echo "$HOME/.bashrc"
            ;;
    esac
}

# Check tmux is installed
if ! command -v tmux >/dev/null 2>&1; then
    echo "Error: tmux is not installed. Please install tmux first."
    echo "  Ubuntu/Debian: sudo apt install tmux"
    echo "  Fedora: sudo dnf install tmux"
    echo "  macOS: brew install tmux"
    exit 1
fi

# Check git is installed
if ! command -v git >/dev/null 2>&1; then
    echo "Error: git is not installed. Please install git first."
    echo "  Ubuntu/Debian: sudo apt install git"
    echo "  Fedora: sudo dnf install git"
    echo "  macOS: brew install git"
    exit 1
fi

# Check ~/.tmux.conf doesn't exist
if [ -f "$HOME/.tmux.conf" ]; then
    echo "Error: ~/.tmux.conf already exists."
    echo "Please back it up and remove it before installing VibeMux."
    exit 1
fi

# Check ~/VibeMux doesn't exist
if [ -d "$HOME/VibeMux" ]; then
    echo "Error: ~/VibeMux directory already exists."
    echo "Please remove or rename it before installing VibeMux."
    exit 1
fi

# Clone repository
echo "Cloning VibeMux repository..."
git clone https://github.com/johnrobinsn/VibeMux "$HOME/VibeMux"

# Create ~/.tmux.conf that sources VibeMux config
echo "Creating ~/.tmux.conf..."
echo "source-file ~/VibeMux/tmux.conf" > "$HOME/.tmux.conf"

# Determine appropriate rc file for this shell/platform
SHELL_RC=$(detect_shell_rc)
SHELL_RC_NAME=$(basename "$SHELL_RC")

echo ""
echo "VibeMux installed successfully!"
echo ""
echo "To start using VibeMux:"
echo "  1. Open a new terminal, or run: source ~/$SHELL_RC_NAME"
echo "  2. Start tmux and enjoy!"
echo ""
echo "Key bindings: Prefix is Ctrl+A"
echo "  Ctrl+T        - New window"
echo "  Shift+Left/Right - Navigate windows"
echo "  Prefix + |    - Split horizontal"
echo "  Prefix + -    - Split vertical"
echo "  Prefix + r    - Reload config"
echo ""

# Optionally add session script to shell rc file (done last for curl pipe compatibility)
RC_LINE='[ -f ~/VibeMux/tmux-session.sh ] && source ~/VibeMux/tmux-session.sh'

if [ -f "$SHELL_RC" ] && grep -qF "VibeMux/tmux-session.sh" "$SHELL_RC"; then
    echo "VibeMux session script already in ~/$SHELL_RC_NAME"
else
    echo "Would you like to add tmux session management to ~/$SHELL_RC_NAME?"
    echo "This will prompt you to attach/create tmux sessions on terminal start."
    printf "Add to ~/$SHELL_RC_NAME? [y/N]: "

    # Read from terminal (works with curl pipe)
    exec 3<&0          # save stdin
    exec < /dev/tty    # redirect stdin from tty
    read -r add_rc
    exec 0<&3          # restore stdin
    exec 3<&-          # close fd 3

    if [ "$add_rc" = "y" ] || [ "$add_rc" = "Y" ]; then
        # Create the rc file if it doesn't exist
        if [ ! -f "$SHELL_RC" ]; then
            touch "$SHELL_RC"
        fi
        echo "" >> "$SHELL_RC"
        echo "# VibeMux tmux session management" >> "$SHELL_RC"
        echo "$RC_LINE" >> "$SHELL_RC"
        echo "Added tmux session script to ~/$SHELL_RC_NAME"
    else
        echo "Skipped ~/$SHELL_RC_NAME modification"
    fi
fi
