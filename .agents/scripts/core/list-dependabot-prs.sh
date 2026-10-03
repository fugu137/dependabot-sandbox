#!/usr/bin/env bash

set -euo pipefail

source "$(dirname $0)/utils.sh"

REPOSITORY="${1:-}"

require_argument "$REPOSITORY" "Please specify a repository"

require_package "gh"
require_package "jq"

if ! gh auth status >/dev/null 2>&1; then
  echo "Error: Please authenticate with 'gh auth login'" >&2
  exit 1
fi

gh pr list \
  --repo "$REPOSITORY" \
  --state open \
  --author "app/dependabot" \
  --limit 1000 \
  --json number,title,url,headRefName,baseRefName