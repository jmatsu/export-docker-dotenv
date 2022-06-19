#!/usr/bin/env bash

set -eu

readonly env_files=("$@")

env_file_args=()

for env_file in "${env_files[@]}"; do
  env_file_args+=("--env-file" "$env_file")
done

docker run --rm \
  "${env_file_args[@]}" \
  -it alpine:3.14 \
  /bin/sh -c 'env | grep DOCKER_DOTENV_COMPATIBLE_ | sort'