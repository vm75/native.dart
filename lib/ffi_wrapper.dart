library wasm_ffi_wrapper;

import 'app_type.dart';
import 'ffi_bridge.dart';
import 'ffi_utils_bridge.dart';
import 'src/_wasm_ffi/helper.dart'
    if (dart.library.ffi) 'src/_dart_ffi/helper.dart';

export 'src/_wasm_ffi/helper.dart'
    if (dart.library.ffi) 'src/_dart_ffi/helper.dart';

class FfiWrapper {
  final DynamicLibrary _library;

  FfiWrapper._(this._library);

  DynamicLibrary get library => _library;

  /// Loads a dynamic library from the specified [modulePath] and returns
  /// an [FfiWrapper] instance encapsulating the library.
  ///
  /// If the module is statically linked on Android or iOS, it returns
  /// a reference to the current process's dynamic library.
  ///
  /// [modulePath]: The path to the module to be loaded.
  /// [overrides]: [AppType] specific overrides to the path to the module to be loaded.
  ///
  /// Returns a [Future] that completes with an [FfiWrapper] instance.
  /// Throws an [ArgumentError] if the module cannot be found.
  static Future<FfiWrapper> load(
    String modulePath, {
    Map<AppType, String> overrides = const {},
  }) async {
    final resolvedModulePath =
        overrides[appType] ?? resolveModulePath(modulePath);

    // Handle statically linked modules for Android/iOS
    if (resolvedModulePath.isEmpty) {
      return FfiWrapper._(DynamicLibrary.process());
    }

    return FfiWrapper._(
      await DynamicLibrary.open(resolvedModulePath),
    );
  }

  /// Runs the provided [computation] function within an [Arena],
  /// ensuring that all allocations are released upon completion.
  ///
  /// If [allocator] is provided, it is used for allocations; otherwise,
  /// the default allocator from the library is used.
  ///
  /// This method is useful when multiple wasm modules are loaded
  /// and it ensures that the library-specific allocator is used.
  ///
  /// Returns the result of the [computation].
  R safeUsing<R>(R Function(Arena) computation, [Allocator? allocator]) {
    return using(computation, allocator ?? _library.memory);
  }
}
