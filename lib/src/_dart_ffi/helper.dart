import 'dart:io' show Platform;
import 'package:path/path.dart' as path;

/// Resolves the path to a shared library module to a file name.
///
/// If on Windows, returns `$moduleName.dll`. If on Linux or Android, returns
/// `lib$moduleName.so`. If on MacOS or iOS, returns `$moduleName.framework/$moduleName`.
/// Otherwise, throws an [UnsupportedError].
///
/// [modulePath] is the path to the shared library module.
String resolveModulePath(String modulePath) {
  if (modulePath.isEmpty) {
    return '';
  }

  final moduleName = path.basenameWithoutExtension(modulePath);
  final moduleDir = path.dirname(modulePath);

  late String fileName;
  if (Platform.isWindows) {
    fileName = '$moduleName.dll';
  } else if (Platform.isLinux || Platform.isAndroid) {
    fileName = 'lib$moduleName.so';
  } else if (Platform.isMacOS || Platform.isIOS) {
    fileName = '$moduleName.framework/$moduleName';
  } else {
    throw UnsupportedError('Unsupported platform');
  }

  if (moduleDir == '.') {
    return fileName;
  }

  return path.join(moduleDir, fileName);
}
