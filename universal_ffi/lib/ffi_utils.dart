/// Utilities for working with Foreign Function Interface (FFI) code, incl.
/// converting between Dart strings and C strings encoded with UTF-8 and UTF-16.
///
/// This is quivalent to the `package:ffi/ffi.dart` package for all platforms.
library universal_ffi_utils;

export 'package:wasm_ffi/ffi_utils.dart'
    if (dart.library.ffi) 'src/dart_ffi/_ffi_utils.dart';
