#!/bin/sh

SELF="$0"
VERSION="0.0.1"
VERBOSE=0
CLEAN=0
TEST=0
NULL=/dev/null
STDIN=0
STDOUT=1
STDERR=2
LEFT_DELIM="{"
RIGHT_DELIM="}"
ENV="`env`"

out="| cat"
dir="`pwd`"
deps="deps"
argv=${@}
argc="${#}"


if [ -t 0 ]; then
  ISATTY=1
else
  ISATTY=0
fi

version () {
  echo $VERSION
}

fprintf () {
  {
    printf "${@:2}"
  } >&$1
}

verbose () {
  if [ "1" -eq "$VERBOSE" ]
  then
    printf "verbose: %s\n" "$@"
  fi
}

info () {
  printf "   %s\n" "$@"
}

warn () {
  printf "warn: %s\n" "$@"
}

error () {
  fprintf $STDERR "$@"
  fprintf $STDERR "\n"
}

throw () {
  error "$@"
  exit 1
}

usage () {
  echo "usage: mush [-hvV] [-f <file>] [-o <file>]"

  if [ "$1" = "1" ]; then
    echo
    echo "examples:"
    echo "  $ cat file.ms | FOO=BAR mush"
    echo "  $ VALUE=123 mush -f file.ms -o file"
    echo "  $ echo \"Today's date is {DATE}\" | DATE=`date +%D` mush"
    echo "  $ cat ./template.ms | VAR=VALUE mush"
    echo
    echo "options:"
    echo "  -f, --file <file>       file to parse"
    echo "  -o, --out <file>        output file"
    echo "  -h, --help              display this message"
    echo "  -v, --verbose           show verbose output"
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
            i=0

            ## split each ENV variable by '='
            ## and parse the line replacing
            ## occurrence of the key with
            ## guarded by the values of
            ## `LEFT_DELIM' and `RIGHT_DELIM'
            ## with the value of the variable
            while IFS="=" read -ra part; do
              ((++i))
              key="${part[0]}"
              val="${part[1]}"
              line="${line//${LEFT_DELIM}$key${RIGHT_DELIM}/$val}"

              if [ "2" = "$i" ]; then
                break;
              fi
            done <<< "$var";

          done

          #line="${line//${LEFT_DELIM}*${RIGHT_DELIM}/}"

          ## output to stdout
          echo "$line" | sed -e "s#{[A-Za-z]*}##g"
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
    -v|--verbose)
      VERBOSE=1;
      shift;
      ;;
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
      error "unknown option \`$arg'"
      usage
      exit 1
      ;;
  esac
done

if [ "0" = "$ISATTY" ]; then
  eval "mush $out"
elif [ "0" != "$file" ]; then
  eval "cat $file | mush $out"
else
  usage
  exit 1
fi

exit $?
