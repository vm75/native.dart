# universal_ffi

![Pub Version](https://img.shields.io/pub/v/universal_ffi)
![Pub Points](https://img.shields.io/pub/points/universal_ffi)
![Pub Popularity](https://img.shields.io/pub/popularity/universal_ffi)
![Pub Likes](https://img.shields.io/pub/likes/universal_ffi)

`universal_ffi` is a wrapper on top of `wasm_ffi` and `dart:ffi` to provide a consistent API across all platforms.
It also has some helper methods to make it easier to use.

`wasm_ffi` has a few limitations, so some of the features of `dart:ffi` are not supported.

## Usage

### Install
```
dart pub add universal_ffi
```

or
```
flutter pub add universal_ffi
```

### ffigen
Generates bindings using [`package:ffigen`](https://pub.dev/packages/ffigen).
Replace `import 'dart:ffi' as ffi;` with `import 'package:universal_ffi/ffi.dart' as ffi;` in the generated binding files.

### Using FfiHelper
```
import 'package:universal_ffi/ffi.dart';
import 'package:universal_ffi/ffi_helper.dart';
import 'package:universal_ffi/ffi_utils.dart';
import 'native_example_bindings.dart';

...
  final ffiHelper = await FfiHelper.load('ModuleName');
  final bindings = WasmFfiBindings(ffiHelper.library);

  // use bindings
  using((Arena arena) {
    ...
  }, ffiHelper.library.memory);
...
```

## Features

### DynamicLibrary.openAsync
DynamicLibrary.open is synchronous for 'dart:ffi', but asynchronous for 'wasm_ffi'. This helper method uses both asynchronously.

### FfiHelper.load
FfiHelper.load resolves the modulePath to the platform specific path in a variety of ways.

#### basic case
In the case, it is assumed that all platforms load a shared library from the same relative path.
For example, if the modulePath = 'path/name', then the following paths are used:
- Web: 'path/name.wasm' or 'path/name.js' (if wasmNeedsJs option is specified)
- Linux & Android: 'path/name.so'
- Windows: 'path/name.dll'
- macOS & iOS: 'path/name.dylib'

#### isStaticallyLinked
If the modulePath = 'path/name' and isStaticallyLinked option is specified, then the following paths are used:
- Web: 'path/name.wasm' or 'path/name.js' (if wasmNeedsJs option is specified)
- All other platforms: Instead of loading a shared library, calls DynamicLibrary.process().

#### isPlugin (used for Flutter Ffi Plugin)
If the modulePath = 'path/name' and isPlugin option is specified, then 'path' is ignored and the following paths are used:
- Web: 'assets/packages/name/assets/name.wasm' or 'assets/packages/name/assets/name.js' (if wasmNeedsJs option is specified)
- Linux & Android: 'name.so'
- Windows: 'name.dll'
- macOS & iOS: 'name.framework/name'

#### overrides
Overrides can be used to specify the path to the module to be loaded for specific [AppType].
Override strings are used as is.

#### Multiple wasm_ffi modules in the same project
If you have multiple wasm_ffi modules in the same project, the global memory will refer only to the first loaded module.
So unless the memory is explicitly specified, the memory from the first loaded module will be used for all modules, causing unexpected behavior.
One option is to explicitly use library.memory for wasm & malloc/calloc for ffi.
Alternatively, you can use FfiHelper.safeUsing or FfiHelper.safeWithZoneArena:

#### FfiHelper.safeUsing
`FfiHelper.safeUsing` is a wrapper for `using`. It ensures that the library-specific memory is used.

#### FfiHelper.safeWithZoneArena
`FfiHelper.safeWithZoneArena` is a wrapper for `withZoneArena`. It ensures that the library-specific memory is used.
