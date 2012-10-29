coffeealloy
===========

CoffeeScript preprocesser for Titanium Alloy Framework

Example `alloy.jmk` content:

    var path = require('path');

    task("pre:compile", function(event,logger) {
        var coffeealloy = require(path.join(event.dir.home, 'coffeealloy.jmk'));
        coffeealloy.pre_compile(event, logger)
    });

    task("post:compile",function(event,logger){
        var coffeealloy = require(path.join(event.dir.home, 'coffeealloy.jmk'));
        coffeealloy.post_compile(event, logger)
    });

