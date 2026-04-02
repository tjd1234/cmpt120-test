#!/usr/bin/env bash
# Preview the site at http://127.0.0.1:4000 — run from this directory after `bundle install`.
set -euo pipefail
cd "$(dirname "$0")"
if command -v rbenv >/dev/null 2>&1; then
  eval "$(rbenv init - bash 2>/dev/null || rbenv init - zsh 2>/dev/null || true)"
fi
exec bundle exec jekyll serve "$@"
