lazy-alloy
==========

`lazy-alloy` is a CoffeeScript & Jade preprocessor for [Titanium Alloy Framework](http://projects.appcelerator.com/alloy/docs/Alloy-bootstrap/index.html).

`lazy-alloy` will  

* compile all `*.coffee` scripts to corresponding `js` files in `app/controllers/`.
* compile all `*.coffee` jsons to corresponding `tss` files in `app/styles/`.
* compile all `*.jade` templates to corresponding `xml` files in `app/views/`.

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
2. navigate to alloys `app/`
3. `lazy-alloy -w -p ios`

###Options
    -c, --compile              Just compile.
    -w, --watch                Watch file changes & compile.
    -p, --platform [platform]  Run titanium on `platform`
	

![AFRICA!](http://24.media.tumblr.com/60efb9b1b8da24b3250c1ab21232c2b8/tumblr_mhtwirmVV51r8sj1to1_500.jpg)