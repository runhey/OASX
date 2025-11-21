import 'dart:io';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

import 'package:oasx/utils/logger.dart';

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

  Future<bool> isInstalledFromMicrosoftStore() async {
    if (!isWindows) {
      return false;
    }
    try {
      final packageInfo = await PackageInfo.fromPlatform();
      final packageName = packageInfo.packageName;
      final String currentPath = Directory.current.path;
      logger.i('Package Name: ${packageInfo.packageName}');
      logger.i('App Name: ${packageInfo.appName}');
      logger.i('Version: ${packageInfo.version}');
      logger.i('Build Number: ${packageInfo.buildNumber}');
      logger.i('Installer Store: ${packageInfo.installerStore}');
      logger.i('Build Signature: ${packageInfo.buildSignature}');

      if (packageInfo.installerStore != null &&
          packageInfo.installerStore!.toLowerCase().contains('microsoft')) {
        return true;
      }
      if (packageInfo.buildSignature != null &&
          packageInfo.buildSignature!.contains('Microsoft')) {
        return true;
      }
      if (packageName.contains('MicrosoftStore') ||
          packageName.contains('MSIX')) {
        return true;
      }
      if (currentPath.contains('system32')) {
        return true;
      }
      return false;
    } catch (e) {
      return false;
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
