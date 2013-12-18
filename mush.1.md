mush(1) -- Mustache templates for bash
=================================

## SYNOPSIS

`mush` [-hV] [-f <file>] [-o <file>]

## OPTIONS

  `-f, --file <file>`       file to parse
  `-o, --out <file>`        output file
  `-h, --help`              display this message
  `-V, --version`           output version

## USAGE
  
  $ cat file.ms | FOO=BAR mush
  $ VALUE=123 mush -f file.ms -o file
  $ echo "Today's date is {DATE}" | DATE=12/17/13 mush
  $ cat ./template.ms | VAR=VALUE mush

## AUTHOR

  - Joseph Werle <joseph.werle@gmail.com>

## REPORTING BUGS

  - https://github.com/jwerle/mush/issues

## SEE ALSO

  - http://mustache.github.io/
  - https://github.com/jwerle/mush

## LICENSE
  
  MIT (C) Copyright Joseph Werle 2013
