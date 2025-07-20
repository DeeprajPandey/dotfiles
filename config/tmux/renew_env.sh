#!/usr/bin/env bash

# Log start of script execution
echo "Script started at $(date)" > /tmp/tmux_renew_env_debug.log

# Get the list of environment variables to update
update_vars=$(tmux show-options -gv update-environment | tr '\n' ' ')

# For each variable, update it if it exists in the environment
for var in $update_vars; do
  if [ -n "${!var}" ]; then
    tmux setenv -g "$var" "${!var}"
  fi
done

# Log end of script execution
echo "Script completed at $(date)" >> /tmp/tmux_renew_env_debug.log





# set -eu
#
# # # Redirect all output to a log file
# # exec > >(tee /tmp/tmux_renew_env_debug.log) 2>&1
# #
# # echo "Script started at $(date)"
# # echo "Current working directory: $(pwd)"
# # echo "Current user: $(whoami)"
# #
# # set -x  # Enable command tracing
#
# # Add error logging
# exec 2>>/tmp/tmux_renew_env_error.log
#
# echo "Script started at $(date)" >&2
#
# pane_fmt="#{pane_id} #{pane_in_mode} #{pane_input_off} #{pane_dead} #{pane_current_command}"
# tmux list-panes -s -F "$pane_fmt" | awk '
#   $2 == 0 && $3 == 0 && $4 == 0 && $5 ~ /(bash|zsh|ksh|fish)/ { print $1 }
# ' | while read -r pane_id; do
#   # renew environment variables according to update-environment tmux option
#   # also clear screen
#   tmux send-keys -t "$pane_id" 'Enter' 'eval "$(tmux show-env -s)"' 'Enter' 'C-l'
# done
#
# # echo "Script completed at $(date)" >&2
# echo "Script completed at $(date)"
