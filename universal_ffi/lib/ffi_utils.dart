library universal_ffi;

export 'package:wasm_ffi/ffi_utils.dart'
    if (dart.library.ffi) 'src/dart_ffi/_ffi_utils.dart';
