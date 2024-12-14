import 'package:example/example.dart';

void printValue(String id, String value) {
  // ignore: avoid_print
  print('$id: $value');
}

void main(List<String> arguments) {
  Example.create('assets/native_example').then((runner) {
    printValue('Library Name', runner.getLibraryName());
    printValue('Hello String', runner.hello('universal_ffi'));
    printValue('Size of Int', runner.intSize().toString());
    printValue('Size of Bool', runner.boolSize().toString());
    printValue('Size of Pointer', runner.pointerSize().toString());
  });
}
