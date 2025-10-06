#!/usr/bin/env bash
set -euo pipefail

# Railway provides PORT; default to 8080 if not set
PORT="${PORT:-8080}"

# Reconfigure Apache listen port and vhost
sed -ri "s/Listen 80/Listen ${PORT}/g" /etc/apache2/ports.conf
if [ -f /etc/apache2/sites-available/000-default.conf ]; then
  sed -ri "s/:80>/:${PORT}>/g" /etc/apache2/sites-available/000-default.conf
fi

exec docker-entrypoint.sh "$@"


