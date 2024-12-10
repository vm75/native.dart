import 'package:wasm_ffi/app_type.dart';
import 'package:wasm_ffi/ffi_bridge.dart';
import 'package:wasm_ffi/ffi_utils_bridge.dart';
import 'package:wasm_ffi/ffi_wrapper.dart';
import 'wasmffi_bindings.dart';

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
  final FfiWrapper ffiWrapper = await FfiWrapper.load(libName, overrides: {
    AppType.android: 'libWasmFfi.so',
  });

  WasmFfiBindings bindings = WasmFfiBindings(ffiWrapper.library);

  return ffiWrapper.safeUsing((Arena arena) {
    Pointer<Char> cString = name.toNativeUtf8(allocator: arena).cast<Char>();
    String helloStr = bindings.hello(cString).cast<Utf8>().toDartString();
    int sizeOfInt = bindings.intSize();
    int sizeOfBool = bindings.boolSize();
    int sizeOfPointer = bindings.pointerSize();
    return Result(helloStr, sizeOfInt, sizeOfBool, sizeOfPointer);
  });
}
