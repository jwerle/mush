mush
====

Mustache templates for bash

## install

```sh
$ make install
```

## usage

***./template.ms***

```
VAR={VAR}
```

```sh
$ cat ./template.ms | VAR=VALUE mush
VAR=123
```

You can utilize stdin in the same way with `echo`

```sh
echo "Today's date is {DATE}" | DATE=`date +%D` mush
Today's date is 12/17/13
```

## api

```
usage: mush [-hV] [-f <file>] [-o <file>]

examples:
  $ cat file.ms | FOO=BAR mush
  $ VALUE=123 mush -f file.ms -o file
  $ echo "Today's date is {DATE}" | DATE=`date +%D` mush
  $ cat ./template.ms | VAR=VALUE mush

options:
  -f, --file <file>       file to parse
  -o, --out <file>        output file
  -h, --help              display this message
  -V, --version           output version
```

## license

MIT
