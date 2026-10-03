#!/usr/bin/env bash

function require_argument() {
  local argument="$1"
  local message="$2"

  if [[ -z $argument ]]; then
    echo "$message" >&2
    echo "Usage: $0 <owner/repository>" >&2
    exit 1
  fi
}

function require_package() {
  local required_package="$1"

  if ! command -v "$required_package" >/dev/null 2>&1; then
    echo "Error: $required_package is required for this script to work" >&2
    exit 1
  fi
}