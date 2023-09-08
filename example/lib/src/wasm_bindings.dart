// AUTO GENERATED FILE, DO NOT EDIT.
//
// Generated by `package:ffigen`.
// ignore_for_file: type=lint
import 'package:wasm_ffi/proxy_ffi.dart' as ffi;

/// Bindings for Wasm.
class WasmBindings {
  /// Holds the symbol lookup function.
  final ffi.Pointer<T> Function<T extends ffi.NativeType>(String symbolName)
      _lookup;

  /// The symbols are looked up in [dynamicLibrary].
  WasmBindings(ffi.DynamicLibrary dynamicLibrary)
      : _lookup = dynamicLibrary.lookup;

  /// The symbols are looked up with [lookup].
  WasmBindings.fromLookup(
      ffi.Pointer<T> Function<T extends ffi.NativeType>(String symbolName)
          lookup)
      : _lookup = lookup;

  /// hello world
  ffi.Pointer<ffi.Char> hello(
    ffi.Pointer<ffi.Char> text,
  ) {
    return _hello(
      text,
    );
  }

  late final _helloPtr = _lookup<
      ffi.NativeFunction<
          ffi.Pointer<ffi.Char> Function(ffi.Pointer<ffi.Char>)>>('hello');
  late final _hello = _helloPtr
      .asFunction<ffi.Pointer<ffi.Char> Function(ffi.Pointer<ffi.Char>)>();

  /// free up the memory allocated by the library
  void freeMemory(
    ffi.Pointer<ffi.Char> buffer,
  ) {
    return _freeMemory(
      buffer,
    );
  }

  late final _freeMemoryPtr =
      _lookup<ffi.NativeFunction<ffi.Void Function(ffi.Pointer<ffi.Char>)>>(
          'freeMemory');
  late final _freeMemory =
      _freeMemoryPtr.asFunction<void Function(ffi.Pointer<ffi.Char>)>();
}
