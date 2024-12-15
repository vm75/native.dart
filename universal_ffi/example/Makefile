.PHONY: clean

UNAME_S := $(shell uname -s)

default: build

build: web/assets/native_example.js lib/native_example_bindings.dart \
	assets/libnative_example.so assets/native_example.dll assets/libnative_example.dylib

SRC=src/native_example.c
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
ifeq ($(UNAME_S), Linux)
	rm -f assets/libnative_example.so
	rm -f assets/native_example.dll
elifneq ($(filter Darwin,$(UNAME_S)),)
	rm -f assets/libnative_example.dylib
endif

lib/native_example_bindings.dart: $(DEPS)
	dart run ffigen --config ffigen.yaml && sed -i "s#'dart:ffi'#'package:universal_ffi/ffi.dart'#g" $@

web/assets/native_example.js: $(DEPS) lib/native_example_bindings.dart
	emcc -o web/assets/native_example.js $(COMPILER_OPTIONS) $(LINKER_OPTIONS) \
		$(SRC) \
		-s MODULARIZE=1 -s 'EXPORT_NAME="native_example"' -s ALLOW_MEMORY_GROWTH=1 \
		-s $(COMPILED_EXPORTS)

assets/libnative_example.so: $(DEPS)
ifeq ($(UNAME_S), Linux)
	clang -shared $(CFLAGS) -o $@ $(SRC)
endif

assets/libnative_example.dylib: $(DEPS)
ifeq ($(UNAME_S), Darwin)
	clang -dynamiclib $(CFLAGS) -o $@ $(SRC)
endif

assets/native_example.dll: $(DEPS)
ifeq ($(UNAME_S), Linux)
	x86_64-w64-mingw32-gcc -shared $(CFLAGS) -o $@ $(SRC)
endif

run-wasm:
	webdev serve

run-ffi:
	dart run
