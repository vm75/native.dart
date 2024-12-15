.PHONY: version build run test

version:
	bash ./tool/update-version.sh

build:
	cp -f example/src/* example_flutter/src/
	cd example && make build
	cp -rf example/web/assets/* example_flutter/assets/

run:
	cd example && make run

test:
	dart run build_runner test -- -p chrome