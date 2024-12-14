import 'package:example/example.dart';
import 'package:web/web.dart';

Element createKeyVal(String key, String value) {
  final div = document.createElement('p');
  final label = document.createElement('strong');
  label.text = '$key: ';
  div.append(label);
  final span = document.createElement('span');
  span.text = value;
  div.append(span);
  return div;
}

Future<Element> runTests(String source, String name) async {
  final container = document.createElement('div');
  final header = document.createElement('h2');
  header.text = 'Test WasmFfi ($name)';
  container.append(header);
  final runner = await Example.create('assets/$source');
  container.append(createKeyVal('Library Name', runner.getLibraryName()));
  container.append(createKeyVal('Hello String', runner.hello(name)));
  container.append(createKeyVal('Size of Int', runner.intSize().toString()));
  container.append(createKeyVal('Size of Bool', runner.boolSize().toString()));
  container
      .append(createKeyVal('Size of Pointer', runner.pointerSize().toString()));
  return container;
}

void main() {
  final app = (document.querySelector('body')! as HTMLElement);

  final container = document.createElement('div');
  final header = document.createElement('h2');
  header.text = 'wasm-ffi tests';
  container.append(header);

  app.append(container);

  runTests('native_example.js', 'Emscripten').then((result) {
    container.append(result);
  });
}
