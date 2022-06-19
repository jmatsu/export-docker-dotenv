#!/usr/bin/env bash

set -eu

readonly shell_path="${1?shell is required}"; shift

readonly env_files=("$@")

load_commands=()

for env_file in "${env_files[@]}"; do
  load_commands+=("export_docker_dotenv" "$env_file" ";")
done

# export EXPORT_DOCKER_DOTENV_VERBOSE=1

"$shell_path" -c \
  ". ./export-docker-dotenv; ${load_commands[*]} env | grep DOCKER_DOTENV_COMPATIBLE_ | sort"