#!/bin/bash
set -u -e -o pipefail -E
if [ ! -z "${VERBOSE+x}" ]; then
  set -x
fi

folder="${CORE_DUMP_FOLDER:-/cores}"
if [ -z "${BUCKET+x}" ]; then
  echo 'Environment BUCKET must be set.'
  exit 1
fi

cd "${folder}"
inotifywait -m -r -e close_write . | while read -r event; do
  file_path="$(awk '{print $1 $3}' <<< "${event}")"
  file_path="${file_path#./}"
  aws s3 cp "${file_path}" "s3://${BUCKET}/${file_path}"
  if [ -z "${PRESERVE_DAYS+x}" ]; then
    rm "${file_path}"
  else
    find . -type f -mtime +$PRESERVE_DAYS -delete
  fi
done
