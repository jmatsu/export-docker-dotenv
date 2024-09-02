#!/usr/bin/env bash

set -eux

readonly shell_path="${1?shell is required}"; shift
readonly env_mode="${1---export}"; shift
readonly env_files=("$@")

# shellcheck disable=SC2155
readonly expected_result_path="$(mktemp)"
# shellcheck disable=SC2155
readonly actual_result_path="$(mktemp)"

if ((${#env_files[*]} == 0)); then
  echo "env files are required" 1>&2
  exit 1
fi

if [[ "$env_mode" == "--no-overwrite" ]]; then
  args=()
  for ((i = $((${#env_files[@]} - 1)); i >= 0; i--)); do
      args+=(${env_files[i]})
  done
else
  args=("${env_files[@]}")
fi

spec/create_expected_results.bash "$env_mode" "${args[@]}" > "$expected_result_path"
spec/create_actual_results.bash "$shell_path" "${args[@]}" > "$actual_result_path"

if diff --strip-trailing-cr "$expected_result_path" "$actual_result_path"; then
  echo 'ok'
else
  echo '::error::the generated files differ (export)'
fi