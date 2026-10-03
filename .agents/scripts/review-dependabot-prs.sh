#!/usr/bin/env bash

set -euo pipefail

source "$(dirname $0)/core/utils.sh"

require_package "gh"
require_package "jq"

repository="$(gh repo view --json nameWithOwner --jq '.nameWithOwner')"
scripts_dir="$(dirname "$0")"

dependabot_prs="$("$scripts_dir/core/list-dependabot-prs.sh" "$repository")"

while IFS= read -r pr; do
  echo "Reviewing PR: $pr..."
done < <(jq -c '.[]' <<< "$dependabot_prs")