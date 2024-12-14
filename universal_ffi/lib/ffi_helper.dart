/// Useful helpers for working with Foreign Function Interface (FFI).
library universal_ffi_helper;

import 'ffi.dart';
import 'ffi_utils.dart';
import 'src/wasm_ffi/_ffi_helper.dart'
    if (dart.library.ffi) 'src/dart_ffi/_ffi_helper.dart';

export 'src/wasm_ffi/_ffi_helper.dart'
    if (dart.library.ffi) 'src/dart_ffi/_ffi_helper.dart' show appType;

/// The type of the current app.
///
/// The type is determined by the platform.
///
/// Values:
/// - [android]: Android.
/// - [ios]: iOS.
/// - [linux]: Linux.
/// - [macos]: macOS.
/// - [windows]: Windows.
/// - [web]: Web.
/// - [unknown]: Unknown.
enum AppType {
  android,
  ios,
  linux,
  macos,
  windows,
  web,
  unknown,
}

enum LoadOption {
  isStaticallyLinked,
  isFfiPlugin,
  isStandaloneWasm,
}

/// Extension on [DynamicLibrary] with asynchronous methods.
extension AsyncDynamicLibrary on DynamicLibrary {
  /// Asynchronously opens a dynamic library from the specified [path].
  /// The ffi:DynamicLibrary.open is synchronous, but wasm_ffi:DynamicLibrary.open is asynchronous.
  /// This helper method uses both asynchronously.
  ///
  /// [path]: The file path to the dynamic library to be opened.
  ///
  /// Returns a [Future] that completes with the opened [DynamicLibrary] instance.
  /// Throws an [ArgumentError] if the library cannot be opened.
  Future<DynamicLibrary> openAsync(String path) async {
    final lib = await DynamicLibrary.open(path);
    return lib;
  }
}

/// A helper class that encapsulates a [DynamicLibrary] and provides a convenient
/// API for using the library.
class FfiHelper {
  final DynamicLibrary _library;

  FfiHelper._(this._library);

  /// Default allocator for this library
  Allocator get allocator => _library.allocator;

  /// The underlying [DynamicLibrary] instance.
  DynamicLibrary get library => _library;

  /// Loads a dynamic library from the specified [modulePath] and returns
  /// an [FfiHelper] instance encapsulating the library.
  ///
  /// Given [modulePath] as `<path>/<name>`, depending on the platform, it looks for
  /// `<name>.wasm`, `<name>.js`, `lib<name>.so`, `<name>.dll`, `lib<name>.dylib`
  /// in the same relative folder `<path>`.
  ///
  /// If `<name>.wasm` is used, it assumes Standalone wasm for web and
  /// `lib<name>.so`, `<name>.dll`, `lib<name>.dylib` for other platforms.
  ///
  /// If `<name>.js` is used, it assumes Emscripten wasm for web and
  /// `lib<name>.so`, `<name>.dll`, `lib<name>.dylib` for other platforms.
  ///
  /// [modulePath]: The path to the module to be loaded.
  /// [options]: Optional load options, all defaulting to false.
  ///   * isStaticallyLinked: non-web modules are statically linked.
  ///   * isFfiPlugin: this is a Ffi plugin.
  ///   * isStandaloneWasm: indicates whether the wasm is standalone.
  /// [overrides]: [AppType] specific overrides to the path to the module to be loaded.
  ///   * Empty override indicates that the module is statically linked.
  ///
  /// Returns a [Future] that completes with an [FfiHelper] instance.
  /// Throws an [ArgumentError] if the module cannot be found.
  static Future<FfiHelper> load(
    String modulePath, {
    Set<LoadOption> options = const {},
    Map<AppType, String> overrides = const {},
  }) async {
    modulePath = overrides[appType] ?? resolveModulePath(modulePath, options);

    // If module path is empty, it is treated as a statically linked library
    // This is not supported for Web/Wasm
    if (modulePath.isEmpty || options.contains(LoadOption.isStaticallyLinked)) {
      if (appType == AppType.web) {
        throw ArgumentError(
          'Statically linked library is not supported for Web/Wasm',
        );
      }
      return FfiHelper._(DynamicLibrary.process());
    }

    return FfiHelper._(
      await DynamicLibrary.open(modulePath),
    );
  }

  /// Safely runs the provided [computation] function within an [Arena],
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
    return using(computation, allocator ?? _library.allocator);
  }

  /// Safely runs the provided [computation] function within a zoned [Arena],
  /// ensuring that all allocations are released upon completion.
  ///
  /// If [allocator] is provided, it is used for allocations; otherwise,
  /// the default allocator from the library is used.
  ///
  /// This method is useful when multiple wasm modules are loaded
  /// and it ensures that the library-specific allocator is used.
  ///
  /// Returns the result of the [computation].
  R safeWithZoneArena<R>(R Function() computation, [Allocator? allocator]) {
    return withZoneArena(computation, allocator ?? _library.allocator);
  }
}
