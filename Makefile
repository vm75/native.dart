.PHONY: update-version build run

update-version:
	bash ./tools/update-version.sh

test:
	cd wasm_ffi && make test

sync:
	rsync -auv wasm_ffi/example/src/ universal_ffi/example/src/
	rsync -auv universal_ffi/example/src/ wasm_ffi/example/src/

build:
	cd wasm_ffi/example && make build
	cd universal_ffi/example && make build

run:
	cd wasm_ffi/example && make run

run-wasm:
	cd universal_ffi/example && make run-wasm

run-ffi:
	cd universal_ffi/example && make run-ffi