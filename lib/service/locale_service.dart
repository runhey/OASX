import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:oasx/model/const/storage_key.dart';

class LocaleService extends GetxService {
  final _storage = GetStorage();
  final language = 'zh-CN'.obs;

  final fallbackLocale = const Locale('zh', 'CN');

  Locale get currentLocale => _loadLocaleFromStorage();

  Future<LocaleService> init() async {
    language.value = _storage.read(StorageKey.language.name) ?? 'zh-CN';
    _updateLocale(language.value);
    return this;
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
