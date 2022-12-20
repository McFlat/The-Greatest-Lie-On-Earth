#!/usr/bin/env bash

function encode(){
  O="$1";
  I="$2";
  P="$3";
  # openssl base64 -in "${I}" -out "${O}";
  if [ "$I" != "" ] && [ "$O" != "" ]; then
    base64 -o "$O" -i "$I";
  elif [ "$O" != "" ]; then
    # read from stdin
    base64 -o "$O";
  elif [ "$I" != "" ]; then
    # write to stdout
    if [ "$CP" == false ]; then
      echo "$P$(base64 -i "$I")"
    else
      echo "$P$(base64 -i "$I")" | pbcopy;
    fi
  fi
}

function decode() {
  O="$1";
  I="$2";
  P="$3";
  # openssl base64 -d -A -in "${I}" -out "${O}";
  if [ "$I" != "" ] && [ "$O" != "" ]; then
    base64 -D -o "$O" -i "$I";
  elif [ "$O" != "" ]; then
    # read from stdin
    base64 -D -o "$O";
  elif [ "$I" != "" ]; then
    # write to stdout
    if [ "$CP" == false ]; then
      base64 -D -i "$I";
    else
      base64 -D -i "$I" | pbcopy;
    fi
  fi
}

function show_version() {
  echo "$(date -r $0 +%s)"
  exit 0;
}
function show_help() {
  # 12644705_461801570686249_9202257357073544057_n
  echo "usage: $0 -c -e -t <type> -i <file>"
  echo
  echo "  -v | --version  print version number and exit, version is the file modification timestamp"
  echo "  -e | --encode   OP = encode; to encode the input file; default: encode"
  echo "  -d | --decode   OP = decode; to decode the input file"
  echo "  -t | --type     TYPE = filetype, eg. png, jpg; default: jpg"
  echo "  -p | --prepend  PRE = prepend base64 string to output data; default: data:image/jpg;base64,"
  echo "  -c | --copy     CP = copy output to clipboard, no output file param necessary; true if set, default: false"
  echo "  -i | --input    IN = input file path"
  echo "  -o | --output   OUT = output file path"
  echo
  echo "examples: $0 -c -e -i '12345.jpg'"
  exit 1;
}

OP=""
CP=false
IN=""
OUT=""
TYPE="jpg"
PRE="data:image/$TYPE;base64,"
if [ $# -gt 0 ]; then
  for ((i=1;i<=$#;i++));
  do
    if [ "${!i}" = "--help" ] || [ "${!i}" = "-h" ]
    then #((i++))
      show_help
    elif [ "${!i}" = "--encode" ] || [ "${!i}" = "-e" ]
    then #((i++))
      OP="encode";
    elif [ "${!i}" = "--decode" ] || [ "${!i}" = "-d" ]
    then #((i++))
      OP="decode";
    elif [ "${!i}" = "--copy" ] || [ "${!i}" = "-c" ]
    then #((i++))
      CP=true
    elif [ "${!i}" = "--input" ] || [ "${!i}" = "-i" ]
    then ((i++))
      IN="${!i}";
    elif [ "${!i}" = "--output" ] || [ "${!i}" = "-o" ]
    then ((i++))
      OUT="${!i}";
    elif [ "${!i}" = "--type" ] || [ "${!i}" = "-t" ]
    then ((i++))
      TYPE="${!i}";
      PRE="data:image/$TYPE;base64,"
    elif [ "${!i}" = "--prepend" ] || [ "${!i}" = "-p" ]
    then ((i++))
      PRE="${!i}";
    fi
  done;

  if [ "$OP" == "" ]; then
    OP="encode"
  fi

  case "$OP" in
    "encode")
      encode "$OUT" "$IN" "$PRE";
    ;;
    "decode")
      decode "$OUT" "$IN" "$PRE";
    ;;
    *)
      echo "Operation not supported";
    ;;
  esac
else
  exit 1;
fi

# when you echo $? # should be 0 or 1
