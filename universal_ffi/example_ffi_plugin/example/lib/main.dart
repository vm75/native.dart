import 'package:flutter/material.dart';

import 'package:example_ffi_plugin/example_ffi_plugin.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'UniversalFfi Example',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const ResultWidget(),
    );
  }
}

class ResultWidget extends StatefulWidget {
  const ResultWidget({super.key});

  @override
  State<ResultWidget> createState() => _ResultWidgetState();
}

class _ResultWidgetState extends State<ResultWidget> {
  Future<bool>? _futureResult;

  @override
  void initState() {
    super.initState();
    _futureResult = init();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Universal FFI Result'),
      ),
      body: Center(
        child: FutureBuilder<bool>(
          future: _futureResult,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else if (snapshot.hasData && snapshot.data == true) {
              return Column(
                children: [
                  Text(
                    'Hello result: ${hello("plugin")}',
                    style: const TextStyle(fontSize: 16),
                  ),
                  Text(
                    'Size of Int: ${sizeOfInt()}',
                    style: const TextStyle(fontSize: 16),
                  ),
                  Text(
                    'Size of Bool: ${sizeOfBool()}',
                    style: const TextStyle(fontSize: 16),
                  ),
                  Text(
                    'Size of Pointer: ${sizeOfPointer()}',
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
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
