#!/bin/sh

# This script adds a path to the sparse-checkout file for a given submodule,
# with an option to run in verbose mode for detailed output.
#
# Usage:
# ./add_to_sparse_checkout.sh [-v|--verbose] <path-to-submodule> <path-to-sparse-checkout-file>
#
# Options:
# -v, --verbose  Enable verbose output.
#
# Arguments:
# - path-to-submodule: Relative path from the root of the main repository to the submodule.
# - path-to-sparse-checkout-file: The file or directory path within the submodule
#   that you want to add to the sparse-checkout file.
#
# Example:
# ./add_to_sparse_checkout.sh -v path/to/my/submodule src/

# Initialize variables
VERBOSE=0

# Check for verbose flag
if [ "$1" = "-v" ] || [ "$1" = "--verbose" ]; then
  VERBOSE=1
  shift # Remove the verbose flag from the arguments
fi

# Check for the correct number of arguments
if [ "$#" -ne 2 ]; then
  if [ "$VERBOSE" -eq 1 ]; then
    echo "Verbose mode enabled."
  fi
  echo "Usage: $0 [-v|--verbose] <path-to-submodule> <path-to-sparse-checkout-file>"
  exit 1
fi

# path to submodule from repo root
SUBMODULE_NAME="$1"
# file or directory path to be added to sparse-checkout
SPARSE_CHECKOUT_ITEM="$2"

SUBMODULE_PATH=".git/modules/$SUBMODULE_NAME"
SPARSE_CHECKOUT_FILE="$SUBMODULE_PATH/info/sparse-checkout"

# Function to output messages in verbose mode
verbose_echo() {
  if [ "$VERBOSE" -eq 1 ]; then
    echo "$@"
  fi
}

verbose_echo "Submodule:\t\t$SUBMODULE_NAME"
verbose_echo "Sparse Checkout Item:\t$SPARSE_CHECKOUT_ITEM"
verbose_echo "Submodule Path:\t\t$SUBMODULE_PATH"
verbose_echo "Sparse Checkout File:\t$SPARSE_CHECKOUT_FILE"
verbose_echo "=========="

# Ensure that submodule has info directory
if [ ! -d "$SUBMODULE_PATH/info" ]; then
  verbose_echo "The specified submodule path does not have an info directory."
  exit 1
fi

# Check if file or directory is already in the sparse-checkout file
if [ -f "$SPARSE_CHECKOUT_FILE" ] && grep -Fxq "$SPARSE_CHECKOUT_ITEM" "$SPARSE_CHECKOUT_FILE"; then
  verbose_echo "Path '$SPARSE_CHECKOUT_ITEM' is already in '$SPARSE_CHECKOUT_FILE'"
else
  echo "$SPARSE_CHECKOUT_ITEM" >> "$SPARSE_CHECKOUT_FILE"
  verbose_echo "Added '$SPARSE_CHECKOUT_ITEM' to the '$SPARSE_CHECKOUT_FILE'"
fi

# Attempt to re-read config and update working directory
if ! git read-tree -mu HEAD; then
  echo "Failed to apply sparse-checkout changes with 'git read-tree -mu HEAD'."
  echo "You might need to deinitialize and reinitialize the submodule. Try running:"
  echo "  git submodule deinit ."
  echo "  git submodule update --init"
  echo "Note: Ensure you are in the correct submodule directory when running these commands."
fi

