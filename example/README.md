Examples for using [wasm_ffi](https://pub.dev/packages/wasm_ffi).

# Setup

To use the same native (c/c++) code on all platforms the following steps are required:

## Exports

The generated wasm file needs all exported function. To ensure that, one of the two can be done:
* Use EMSCRIPTEN_KEEPALIVE annotation on all exported functions
* Define EXPORTED_FUNCTIONS when compiling the wasm

## ffigen
Generates bindings using [`package:ffigen`](https://pub.dev/packages/ffigen).
Replace `import 'dart:ffi' as ffi;` with `import 'package:wasm_ffi/ffi_bridge.dart' as ffi;` in the generated binding files.

## Generated Assets

* For Dart, ensure that all dyanamic libraries (.so/.dylib/.dll) and the wasm file are in the same folder and use the same name.
* For Flutter, ensure that the wasm file is added as an asset.

## Loading Libraries

Assuming all assets are in 'assets' folder, the native library can be loaded simply as:
```
  final FfiWrapper ffiWrapper = await FfiWrapper.load('assets/ModuleName');
  WasmFfiBindings bindings = WasmFfiBindings(ffiWrapper.library);

  // use bindings
  using((Arena arena) {
    ...
  });
```

# Build all assets
On Linux and macOS, run:
```
make build
```
This uses mingw cross-compiler on Linux to build Windows dll.

# Run examples

## Run Flutter app

Flutter app should run on all platforms.

## Run vanilla dart web app (uses wasm)

Running the example app requires [`package:webdev`](https://dart.dev/tools/webdev).
```
dart pub global activate webdev
```

To run the web app, cd to example_dart folder and run:
```
webdev serve
```
Then open http://localhost:8080 in your browser

## Run vanilla dart native app (uses ffi)

To run the app, cd to example_dart folder and run:
```
dart run
```