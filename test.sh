#!/bin/sh

BIN="./mush.sh"

throw () {
  {
    printf "error: %s\n" "$@"
  } >&2
}

export USER="jwerle"
export GENDER="male"
export THING="apple"
export COLOR="red"
export PERSON="tobi"
export ADJECTIVE="cool"

i=0
cat ./test/tpl.ms | $BIN | while read line; do
  ((++i))

  case $i in
    1)
      expected="$USER is $GENDER"

      if [ "$line" != "$expected" ]; then
        throw "$i '$line' != '$expected'"
      fi
      ;;

    2)
      expected="$THING is $COLOR"

      if [ "$line" != "$expected" ]; then
        throw "$i '$line' != '$expected'"
      fi
      ;;


    3)
      expected="$PERSON is $ADJECTIVE"

      if [ "$line" != "$expected" ]; then
        throw "$i '$line' != '$expected'"
      fi
      ;;


    4)
      expected=""

      if [ "$line" != "$expected" ]; then
        throw "$i '$line' != '$expected'"
      fi
      ;;

    5)
      expected=""

      if [ "$line" != "$expected" ]; then
        throw "$i '$line' != '$expected'"
      fi
      ;;
  esac
done

echo "ok!"
