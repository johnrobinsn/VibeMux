#!/bin/bash

set -e

echo "VibeMux Installer"
echo "================="
echo ""

# Check tmux is installed
if ! command -v tmux &> /dev/null; then
    echo "Error: tmux is not installed. Please install tmux first."
    echo "  Ubuntu/Debian: sudo apt install tmux"
    echo "  Fedora: sudo dnf install tmux"
    echo "  macOS: brew install tmux"
    exit 1
fi

# Check git is installed
if ! command -v git &> /dev/null; then
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

# Optionally add session script to .bashrc
BASHRC_LINE='[ -f ~/VibeMux/tmux-session.sh ] && source ~/VibeMux/tmux-session.sh'

if [ -f "$HOME/.bashrc" ] && grep -qF "VibeMux/tmux-session.sh" "$HOME/.bashrc"; then
    echo "VibeMux session script already in ~/.bashrc"
else
    echo ""
    echo "Would you like to add tmux session management to ~/.bashrc?"
    echo "This will prompt you to attach/create tmux sessions on terminal start."
    read -r -p "Add to .bashrc? [y/N]: " add_bashrc < /dev/tty

    if [ "$add_bashrc" = "y" ] || [ "$add_bashrc" = "Y" ]; then
        echo "" >> "$HOME/.bashrc"
        echo "# VibeMux tmux session management" >> "$HOME/.bashrc"
        echo "$BASHRC_LINE" >> "$HOME/.bashrc"
        echo "Added tmux session script to ~/.bashrc"
    else
        echo "Skipped .bashrc modification"
    fi
fi

echo ""
echo "VibeMux installed successfully!"
echo ""
echo "To start using VibeMux:"
echo "  1. Open a new terminal, or run: source ~/.bashrc"
echo "  2. Start tmux and enjoy!"
echo ""
echo "Key bindings: Prefix is Ctrl+A"
echo "  Ctrl+T        - New window"
echo "  Shift+Left/Right - Navigate windows"
echo "  Prefix + |    - Split horizontal"
echo "  Prefix + -    - Split vertical"
echo "  Prefix + r    - Reload config"
