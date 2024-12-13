#!/bin/bash

read_changelog() {
  name=$1

  curr_version=$(awk '/^version:/{print $2; exit}' ${name}/pubspec.yaml)

  # Prompt for version string
  read -p "${name} version (current version is ${curr_version}): " version

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
    changelog+="* ${line}"$'\n'
    commit_message+="${line}, "
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

publish() {
  name=$1

  read -p "Do you want to publish ${name}? (y/n): " publish

  if [[ ${publish} == "y" ]]; then
    git add *
    cd ${name}
    dart pub get
    dart pub publish
    cd ..
  fi
}

# Prompt the user
echo "Which package(s) do you want to update:"
echo "1) wasm_ffi"
echo "2) universal_ffi"
echo "3) both"

# Read user input
read -p "Enter your choice (1, 2, or 3): " choice

if [[ ${choice} != 1 && ${choice} != 2 && ${choice} != 3 ]] ; then
  echo "Invalid choice. Please run the script again and select 1 or 2."
  exit 1
fi

if [[ ${choice} == 1 || ${choice} == 3 ]]; then
  read_changelog wasm_ffi
  update_changelog wasm_ffi/CHANGELOG.md
  sed "s/^version: .*/version: ${version}/" -i wasm_ffi/pubspec.yaml
  sed "s/^  wasm_ffi: \^.*/  wasm_ffi: \^${version}/" -i universal_ffi/pubspec.yaml
  publish wasm_ffi
fi

if [[ ${choice} == 2 || ${choice} == 3 ]]; then
  read_changelog universal_ffi
  update_changelog universal_ffi/CHANGELOG.md
  sed "s/^version: .*/version: ${version}/" -i universal_ffi/pubspec.yaml
  publish universal_ffi
fi

# commit
read -p "Do you want to commit the changes? (y/n): " commit

if [[ ${commit} == "y" ]]; then
  git add .
  git commit -m "${commit_message}"

  # push
  read -p "Do you want to push the changes? (y/n): " push

  if [[ ${push} == "y" ]]; then
    git push
  fi
fi

echo "Done!"