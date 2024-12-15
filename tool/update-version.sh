#!/bin/bash

read_changelog() {
  curr_version=$(awk '/^version:/{print $2; exit}' pubspec.yaml)

  # Prompt for version string
  read -p "Next version (current version is ${curr_version}): " version

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
  read -p "Do you want to publish? (y/n): " publish

  if [[ ${publish} == "y" ]]; then
    git add *
    flutter pub get
    cd example && flutter pub get && cd ..
    cd example_flutter && flutter pub get && cd ..
    flutter analyze && flutter pub publish
  fi
}

read_changelog
update_changelog CHANGELOG.md
sed "s/^version: .*/version: ${version}/" -i pubspec.yaml
publish

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