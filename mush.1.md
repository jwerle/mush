mush(1) -- Mustache templates for bash
=================================

## SYNOPSIS

`mush` [-ehV] [-f <file>] [-o <file>]

## OPTIONS

  `-f, --file <file>`       file to parse
  `-o, --out <file>`        output file
  `-e, --escape`            escapes html html entities
  `-h, --help`              display this message
  `-V, --version`           output version

## EXAMPLES
  
  $ cat file.ms | FOO=BAR mush
  $ VALUE=123 mush -f file.ms -o file
  $ echo "Today's date is {{DATE}}" | DATE=\`date +%D\` mush
  $ cat ./template.ms | VAR=VALUE mush

## USAGE

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

  Variables are passed to the view vie environment variable
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
    content="`cat page.html.ms | name="home" mush`" \
    mush
    ```
## AUTHOR

  - Joseph Werle <joseph.werle@gmail.com>

## REPORTING BUGS

  - https://github.com/jwerle/mush/issues

## SEE ALSO

  - http://mustache.github.io/
  - https://github.com/jwerle/mush

## LICENSE
  
  MIT (C) Copyright Joseph Werle 2013
