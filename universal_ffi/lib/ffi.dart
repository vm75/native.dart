library universal_ffi;

export 'package:wasm_ffi/ffi.dart'
    if (dart.library.ffi) 'src/dart_ffi/_ffi.dart';
