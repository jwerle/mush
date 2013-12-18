#!/bin/sh

SELF="$0"
VERSION="0.0.1"
NULL=/dev/null
STDIN=0
STDOUT=1
STDERR=2
LEFT_DELIM="{"
RIGHT_DELIM="}"
ENV="`env`"
out=">&$STDOUT"

if [ -t 0 ]; then
  ISATTY=1
else
  ISATTY=0
fi

version () {
  echo $VERSION
}

usage () {
  echo "usage: mush [-hV] [-f <file>] [-o <file>]"

  if [ "$1" = "1" ]; then
    echo
    echo "examples:"
    echo "  $ cat file.ms | FOO=BAR mush"
    echo "  $ VALUE=123 mush -f file.ms -o file"
    echo "  $ echo \"Today's date is {DATE}\" | DATE=\`date +%D\` mush"
    echo "  $ cat ./template.ms | VAR=VALUE mush"
    echo
    echo "options:"
    echo "  -f, --file <file>       file to parse"
    echo "  -o, --out <file>        output file"
    echo "  -h, --help              display this message"
    echo "  -V, --version           output version"
  fi
}

mush () {
  ## read each line
  while read line; do
    echo "$line" | {
        ## read each ENV variable
        echo "$ENV" | {
          while read var; do
            ## split each ENV variable by '='
            ## and parse the line replacing
            ## occurrence of the key with
            ## guarded by the values of
            ## `LEFT_DELIM' and `RIGHT_DELIM'
            ## with the value of the variable
            IFS="="; read -ra part <<< "$var";
            key="${part[0]}"
            val="${part[1]}"
            line="${line//${LEFT_DELIM}$key${RIGHT_DELIM}/$val}"
            unset IFS
          done

          ## output to stdout
          echo "$line" | sed -e "s#${LEFT_DELIM}[A-Za-z]*${RIGHT_DELIM}##g"
        }
    };
  done
}

while true; do
  arg="$1"

  if [ "" = "$1" ]; then
    break;
  fi

  if [ "${arg:0:1}" != "-" ]; then
    shift
    continue
  fi

  case $arg in
    -f|--file)
      file="$2";
      shift 2;
      ;;
    -o|--out)
      out="> $2";
      shift 2;
      ;;
    -h|--help)
      usage 1
      exit 1
      ;;
    -V|--version)
      version
      exit 0
      ;;
    *)
      {
        echo "unknown option \`$arg'"
      } >&$STDERR
      usage
      exit 1
      ;;
  esac
done

if [ "0" = "$ISATTY" ]; then
  eval "mush $out"
elif [ ! -z "$file" ]; then
  eval "cat $file | mush $out"
else
  usage
  exit 1
fi

exit $?
