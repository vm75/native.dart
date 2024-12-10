import 'dart:io' show Platform;
import '../../app_type.dart' show AppType;

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
