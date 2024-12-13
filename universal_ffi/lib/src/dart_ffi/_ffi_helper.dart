import 'dart:io' show Platform;
import 'package:path/path.dart' as path;
import '../../ffi_helper.dart' show AppType, LoadOption;

/// Returns the type of the current app.
///
/// The type is determined by the platform.
AppType get appType {
  if (Platform.isAndroid) {
    return AppType.android;
  } else if (Platform.isIOS) {
    return AppType.ios;
  } else if (Platform.isMacOS) {
    return AppType.macos;
  } else if (Platform.isLinux) {
    return AppType.linux;
  } else if (Platform.isWindows) {
    return AppType.windows;
  } else {
    return AppType.unknown;
  }
}

/// Resolves the path to a shared library module to a file name.
///
/// On Windows, returns `$moduleName.dll`.
/// On Linux & Android, returns `lib$moduleName.so`.
/// On macOS & iOS, returns `lib$moduleName.dylib` or `$moduleName.framework/$moduleName`.
/// Otherwise, throws an [UnsupportedError].
///
/// [modulePath] is the path to the shared library module.
/// [options] optional load options.
///   * isFfiPlugin: this is a Ffi plugin.
String resolveModulePath(String modulePath, Set<LoadOption> options) {
  if (modulePath.isEmpty) {
    return '';
  }

  final moduleName = path.basenameWithoutExtension(modulePath);
  final moduleDir = path.dirname(modulePath);
  final isFfiPlugin = options.contains(LoadOption.isFfiPlugin);

  late String fileName;
  if (Platform.isWindows) {
    fileName = '$moduleName.dll';
  } else if (Platform.isLinux || Platform.isAndroid) {
    fileName = 'lib$moduleName.so';
  } else if (Platform.isMacOS || Platform.isIOS) {
    fileName = isFfiPlugin
        ? '$moduleName.framework/$moduleName'
        : 'lib$moduleName.dylib';
  } else {
    throw UnsupportedError('Unsupported platform');
  }

  return isFfiPlugin ? fileName : path.join(moduleDir, fileName);
}
