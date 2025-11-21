import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:oasx/model/const/storage_key.dart';

import 'package:oasx/config/translation/i18n.dart';
import 'package:path_provider/path_provider.dart';

class LocaleService extends GetxService with DynamicMessages {
  final _storage = GetStorage();
  final language = 'zh-CN'.obs;

  final fallbackLocale = const Locale('zh', 'CN');

  Locale get currentLocale => _loadLocaleFromStorage();

  @override
  void onInit() {
    loadMessage();
    language.value = _storage.read(StorageKey.language.name) ?? 'zh-CN';
    _updateLocale(language.value);
    super.onInit();
  }

  void switchLanguage(String lang) {
    language.value = lang;
    _storage.write(StorageKey.language.name, lang);
    _updateLocale(lang);
  }

  void _updateLocale(String lang) {
    final locale = switch (lang) {
      'zh-CN' => const Locale('zh', 'CN'),
      'en-US' => const Locale('en', 'US'),
      _ => fallbackLocale,
    };
    Get.updateLocale(locale);
  }

  Locale _loadLocaleFromStorage() {
    final code = _storage.read(StorageKey.language.name);
    if (code == null) return fallbackLocale;
    return Locale(code);
  }
}

mixin DynamicMessages {
  late final Messages _messages = Messages();
  Messages get messages => _messages;

  Future<bool> loadMessage() async {
    await _loadLocaleMessage('zh-CN');
    await _loadLocaleMessage('en-US');
    return true;
  }

  Future<bool> _loadLocaleMessage(String lang) async {
    try {
      Directory appDocDir = await getApplicationCacheDirectory();
      // final json = await rootBundle.loadString('assets/i18n/$lang.json');
      String filePath = '${appDocDir.path}/i18n/$lang.json';
      File file = File(filePath);
      String json = await file.readAsString();
      final dataMap = jsonDecode(json) as Map<String, dynamic>;
      dataMap.forEach(
          (key, value) => _messages.translateUpdate(key, value, locale: lang));
    } catch (e) {
      printError(info: e.toString());
    }
    return true;
  }

  Future<bool> saveAdditionalTranslate(
      Map<String, Map<String, String>> data) async {
    await _saveAdditionalTranslate(data["zh-CN"]!, lang: 'zh-CN');
    await _saveAdditionalTranslate(data["en-US"]!, lang: 'en-US');
    return true;
  }

  Future<bool> _saveAdditionalTranslate(Map<String, String> data,
      {String lang = "zh-CN"}) async {
    try {
      JsonEncoder encoder = const JsonEncoder.withIndent('  ');
      String jsonString = encoder.convert(data);
      Directory appDocDir = await getApplicationCacheDirectory();
      String i18nDirPath = '${appDocDir.path}/i18n';
      Directory i18nDir = Directory(i18nDirPath);
      if (!i18nDir.existsSync()) {
        i18nDir.createSync(recursive: true);
      }
      String filePath = '$i18nDirPath/$lang.json';
      printInfo(info: 'Save additional translate to $filePath');
      File file = File(filePath);
      await file.writeAsString(jsonString);
    } catch (e) {
      printError(info: e.toString());
    }
    return true;
  }
}
