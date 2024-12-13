import 'package:path/path.dart' as path;
import '../../ffi_helper.dart' show AppType, LoadOption;

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
///   * isSfiPlugin: indicates whether the module is a plugin.
///   * isStandaloneWasm: indicates whether the wasm is standalone.
String resolveModulePath(String modulePath, Set<LoadOption> options) {
  var ext = path.extension(modulePath);
  final isFfiPlugin = options.contains(LoadOption.isFfiPlugin);
  final isStandaloneWasm = options.contains(LoadOption.isStandaloneWasm);
  if (ext == '') {
    ext = isStandaloneWasm ? '.wasm' : '.js';
    modulePath = '$modulePath$ext';
  }
  final moduleName = path.basenameWithoutExtension(modulePath);

  if (isFfiPlugin) {
    return 'assets/packages/$moduleName/assets/$moduleName$ext';
  }

  return modulePath;
}
