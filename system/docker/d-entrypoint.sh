#!/bin/bash
set -e

if [ "$1" = "supervisord" ] || [ "$1" == "bin/console" ]; then

  while IFS= read -r script; do

    if [ -f "$script" ]; then

      bash "$script" "$@"

    fi

  done < <(grep -v '^ *#' < "/docker/d-entrypoint.list")

fi

exec "$@"
