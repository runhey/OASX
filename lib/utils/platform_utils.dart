import 'dart:io';

import 'package:flutter/foundation.dart' show kIsWeb;

enum PlatformType {
  android,
  fuchsia,
  iOS,
  linux,
  macOS,
  windows,
  web,
}

class PlatformUtils {
  static bool _isWeb() {
    // 通过kIsWeb变量判断是否为web环境!
    return kIsWeb == true;
  }

  static PlatformType platfrom() {
    // 判断平台
    if (_isWeb()) {
      return PlatformType.web;
    } else if (Platform.isAndroid) {
      return PlatformType.android;
    } else if (Platform.isFuchsia) {
      return PlatformType.fuchsia;
    } else if (Platform.isIOS) {
      return PlatformType.iOS;
    } else if (Platform.isLinux) {
      return PlatformType.linux;
    } else if (Platform.isMacOS) {
      return PlatformType.macOS;
    } else if (Platform.isWindows) {
      return PlatformType.windows;
    } else {
      return PlatformType.web;
    }
  }

  static bool _isAndroid() {
    return _isWeb() ? false : Platform.isAndroid;
  }

  static bool _isIOS() {
    return _isWeb() ? false : Platform.isIOS;
  }

  static bool _isMacOS() {
    return _isWeb() ? false : Platform.isMacOS;
  }

  static bool _isWindows() {
    return _isWeb() ? false : Platform.isWindows;
  }

  static bool _isFuchsia() {
    return _isWeb() ? false : Platform.isFuchsia;
  }

  static bool _isLinux() {
    return _isWeb() ? false : Platform.isLinux;
  }

  static bool get isWeb => _isWeb();

  static bool get isAndroid => _isAndroid();

  static bool get isIOS => _isIOS();

  static bool get isMacOS => _isMacOS();

  static bool get isWindows => _isWindows();

  static bool get isFuchsia => _isFuchsia();

  static bool get isLinux => _isLinux();

  static bool get isMobile => isAndroid || isIOS || isFuchsia;

  static bool get isDesktop => isWindows || isMacOS || isLinux;
}
