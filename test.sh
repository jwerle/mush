#!/usr/bin/env bash

BIN="./mush.sh"
FILE="./test/tpl.ms"
i=0

throw () {
  {
    printf " \n error: \`%s'\n" "$@"
  } >&2
  exit 1
}

export USER="jwerle"
export PRONOUNS="he/him"
export THING="apple"
export COLOR="red"
export PERSON="tobi"
export ADJECTIVE="cool"

echo
echo " $FILE"
cat < "$FILE" | $BIN | while read -r line; do
  ((++i))

  echo " $i $line"
  case $i in
    1)
      # {{! this is a comment }}
      expected=""

      if [ "$line" != "$expected" ]; then
        throw "$i '$line' != '$expected'"
      fi
      ;;

    2)
      expected=""

      if [ "$line" != "$expected" ]; then
        throw "$i '$line' != '$expected'"
      fi
      ;;

    3)
      expected="$USER is $PRONOUNS"

      if [ "$line" != "$expected" ]; then
        throw "$i '$line' != '$expected'"
      fi
      ;;

    4)
      expected="$THING is $COLOR"

      if [ "$line" != "$expected" ]; then
        throw "$i '$line' != '$expected'"
      fi
      ;;

    5)
      expected="$PERSON is $ADJECTIVE"

      if [ "$line" != "$expected" ]; then
        throw "$i '$line' != '$expected'"
      fi
      ;;

    6)
      expected="$USER is friends with $PERSON"

      if [ "$line" != "$expected" ]; then
        throw "$i '$line' != '$expected'"
      fi
      ;;

    7)
      expected=''

      if [ "$line" != "$expected" ]; then
        throw "$i '$line' != '$expected'"
      fi
      ;;

    8)
      expected="has \w backslashes"

      if [ "$line" != "$expected" ]; then
        throw "$i '$line' != '$expected'"
      fi
      ;;

    9)
      expected=''

      if [ "$line" != "$expected" ]; then
        throw "$i '$line' != '$expected'"
      fi
      ;;

  esac
done


# shellcheck disable=SC2181
if (( $? == 0 )); then
  echo
  echo "+ ok!"
else
  echo
  echo "x fail"
  exit 1
fi
