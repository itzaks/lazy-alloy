# coffee-alloy

`coffee-alloy` is a CoffeeScript preprocessor for [Titanium Alloy Framework](http://projects.appcelerator.com/alloy/docs/Alloy-bootstrap/index.html).

`coffee-alloy` will compile all `*.coffee` scripts to corresponding `js` files in your `[project_root]/app/` directory.

## Install

### Prerequisites

* [nodejs](http://nodejs.org/) > 0.8
* [coffeescript](http://coffeescript.org/)
* [node-glob](https://npmjs.org/package/glob)
* [titanium](https://npmjs.org/package/titanium)
* [alloy](https://npmjs.org/package/alloy)

### Ubuntu

Install most up-to-date [PPA for nodejs and npm](https://launchpad.net/~chris-lea/+archive/node.js/)

    sudo add-apt-repository ppa:chris-lea/node.js  
    sudo apt-get update  
    sudo apt-get install nodejs npm

Install `coffeescript` and `node-glob`:

    sudo apt-get install coffeescript node-glob

Install titanium and alloy:

    sudo npm install -g titanium
    sudo npm install -g alloy

## Setup

1. Generate `alloy.jmk`: navigate to the root directory of your Alloy project and run the following command in the console:
    alloy generate jmk
1. Download latest [coffee-alloy preprocessor](https://raw.github.com/brantyoung/coffee-alloy/master/coffeealloy.jmk), and save as `[project_root]/app/coffeealloy.jmk`
1. Edit genrated `alloy.jmk` file, and invoke `coffee-alloy preporcessor` like this:
        
        var path = require('path');
    
        task("pre:compile", function(event,logger) {
            var coffeealloy = require(path.join(event.dir.home, 'coffeealloy.jmk'));
            coffeealloy.pre_compile(event, logger)
        });
    
        task("post:compile",function(event,logger){
            logger.info('compile finished!');
        });
