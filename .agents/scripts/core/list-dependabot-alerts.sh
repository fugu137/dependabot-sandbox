#!/usr/bin/env bash

set -euo pipefail

source "$(dirname $0)/utils.sh"

REPOSITORY="${1:-}"

require_argument "$REPOSITORY" "Please specify a repository"

require_package "gh"
require_package "jq"

TARGET="$REPOSITORY"
OWNER="${TARGET%%/*}"
REPOSITORY="${TARGET#*/}"

if ! gh auth status >/dev/null 2>&1; then
  echo "Error: Please authenticate with 'gh auth login'" >&2
  exit 1
fi

gh api graphql \
  -f owner="$OWNER" \
  -f repo="$REPOSITORY" \
  -f query='
    query($owner: String!, $repo: String!) {
      repository(owner: $owner, name: $repo) {
        vulnerabilityAlerts(first: 50, states: OPEN) {
          nodes {
            createdAt
            state
            securityVulnerability {
              package {
                name
                ecosystem
              }
              vulnerableVersionRange
              firstPatchedVersion {
                identifier
              }
            }
            securityAdvisory {
              summary
              severity
              cveId
            }
            dependabotUpdate {
              pullRequest {
                number
                title
                url
                state
              }
            }
          }
        }
      }
    }
  ' 
