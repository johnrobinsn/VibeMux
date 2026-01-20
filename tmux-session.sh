#!/bin/sh

# VibeMux tmux session management
# Source this file in your shell rc file (.bashrc, .zshrc, .bash_profile)
# to get tmux session prompts on terminal start

# Only run in interactive shells
case $- in
    *i*) ;;      # interactive, continue
    *) return ;; # non-interactive, exit early
esac

# Don't run if already inside tmux
[ -n "$TMUX" ] && return

# Check if tmux is available
command -v tmux >/dev/null 2>&1 || return

# Get list of existing sessions
sessions=$(tmux list-sessions 2>/dev/null)

if [ -n "$sessions" ]; then
    # Sessions exist - auto-attach to first one
    first_session=$(tmux list-sessions -F "#{session_name}" 2>/dev/null | head -1)
    tmux attach-session -t "$first_session"
else
    # No sessions exist - offer to create one or skip
    echo "No tmux sessions running."
    echo ""
    echo "Options:"
    echo "  [Enter] Start new tmux session"
    echo "  [name]  Start session with name"
    echo "  [s]     Skip tmux"
    echo ""
    printf "Choice: "
    read -r choice

    case "$choice" in
        "")
            tmux new-session
            ;;
        s|S)
            return
            ;;
        *)
            tmux new-session -s "$choice"
            ;;
    esac
fi
