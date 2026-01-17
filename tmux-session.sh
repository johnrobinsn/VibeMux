#!/bin/bash

# VibeMux tmux session management
# Source this file in your .bashrc to get tmux session prompts on terminal start

# Only run in interactive shells
[[ $- != *i* ]] && return

# Don't run if already inside tmux
[ -n "$TMUX" ] && return

# Check if tmux is available
command -v tmux &> /dev/null || return

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
    read -r -p "Choice: " choice

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
