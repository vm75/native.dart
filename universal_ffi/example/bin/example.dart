import 'package:example/example.dart';

void printValue(String id, String value) {
  // ignore: avoid_print
  print('$id: $value');
}

void main(List<String> arguments) {
  testWasmFfi('assets/native_example', 'Ffi').then(
    (result) => {
      printValue('wasm-hello-str', result.helloStr),
      printValue('wasm-size-of-int', result.sizeOfInt.toString()),
      printValue('wasm-size-of-bool', result.sizeOfBool.toString()),
      printValue('wasm-size-of-pointer', result.sizeOfPointer.toString()),
    },
  );
}
