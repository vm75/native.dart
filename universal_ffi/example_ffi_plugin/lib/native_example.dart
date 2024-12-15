import 'dart:async';

import 'package:universal_ffi/ffi.dart';
import 'package:universal_ffi/ffi_helper.dart';
import 'package:universal_ffi/ffi_utils.dart';

import 'native_example_bindings.dart';

late final FfiHelper _ffiHelper;
late final NativeExampleBindings _bindings;

Future<bool> init() async {
  try {
    _ffiHelper = await FfiHelper.load(
      'native_example',
      options: {LoadOption.isFfiPlugin},
    );

    _bindings = NativeExampleBindings(_ffiHelper.library);
  } catch (e) {
    return false;
  }

  return true;
}

String getLibraryName() =>
    _bindings.getLibraryName().cast<Utf8>().toDartString();

String hello(String name) {
  return _ffiHelper.safeUsing(
    (Arena arena) {
      final cString = name.toNativeUtf8(allocator: arena).cast<Char>();
      return _bindings.hello(cString).cast<Utf8>().toDartString();
    },
  );
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
