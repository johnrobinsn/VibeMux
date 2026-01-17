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
    # Sessions exist - offer to attach
    echo "Existing tmux sessions:"
    echo "$sessions"
    echo ""
    echo "Options:"
    echo "  [Enter] Attach to first session"
    echo "  [name]  Attach to session by name"
    echo "  [n]     Create new session"
    echo "  [s]     Skip tmux"
    echo ""
    read -r -p "Choice: " choice

    case "$choice" in
        "")
            # Attach to first session
            first_session=$(tmux list-sessions -F "#{session_name}" 2>/dev/null | head -1)
            exec tmux attach-session -t "$first_session"
            ;;
        n|N)
            # Create new session
            read -r -p "New session name (or Enter for default): " session_name
            if [ -n "$session_name" ]; then
                exec tmux new-session -s "$session_name"
            else
                exec tmux new-session
            fi
            ;;
        s|S)
            # Skip tmux
            return
            ;;
        *)
            # Try to attach to named session
            if tmux has-session -t "$choice" 2>/dev/null; then
                exec tmux attach-session -t "$choice"
            else
                echo "Session '$choice' not found."
                read -r -p "Create it? [Y/n]: " create
                if [ "$create" != "n" ] && [ "$create" != "N" ]; then
                    exec tmux new-session -s "$choice"
                fi
            fi
            ;;
    esac
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
            exec tmux new-session
            ;;
        s|S)
            return
            ;;
        *)
            exec tmux new-session -s "$choice"
            ;;
    esac
fi
