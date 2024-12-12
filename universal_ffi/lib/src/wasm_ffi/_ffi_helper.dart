import 'package:path/path.dart' as path;
import '../../ffi_helper.dart' show AppType;

/// Returns the type of the current app.
///
/// The type is determined by the platform.
AppType get appType {
  return AppType.web;
}

/// Returns the appropriate path for the module.
///
/// On web, the path is the same as the module path.
///
/// [modulePath] is the path to the shared library module.
/// [options] optional load options.
///   * isPlugin: indicates whether the module is a plugin.
///   * wasmNeedsJs: indicates whether the wasm needs js to run.
String resolveModulePath(String modulePath, Set<String> options) {
  var ext = path.extension(modulePath);
  final isPlugin = options.contains('isPlugin');
  final wasmNeedsJs = options.contains('wasmNeedsJs');
  if (ext == '') {
    ext = wasmNeedsJs ? '.js' : '.wasm';
    modulePath = '$modulePath$ext';
  }
  final moduleName = path.basenameWithoutExtension(modulePath);

  if (isPlugin) {
    return 'assets/packages/$moduleName/assets/$moduleName$ext';
  }

  return modulePath;
}
