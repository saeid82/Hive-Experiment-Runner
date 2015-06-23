#!/bin/bash

USERNAME=${1:?"singleQueue.sh: missing user name"}
QUEUE=${2:?"singleQueue.sh: missing queue"}
QUERYNAME=${3:?"singleQueue.sh: missing query name"}

SOURCE="${BASH_SOURCE[0]}"
while [ -h "$SOURCE" ]; do
  DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"
  SOURCE="$(readlink "$SOURCE")"
  [[ $SOURCE != /* ]] && SOURCE="$DIR/$SOURCE"
done
SCRIPT_DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"

. "${SCRIPT_DIR}/config/variables.sh"

rm -f "${SCRIPT_DIR}/scratch/stopSession.tmp"
rm -f "${SCRIPT_DIR}/scratch/${USERNAME}.${QUERYNAME}.${QUEUE}.txt"
if [ ! -d fetched/session ]; then
  mkdir -p fetched/session
fi

while [ ! -f "${SCRIPT_DIR}/scratch/stopSession.tmp" ]; do
  sql=$(tempfile -d "${SCRIPT_DIR}/scratch/" -m 0644 -p "${USERNAME}_${QUEUE}_${QUERYNAME}." -s ".sql")
  tmp=$(tempfile -d "${SCRIPT_DIR}/scratch/" -m 0644 -p "${USERNAME}_${QUEUE}_${QUERYNAME}." -s ".tmp")

  sed -e "s#DB_NAME#${DB_NAME}#g" "${SCRIPT_DIR}/queries/my_init.sql" > "${sql}"
  echo "set tez.queue.name=${QUEUE};" >> "${sql}"

  TST=$(date "+%T.%3N")
  sudo -u "$USERNAME" hive -i "${sql}" \
    -f "${SCRIPT_DIR}/queries/${QUERYNAME}.${QUERYEXTENSION}" > "${tmp}" 2>&1
  TND=$(date "+%T.%3N")
  while read -r line; do
    if [[ "$line" =~ .*(application_[0-9]+_[0-9]+).* ]]; then
      strresult=${BASH_REMATCH[1]}
      echo "${strresult}, ${TST}, ${TND}" >> \
        "fetched/session/${USERNAME}_${QUERYNAME}_${QUEUE}.txt"
      break
    fi
  done < "${tmp}"

  [ "x${DEBUG}" != "xyes" ] || rm "${sql}" "${tmp}"

  python waitExp.py
done
