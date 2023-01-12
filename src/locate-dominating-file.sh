#!/usr/bin/env bash

set -euo pipefail

usage() {
  >&2 cat <<HERE
Usage:
  locate-dominating-file file|dir [options]

  Outputs the closest parent directory containing the given file or directory
  name. If it doesn't find file that matches the name, the program exits with
  status code 1.

OPTIONS
  --print-dir  print directory name without file
  --no-print   do not print any message
  --help       prints this message

EXAMPLE

  $ cd /home/roman/my-project/src/internal/lib
  $ locate-dominating-file .env.sh
  => /home/roman/my-project/.env.sh

HERE
  exit 2
}

PARSED_ARGUMENTS="$(getopt -a -n "$(basename "$0")" -o h --long help,print-dir,no-print -- "$@")"

VALID_ARGUMENTS=$?
if [ "$VALID_ARGUMENTS" != "0" ]; then
  usage
fi

PRINT_FILE=1
NO_PRINT=

eval set -- "$PARSED_ARGUMENTS"

while :
do
  case "$1" in
    --help ) usage ;;
    --print-dir ) PRINT_FILE=0; shift ;;
    --no-print ) NO_PRINT=1; shift ;;
    -- ) shift; break ;;
  esac
done

if [ -z "$*" ]; then
  usage
fi

FILE_NAME="$1"
SOURCE="$(pwd)"

locate_dominating_file () {
  local slashes=${SOURCE//[^\/]/}
  local directory="$SOURCE"
  for (( n=${#slashes}; n>0; --n )); do
    if [ -f "$directory/$FILE_NAME" ] || [ -d "$directory/$FILE_NAME" ]; then
        if [[ "$NO_PRINT" -eq 1 ]]; then
            true
        elif [[ "$PRINT_FILE" -eq 1 ]]; then
            echo "$(realpath "$directory")/$FILE_NAME"
        else
            echo "$(realpath "$directory")"
        fi
        exit 0
    fi
    directory="$directory/.."
  done
  # Didn't find any file, exit with error
  exit 1
}

locate_dominating_file
