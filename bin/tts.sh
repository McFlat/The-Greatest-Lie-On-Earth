#!/usr/bin/env bash

BASEDIR="$(realpath "$(dirname "${0}")/..")";
RELPATH="$(echo ${BASEDIR} | sed 's|'"$(realpath .)"'|.|')"
if [ "${BASEDIR}" == "${RELPATH}" ]; then
  RELPATH="."
fi

function show_version() {
  echo "$(date -r $0 +%s)"
  exit 0;
}
function show_help() {
  echo "usage: $0 -q <query> -l <lang>"
  echo
  echo "  -v | --version  print version number and exit, version is the file modification timestamp"
  echo "  -q | --query  QUERY = query(required), text to speak"
  echo "  -l | --lang   LANG = language(optional), default: ru"
  echo "  -s | --speed  SPEED = speed(optional), default: 1"
  echo "  -o | --output OUTPUT = output(optional) audio, default: ${RELPATH}\${QUERY}.mp3"
  echo "  -a | --agent  AGENT = user_agent(optional) to send to server, default: Mozilla/5.0 ..."
  echo
  echo "examples: $0 -q 'Слава Господу' -l ru -o './Слава Господу'"
  exit 1;
}

QUERY=();

for ((i=1;i<=$#;i++));
do
  if [ "${!i}" = "" ]; then
    show_help
  elif [ "${!i}" = "--version" ] || [ "${!i}" = "-v" ]
  then ((i++))
    show_version
  elif [ "${!i}" = "--query" ] || [ "${!i}" = "-q" ]
  then ((i++))
    QUERY="${!i}";
  elif [ "${!i}" = "--index" ] || [ "${!i}" = "-i" ]
  then ((i++))
    INDEX="${!i}";
  elif [ "${!i}" = "--lang" ] || [ "${!i}" = "-l" ]
  then ((i++))
    LANGUAGE="${!i}";
  elif [ "${!i}" = "--speed" ] || [ "${!i}" = "-s" ]
  then ((i++))
    SPEED="${!i}";
  elif [ "${!i}" = "--output" ] || [ "${!i}" = "-o" ]
  then ((i++))
    OUTPUT="${!i}";
  elif [ "${!i}" = "--agent" ] || [ "${!i}" = "-a" ]
  then ((i++))
    AGENT="${!i}";
  else
    QUERY=( "${QUERY[@]}" "${!i}" )
  fi
done;

# QUERY=$(python -c "import urllib, sys; print urllib.quote(sys.argv[1])"  "${QUERY[@]}")
QUERY=$(echo ${QUERY[@]} | sed 's/\.//g' | sed 's/,//g')

if [ -z "${LANGUAGE}" ]; then
  LANGUAGE="en"
fi
if [ -z "${SPEED}" ]; then
  SPEED="1"
fi
# if [ -z "${OUTPUT}" ]; then
#   if [ ! -d "${RELPATH}/tts/${LANGUAGE}" ]; then
#     mkdir "${RELPATH}/tts/${LANGUAGE}";
#   fi
#   OUTPUT="${RELPATH}/tts/${LAGUAGE}/${word}.mp3";
# fi
if [ -z "${AGENT}" ]; then
  AGENT="Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:46.0) Gecko/20100101 Firefox/46.0";
fi
# for word in $QUERY; do
#   if [ ! -f "${word}.mp3" ]; then
#     wget -U "${AGENT}" "https://google-translate-proxy.herokuapp.com/api/tts?language=${LANGUAGE}&speed=${SPEED}&query=${word}" -O "${word}.mp3";
#   fi
# done
