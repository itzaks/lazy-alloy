lazy-alloy
==========

`lazy-alloy` is a CoffeeScript & Jade preprocessor for [Titanium Alloy Framework](http://projects.appcelerator.com/alloy/docs/Alloy-bootstrap/index.html).

`lazy-alloy` will

* compile all `*.coffee` scripts to corresponding `js` files in `src/controllers/` to `app/controllers/`.
* compile all `*.coffee` jsons to corresponding `tss` files in `src/styles/` to `app/styles/`.
* compile all `*.jade` templates to corresponding `xml` files in `src/views/` to `app/views/`.
* compile all `*.coffee` scripts to corresponding `js` files in `src/models/` to `app/models/`.
* compile widgets in `src/widgets` stored in the following directories:
  * compile all `*.coffee` scripts to corresponding `js` files in `src/widgets/<widgetName>/controllers` to `app/widgets/<widgetName>/controllers`.
  * compile all `*.coffee` jsons to corresponding `tss` files in `src/widgets/<widgetName>/styles` to `app/widgets/<widgetName>/styles`.
  * compile all `*.jade` templates to corresponding `xml` files in `src/widgets/<widgetName>/views` to `app/widgets/<widgetName>/views`.

Inspired by [coffee-alloy](https://github.com/brantyoung/coffee-alloy) but eventually grew out of its box. The code is lazy but does its job, feel free to improve.


## Usage

### Dependencies
* nodejs
* npm
* titanium *(cli)*
* alloy
* brain *(optional)*

### ???¿¿¿

1. `npm install -g lazy-alloy`
2. Navigate to project root folder
3. `lazyalloy new`
4. Write CoffeeScript / Jade in `src/**/`
5. `lazyalloy watch -p ios`

### Good to know
the styles files needs to begin with `somevariable =` like so (for the compilation to work):

    tss =
      width: "50%"
      backgroundColor: '#fff'

###Options
    Usage: lazyalloy [COMMAND] [OPTIONS]

    Commands:

      compile                Just compile.
      watch                  Watch file changes & compile.
      build <platform>       Run titanium on `platform`
      new                    Setup the lazy-alloy directory structure.
      generate <type> <name> Generate a new (lazy-)alloy type such as a controller.

    Options:

      -h, --help                 output usage information
      -V, --version              output the version number
      -p, --platform [platform]  (watch) When done, run titanium on `platform`
      -d, --directory [dirname]  Set source directory (default `src/`)


![AFRICA!](http://24.media.tumblr.com/60efb9b1b8da24b3250c1ab21232c2b8/tumblr_mhtwirmVV51r8sj1to1_500.jpg)
