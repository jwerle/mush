#!/bin/sh

SELF="$0"
VERSION="0.0.1"
NULL=/dev/null
STDIN=0
STDOUT=1
STDERR=2
LEFT_DELIM="{{"
RIGHT_DELIM="}}"
INDENT_LEVEL="  "
ESCAPE=0
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
  echo "usage: mush [-ehV] [-f <file>] [-o <file>]"

  if [ "$1" = "1" ]; then
    echo
    echo "examples:"
    echo "  $ cat file.ms | FOO=BAR mush"
    echo "  $ VALUE=123 mush -f file.ms -o file"
    echo "  $ echo \"Today's date is {{DATE}}\" | DATE=\`date +%D\` mush"
    echo "  $ cat ./template.ms | VAR=VALUE mush"
    echo
    echo "options:"
    echo "  -f, --file <file>       file to parse"
    echo "  -o, --out <file>        output file"
    echo "  -e, --escape            escapes html html entities"
    echo "  -h, --help              display this message"
    echo "  -V, --version           output version"
  fi
}

mush () {
  ## read each line
  while IFS= read line; do
    echo "${line/$'\n'/}" | {
        ## read each ENV variable
        echo "$ENV" | {
          while read var; do
            ## split each ENV variable by '='
            ## and parse the line replacing
            ## occurrence of the key with
            ## guarded by the values of
            ## `LEFT_DELIM' and `RIGHT_DELIM'
            ## with the value of the variable
            case "$var" in
              (*"="*)
                key=${var%%"="*}
                val=${var#*"="*}
                ;;

              (*)
                key=$var
                val=
                ;;
            esac

            line="${line//${LEFT_DELIM}$key${RIGHT_DELIM}/$val}"
          done

          if [ "1" = "$ESCAPE" ]; then
            line="${line//&/&amp;}"
            line="${line//\"/&quot;}"
            line="${line//\</&lt;}"
            line="${line//\>/&gt;}"
          fi

          ## output to stdout
          echo "$line" | {
            ## parse undefined variables
            sed -e "s#${LEFT_DELIM}[A-Za-z]*${RIGHT_DELIM}##g" | \
            ## parse comments
            sed -e "s#${LEFT_DELIM}\!.*${RIGHT_DELIM}##g" | \
            ## escaping
            sed -e 's/\\\"/""/g'
          };
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
    -e|--escape)
      ESCAPE=1
      shift
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
