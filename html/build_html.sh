#!/bin/bash

set -e

cd $(dirname "${0}")

BUILD_DIR="build"
rm -rf "${BUILD_DIR}"
mkdir -p "${BUILD_DIR}"

FRAGMENT="${1}"
TRANSLATION="${2}"
LANGUAGE="${3}"

function markdown_program {
  pandoc -t html $@
}

function htmlify {
  FILE="${BUILD_DIR}/${1}"
  TITLE="${2}"
  SOURCE="${3}"
  HEADER_2="${4}"

  rm -f "${FILE}"
    
  if [ ! "${FRAGMENT}" = "1" ]
  then
    cat "templates/html_header_1.html" >> "${FILE}"
    echo -n "${TITLE}" >> "${FILE}"

    cat "${HEADER_2}" >> "${FILE}"
  fi

  markdown_program "${SOURCE}" >> "${FILE}"

  if [ ! "${FRAGMENT}" = "1" ]
  then
    cat "templates/html_footer.html" >> "${FILE}"
  fi
}

cp files/* build/


if [ "${TRANSLATION}" = "1" ]
then
  HEADER_2="templates/html_header_2_for_translations.html"
else
  HEADER_2="templates/html_header_2.html"
fi

htmlify \
  "index.html" \
  "WCA Regulations 2013" \
  "../wca-documents/wca-regulations-2013.md" \
  "${HEADER_2}"

htmlify \
  "guidelines.html" \
  "WCA Guidelines 2013" \
  "../wca-documents/wca-guidelines-2013.md" \
  "${HEADER_2}"

if [ "${TRANSLATION}" = "0" ]
then

  mkdir "${BUILD_DIR}/history"
  htmlify \
    "history/index.html" \
    "WCA Regulations History" \
    "src/history.md" \
    "templates/html_header_2_for_subdirectories.html"

  mkdir "${BUILD_DIR}/translations"
  htmlify \
    "translations/index.html" \
    "WCA Translations" \
    "src/translations.md" \
    "templates/html_header_2_for_subdirectories.html"

  mkdir "${BUILD_DIR}/scrambles"
  htmlify \
    "scrambles/index.html" \
    "WCA Scrambles" \
    "src/scrambles.md" \
    "templates/html_header_2_for_subdirectories.html"
fi

pushd "../wca-documents" > /dev/null
GIT_BRANCH=$(git rev-parse --abbrev-ref HEAD)
GIT_VERSION=$(git rev-parse --short HEAD)
popd > /dev/null

REGS_URL="./"
GUIDES_URL="guidelines.html"
if [ "${FRAGMENT}" = "1" ]
then
  REGS_URL="/regulations/main"
  GUIDES_URL="/regulations/guidelines"
fi

./process_html.py \
  --regulations-file "${BUILD_DIR}/index.html" \
  --guidelines-file "${BUILD_DIR}/guidelines.html" \
  --git-branch "${GIT_BRANCH}" \
  --git-hash "${GIT_VERSION}" \
  --fragment "${FRAGMENT}" \
  --regs-url "${REGS_URL}" \
  --guides-url "${GUIDES_URL}" \
  --language "${LANGUAGE}"