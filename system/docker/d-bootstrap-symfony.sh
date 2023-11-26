#!/bin/bash
set -e

if [ "$APP_ENV" != "dev" ]; then

  if [ -n "$(ls -A /var/www/migrations/*.php 2>/dev/null)" ]; then

    until bin/console doctrine:query:sql "select 1" >/dev/null 2>&1; do

      (echo >&2 "[!] Waiting for database to be ready...")

      sleep 2

    done

    bin/console doctrine:migrations:migrate --no-interaction

  fi

fi
