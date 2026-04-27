#!/usr/bin/env bash

# refresh tmux's global environment with current values for vars
# listed in the `update-environment` option. existing panes pick up
# fresh values the next time they `eval $(tmux show-env -s)`.

update_vars=$(tmux show-options -gv update-environment | tr '\n' ' ')

for var in $update_vars; do
  if [ -n "${!var}" ]; then
    tmux setenv -g "$var" "${!var}"
  fi
done
