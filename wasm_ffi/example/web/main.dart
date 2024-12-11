import 'package:example/example.dart';
import 'package:web/web.dart';

void setValue(String id, String value) {
  (document.querySelector('#$id')! as HTMLElement).text = value;
}

void main() {
  testWasmFfi('assets/standalone/native_example.wasm', 'Standalone')
      .then((result) => {
            setValue('wasm-hello-str', result.helloStr),
            setValue('wasm-size-of-int', result.sizeOfInt.toString()),
            setValue('wasm-size-of-bool', result.sizeOfBool.toString()),
            setValue('wasm-size-of-pointer', result.sizeOfPointer.toString())
          });

  testWasmFfi('assets/emscripten/native_example.js', 'Emscripten')
      .then((result) => {
            setValue('js-hello-str', result.helloStr),
            setValue('js-size-of-int', result.sizeOfInt.toString()),
            setValue('js-size-of-bool', result.sizeOfBool.toString()),
            setValue('js-size-of-pointer', result.sizeOfPointer.toString())
          });
}
