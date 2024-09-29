#!/usr/bin/env bash

tmux new-session -s start -c ~/.dotfiles \; \
  rename-window 'ed' \; \
  send-keys 'ls -lah' C-m \; \
  split-window -h \; \
  send-keys 'man tmux' C-m \; \
  split-window -Zfv -l 65% -c ~/.dotfiles \; \
  send-keys 'nv .' C-m \; \
  new-window -n 'term' \; \
  send-keys 'g diff' C-m \; \
  split-window -h \; \
  send-keys 'g st' C-m 'g co "' \; \
  select-window -t 1

