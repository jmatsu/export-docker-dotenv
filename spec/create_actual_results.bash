#!/usr/bin/env bash

set -eu

readonly shell_path="${1?shell is required}"; shift

readonly env_files=("$@")

load_commands=()

for env_file in "${env_files[@]}"; do
  load_commands+=("${FUNCTION_FILE_PATH-export-docker-dotenv}" "$env_file" ";")
done

"$shell_path" -c \
  ". ./export-docker-dotenv; ${load_commands[*]} env | grep DOCKER_DOTENV_COMPATIBLE_ | sort; printf '%s\n' \$DOCKER_DOTENV_COMPATIBLE_12"