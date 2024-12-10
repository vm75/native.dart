library app_type;

export 'src/_wasm_ffi/app_type.dart'
    if (dart.library.ffi) 'src/_dart_ffi/app_type.dart';

enum AppType { android, ios, linux, macos, windows, web, unknown }
