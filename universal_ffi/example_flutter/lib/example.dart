library example;

import 'package:universal_ffi/ffi.dart';
import 'package:universal_ffi/ffi_helper.dart';
import 'package:universal_ffi/ffi_utils.dart';
import 'native_example_bindings.dart';

class Result {
  final String helloStr;
  int sizeOfInt;
  int sizeOfBool;
  int sizeOfPointer;

  Result(this.helloStr, this.sizeOfInt, this.sizeOfBool, this.sizeOfPointer);

  @override
  String toString() {
    return 'hello: $helloStr, int: $sizeOfInt, bool: $sizeOfBool, pointer: $sizeOfPointer';
  }
}

Future<Result> testWasmFfi(String libName, String name) async {
  final FfiHelper ffiHelper = await FfiHelper.load(libName);

  final bindings = NativeExampleBindings(ffiHelper.library);

  return ffiHelper.safeUsing((Arena arena) {
    final cString = name.toNativeUtf8(allocator: arena).cast<Char>();
    final helloStr = bindings.hello(cString).cast<Utf8>().toDartString();
    final sizeOfInt = bindings.intSize();
    final sizeOfBool = bindings.boolSize();
    final sizeOfPointer = bindings.pointerSize();
    return Result(helloStr, sizeOfInt, sizeOfBool, sizeOfPointer);
  });
}
