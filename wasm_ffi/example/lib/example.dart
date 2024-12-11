library example;

import 'package:wasm_ffi/ffi.dart';
import 'package:wasm_ffi/ffi_utils.dart';
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
  final library = await DynamicLibrary.open(libName);
  final bindings = NativeExampleBindings(library);

  return using((Arena arena) {
    final cString = name.toNativeUtf8(allocator: arena).cast<Char>();
    final helloStr = bindings.hello(cString).cast<Utf8>().toDartString();
    final sizeOfInt = bindings.intSize();
    final sizeOfBool = bindings.boolSize();
    final sizeOfPointer = bindings.pointerSize();
    return Result(helloStr, sizeOfInt, sizeOfBool, sizeOfPointer);
  }, library.memory); // library.memory is optional if only one module is loaded
}
