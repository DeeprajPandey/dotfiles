# --------------------------------------------------------------
# File: plugins_before.zsh
# Description: This script autoloads specific plugin scripts that need to be initialised
# before the prompt setup. The focus is on scripts prefixed with 'before_' located in
# the 'plugins' directory. It also sets up the fpath for other external plugins added as
# submodules in 'plugins'.
# --------------------------------------------------------------

# Explicitly add external plugins set up as submodules in the 'plugins' directory to 'fpath'.
# Although it might seem redundant because it's within the 'plugins' path, this inclusion is crucial.
# The 'fpath' variable doesn't inherently apply recursively, and we need to ensure Zsh knows
# exactly where to find all autoloadable functions, including those nested deeper in directories.

# zsh-completions.plugin.zsh adds itself to fpath using the absolute modifier (:A). We would
# rather have the $HOME path in the fpath, so we add it manually here and skip sourcing the
# plugin script.
fpath=($fpath ${0:h}/plugins/zsh-completions/src)
# source /Users/vieuler/.config/zsh/plugins/zsh-completions/zsh-completions.plugin.zsh
