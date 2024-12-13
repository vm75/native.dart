import 'dart:async';

import 'package:universal_ffi/ffi.dart';
import 'package:universal_ffi/ffi_helper.dart';
import 'package:universal_ffi/ffi_utils.dart';

import 'example_ffi_plugin_bindings_generated.dart';

late final FfiHelper _ffiHelper;
late final ExampleFfiPluginBindings _bindings;

Future<bool> init() async {
  try {
    _ffiHelper = await FfiHelper.load(
      'example_ffi_plugin',
      options: {LoadOption.isFfiPlugin},
    );

    _bindings = ExampleFfiPluginBindings(_ffiHelper.library);
  } catch (e) {
    return false;
  }

  return true;
}

String hello(String name) {
  return _ffiHelper.safeUsing((Arena arena) {
    final cString = name.toNativeUtf8(allocator: arena).cast<Char>();
    return _bindings.hello(cString).cast<Utf8>().toDartString();
  });
}

int sizeOfInt() {
  return _bindings.intSize();
}

int sizeOfBool() {
  return _bindings.boolSize();
}

int sizeOfPointer() {
  return _bindings.pointerSize();
}
