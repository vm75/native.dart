.PHONY: update-version build run

update-version:
	bash ./tools/update-version.sh

test:
	cd wasm_ffi && make test

build:
	cp -f wasm_ffi/example/src/* wasm_ffi/example_flutter/src/
	cp -f wasm_ffi/example/src/* universal_ffi/example/src/
	cp -f wasm_ffi/example/src/* universal_ffi/example_ffi_plugin/src/
	cd wasm_ffi/example && make build
	cp -rf wasm_ffi/example/web/assets/* wasm_ffi/example_flutter/assets/
	cp -rf wasm_ffi/example/web/assets/emscripten/* universal_ffi/example/web/assets/
	cp -rf wasm_ffi/example/web/assets/emscripten/* universal_ffi/example_ffi_plugin/assets/

run-wasm:
	cd wasm_ffi/example && make run

run-uni-web:
	cd universal_ffi/example && make run-wasm

run-uni-ffi:
	cd universal_ffi/example && make run-ffi