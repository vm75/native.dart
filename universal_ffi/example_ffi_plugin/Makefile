default: build

build: assets/example_ffi_plugin.js

SRC=src/example_ffi_plugin.c
DEPS=$(SRC) $(SRC:.c=.h)

# Wasm options
ifdef  DEBUG
	COMPILER_OPTIONS=-g3 --profiling-funcs -s ASSERTIONS=1 -fsanitize=address
	LINKER_OPTIONS=-Wl,--no-entry
else
	COMPILER_OPTIONS=-fPIC -Oz -fno-exceptions -fno-rtti -fno-stack-protector -ffunction-sections -fdata-sections -fno-math-errno -DNDEBUG
	LINKER_OPTIONS=-Wl,--gc-sections,--no-entry
endif
COMPILED_EXPORTS="EXPORTED_FUNCTIONS=[\"_malloc\", \"_free\"]"

lib/example_ffi_plugin_bindings_generated.dart: $(DEPS)
	dart run ffigen --config ffigen.yaml && sed -i "s#'dart:ffi'#'package:universal_ffi/ffi.dart'#g" $@

assets/example_ffi_plugin.js: $(DEPS) lib/example_ffi_plugin_bindings_generated.dart
	emcc -o assets/example_ffi_plugin.js $(COMPILER_OPTIONS) $(LINKER_OPTIONS) \
		$(SRC) \
		-s MODULARIZE=1 -s 'EXPORT_NAME="example_ffi_plugin"' -s ALLOW_MEMORY_GROWTH=1 \
		-s $(COMPILED_EXPORTS)
