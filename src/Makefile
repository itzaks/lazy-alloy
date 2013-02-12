.PHONY: all clean

PREFIX=/usr/local
DESTDIR=

all: lazy-alloy.js

lazy-alloy.js: lazy-alloy.coffee
	coffee -b -c lazy-alloy.coffee > lazy-alloy.js && mv lazy-alloy.js ../

clean:
	rm lazy-alloy.js