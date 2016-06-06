mush
====

Mustache templates for bash

## install

With [bpkg](https://github.com/bpkg/bpkg):

```sh
$ bpkg install jwerle/mush
```

From source:

```sh
$ make install
```

## usage

Suppose you have a template file:

***./template.ms***

```
VAR={{VAR}}
```

You can compile it like such: 

```sh
$ cat ./template.ms | VAR=VALUE mush
VAR=123
```

You can utilize stdin in the same way with `echo`

```sh
echo "Today's date is {{DATE}}" | DATE=`date +%D` mush
Today's date is 12/17/13
```

Variables are passed to the view environment variable
definition. Due to the way variables are scoped to the
templates. All environment variables are available to the
template. This includes variables like `$HOME` and `$USER`

Compile a HTML file with partial:

***index.html.ms*** (layout)

```html
<!doctype html>
<html>
  <head>
    <meta http-equiv="content-type" content="text/html; charset=utf-8"/>
    <title>{{title}}</title>
    <link rel="stylesheet" href="{{main_css}}" type="text/css" />
    <script type="text/javascript" src="{{main_js}}" charset="utf-8"></script>
  </head>
  <body>
    <div id="app">
      {{content}}
    </div>
   </body>
</html>
```

***page.html.ms*** (partial)

```html
<div id="{{name}}" class="page"> This is the {{name}} page </div>
```

```sh
$ cat index.html.ms | \
  title="Awesome Web Site" \
  main_css="/css/main.css" \
  main_js="/js/main.js" \
  content="`cat page.html.ms | name=home mush`" \
  mush
```

This will yield:

```html
<!doctype html>
<html>
  <head>
    <meta http-equiv="content-type" content="text/html; charset=utf-8"/>
    <title>foo</title>
    <link rel="stylesheet" href="/css/main.css" type="text/css" />
    <script type="text/javascript" src="/js/app.js" charset="utf-8"></script>
  </head>
  <body>
    <div id="app">
      <div id="home" class="page"> This is the home page </div>
    </div>
  </body>
</html>
```

## api

```
usage: mush [-ehV] [-f <file>] [-o <file>]

examples:
  $ cat file.ms | FOO=BAR mush
  $ VALUE=123 mush -f file.ms -o file
  $ echo "Today's date is {DATE}" | DATE=`date +%D` mush
  $ cat ./template.ms | VAR=VALUE mush

options:
  -f, --file <file>       file to parse
  -o, --out <file>        output file
  -e, --escape            escapes html html entities
  -h, --help              display this message
  -V, --version           output version
```

## license

MIT
