.PHONY: all clean

PREFIX=/usr/local
DESTDIR=

all: coffeealloy.jmk

coffeealloy.jmk: coffeealloy.coffee
	coffee -b -p coffeealloy.coffee > coffeealloy.jmk

clean:
	rm coffeealloy.jmk
