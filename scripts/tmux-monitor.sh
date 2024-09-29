#!/usr/bin/env bash

#!/bin/bash

SESSION_NAME="monitor"

# Create a new session
tmux new-session -ds $SESSION_NAME

# Window 1: System and Network Monitoring
tmux rename-window -t $SESSION_NAME:1 'SysNet' \; \
  send-keys 'btop' C-m \; \
  split-window -h \; \
  send-keys 'sudo nettop' C-m \; \
  split-window -fv \; \
  send-keys 'iostat -w 5' C-m \; \
  split-window -h \; \
#   send-keys 'watch -n 5 ./custom_metrics.sh' C-m

# Window 2: Logs and Diagnostics
tmux new-window -t $SESSION_NAME:2 -n 'LogsDiag' \; \
  send-keys 'tail -f /var/log/system.log' C-m \; \
  split-window -v \; \
  send-keys 'tail -f /var/log/application.log' C-m \; \
  split-window -v \; \
  send-keys 'sudo nmap -sS -O 127.0.0.1' C-m \; \
  select-pane -t 2 \; \
  split-window -h \; \
  send-keys 'sudo tcpdump -i any -n' C-m

# # Window 3: Database Monitoring (example for MySQL)
# tmux new-window -t $SESSION_NAME:3 -n 'Database'
# tmux send-keys -t $SESSION_NAME:3 'mysql -u root -p -e "SHOW PROCESSLIST; SHOW STATUS;" -i 5' C-m

# Select the first window
tmux select-window -t $SESSION_NAME:1

# Attach to the session
tmux attach-session -t $SESSION_NAME

