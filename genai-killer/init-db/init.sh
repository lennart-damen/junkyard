#!/bin/bash
set -e

SCRIPT_DIR="$(dirname "$0")"

# Load and export variables from .env
export $(grep -v '^#' "$SCRIPT_DIR/.env" | xargs)

# Replace placeholders using sed
sed \
  -e "s/{{PG_DB}}/${PG_DB}/g" \
  -e "s/{{PG_USER}}/${PG_USER}/g" \
  -e "s/{{PG_PASS}}/${PG_PASS}/g" \
  "$SCRIPT_DIR/init.sql.template" \
  > "$SCRIPT_DIR/init.sql"
