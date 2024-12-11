#!/bin/bash

read_changelog() {
  # Prompt for version string
  read -p "Enter next version (current version is ${curr_version}): " version

  # validate version string
  if [[ ! ${version} =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
    echo "Invalid version format. Please enter a valid version string."
    exit 1
  fi

  # Prompt for changelog
  echo "Enter changelog (end input with an empty line):"
  changelog=""
  while IFS= read -r line; do
    # Break on empty input
    if [[ -z "${line}" ]]; then
      break
    fi
    changelog+="${line}"$'\n'
  done

  if [[ -z "${changelog}" ]]; then
    echo "No changelog provided."
    exit 1
  fi
}

update_changelog() {
  file=$1
  {
      echo -e "## [${version}]\n${changelog}"
      cat "${file}"
  } > temp_file && mv temp_file "${file}"
}

# Prompt the user
echo "Which package do you want to update:"
echo "1) wasm_ffi"
echo "2) universal_ffi"

# Read user input
read -p "Enter your choice (1 or 2): " choice

case ${choice} in
  1)
    curr_version=$(awk '/^version:/{print $2; exit}' wasm_ffi/pubspec.yaml)
    ;;
  2)
    curr_version=$(awk '/^version:/{print $2; exit}' universal_ffi/pubspec.yaml)
    ;;
  *)
    echo "Invalid choice. Please run the script again and select 1 or 2."
    exit 1
    ;;
esac

read_changelog

case ${choice} in
  1)
    update_changelog wasm_ffi/CHANGELOG.md
    sed "s/^version: .*/version: ${version}/" -i wasm_ffi/pubspec.yaml
    sed "s/^  wasm_ffi: \^.*/  wasm_ffi: \^${version}/" -i universal_ffi/pubspec.yaml
    ;;
  2)
    update_changelog universal_ffi/CHANGELOG.md
    sed "s/^version: .*/version: ${version}/" -i universal_ffi/pubspec.yaml
    ;;
esac
