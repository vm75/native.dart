.PHONY: clean

default: build

build: assets/WasmFfi.wasm assets/emscripten/WasmFfi.js assets/libWasmFfi.so assets/WasmFfi.dll

SRC=src/native.c
DEPS=$(SRC) $(SRC:.c=.h)
CFLAGS=-fPIC -fvisibility=hidden

# Wasm options
ifdef  DEBUG
    COMPILER_OPTIONS=-g3 --profiling-funcs -s ASSERTIONS=1 -fsanitize=address
    LINKER_OPTIONS=-Wl,--no-entry
else
    COMPILER_OPTIONS=-fPIC -Oz -fno-exceptions -fno-rtti -fno-stack-protector -ffunction-sections -fdata-sections -fno-math-errno -DNDEBUG
    LINKER_OPTIONS=-Wl,--gc-sections,--no-entry
endif
COMPILED_EXPORTS="EXPORTED_FUNCTIONS=[\"_malloc\", \"_free\"]"

clean:
	rm -rf assets/WasmFfi.wasm
	rm -rf assets/emscripten/WasmFfi.js
	rm -rf assets/libWasmFfi.so
	rm -rf assets/WasmFfi.dll

lib/wasmffi_bindings.dart: $(DEPS)
	dart run ffigen --config ffigen.yaml && sed -i "s#'dart:ffi'#'package:wasm_ffi/ffi_bridge.dart'#g" $@

assets/WasmFfi.wasm: $(DEPS) lib/wasmffi_bindings.dart
	emcc -o assets/WasmFfi.wasm $(COMPILER_OPTIONS) $(LINKER_OPTIONS) \
		$(SRC) \
		-s STANDALONE_WASM=1 \
		-s $(COMPILED_EXPORTS)

assets/emscripten/WasmFfi.js: $(DEPS) lib/wasmffi_bindings.dart
	emcc -o assets/emscripten/WasmFfi.js $(COMPILER_OPTIONS) $(LINKER_OPTIONS) \
		$(SRC) \
		-s MODULARIZE=1 -s 'EXPORT_NAME="WasmFfi"' -s ALLOW_MEMORY_GROWTH=1 \
		-s $(COMPILED_EXPORTS)

assets/libWasmFfi.so: $(DEPS) lib/wasmffi_bindings.dart
	clang -shared $(CFLAGS) -o $@ $(SRC)

assets/libWasmFfi.dylib: $(DEPS) lib/wasmffi_bindings.dart
	clang -dynamiclib $(CFLAGS) -o $@ $(SRC)

assets/WasmFfi.dll: $(DEPS) lib/wasmffi_bindings.dart
	x86_64-w64-mingw32-gcc -shared $(CFLAGS) -o $@ $(SRC)

run-wasm:
	cd ../example_dart && webdev serve

run-ffi:
	cd ../example_dart && dart run
