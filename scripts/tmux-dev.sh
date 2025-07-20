#!/usr/bin/env bash

tmux new-session -s dev -c ~/.dotfiles \; \
  send-keys 'nv .' C-m \; \
  split-window -h -l 45% btop \; \
  select-pane -L \; \
  split-window -v -l 35% -c ~/.dotfiles \; \
  send-keys 'g st' C-m \; \
  select-pane -U \; \
  send-keys 'C-n' 'C-P'

