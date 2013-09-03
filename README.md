lazy-alloy
==========

`lazy-alloy` is a CoffeeScript & Jade preprocessor for [Titanium Alloy Framework](http://projects.appcelerator.com/alloy/docs/Alloy-bootstrap/index.html).

##What does it do?

It makes you write a tiny bit less code. Perhaps also a bit more readable (¿¿¿) code as well.

Compile from sourcefile | To alloy readable output
------------ | -------------
`src/controllers/{{name}}.coffee` | `app/controllers/{{name}}.js`
`src/styles/{{name}}.coffee` | `app/styles/{{name}}.tss`
`src/views/{{name}}.jade` | `app/views/{{name}}.xml`
`src/models/{{name}}.coffee` | `app/models/{{name}}.js`

Also, it will compile your widgets from src/widgets stored in the following directories.

From | To 
------------ | -------------
`src/widgets/{{widget-name}}/controllers/*.coffee` | `app/widgets/{{widget-name}}/controllers/*.js` 
`src/widgets/{{widget-name}}/styles/*.coffee` | `app/widgets/{{widget-name}}/styles/*.tss`
`src/widgets/{{widget-name}}/views/*.jade` | `app/widgets/{{widget-name}}/views/*.xml` 

Inspired by [coffee-alloy](https://github.com/brantyoung/coffee-alloy) but eventually grew out of its box. Feel free to improve.


## Usage

### Dependencies
* nodejs
* npm
* titanium *(cli)*
* alloy
* brain *(optional)*

### Installation
1. Install [Titanium Alloy Framework](http://projects.appcelerator.com/alloy/docs/Alloy-bootstrap/index.html).
2. `npm install -g lazy-alloy`

### Note regarding the \*.coffee –> \*.tss conversion
The files need to be valid coffee-script objects; thus the first line of these files needs to be a variable assignment like the following

    tss =
	  ".container":
	    backgroundColor: "red"

	  "Label":
		width: Ti.UI.SIZE
		height: Ti.UI.SIZE
		color: "#fff"

      
Its output will look like this:

    ".container": {
      backgroundColor: "red"
    },
    "Label": {
      width: Ti.UI.SIZE,
      height: Ti.UI.SIZE,
      color: "#fff"
    }

Perhaps something like *stylus* would be a better fit for this kind of job. Feel free to help us improve this section!

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
