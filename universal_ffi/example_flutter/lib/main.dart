import 'package:flutter/material.dart';

import 'example.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'WasmFfi Example',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const ResultWidget(
        libName: 'assets/native_example',
        name: 'emscripten',
      ),
    );
  }
}

class ResultWidget extends StatefulWidget {
  final String libName;
  final String name;

  const ResultWidget({super.key, required this.libName, required this.name});

  @override
  State<ResultWidget> createState() => _ResultWidgetState();
}

class _ResultWidgetState extends State<ResultWidget> {
  Future<Result>? _futureResult;

  @override
  void initState() {
    super.initState();
    _futureResult = testWasmFfi(widget.libName, widget.name);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('WASM FFI Result'),
      ),
      body: Center(
        child: FutureBuilder<Result>(
          future: _futureResult,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else if (snapshot.hasData) {
              final result = snapshot.data!;
              return Text(
                result.toString(),
                style: const TextStyle(fontSize: 16),
              );
            } else {
              return const Text('No result available');
            }
          },
        ),
      ),
    );
  }
}
