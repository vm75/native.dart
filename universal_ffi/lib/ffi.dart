library universal_ffi;

export 'package:wasm_ffi/ffi.dart'
    if (dart.library.ffi) 'src/_dart_ffi/ffi.dart';
