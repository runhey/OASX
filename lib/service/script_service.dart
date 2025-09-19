import 'dart:convert';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:oasx/api/api_client.dart';
import 'package:oasx/model/const/storage_key.dart';
import 'package:oasx/service/websocket_service.dart';
import 'package:oasx/translation/i18n_content.dart';

class ScriptService extends GetxService {
  final _storage = GetStorage();
  final autoStartScript = false.obs;
  List<String> _autoStartScriptList = [];

  @override
  void onInit() {
    autoStartScript.value =
        _storage.read(StorageKey.autoStartScript.name) ?? false;
    final ret = _storage.read(StorageKey.autoStartScriptList.name);
    _autoStartScriptList =
        ret is List ? ret.map((e) => e.toString()).toList() : [];
    super.onInit();
  }

  void updateAutoScript(bool value) {
    autoStartScript.value = value;
    _storage.write(StorageKey.autoStartScript.name, value);
  }

  void updateAutoScriptList(List<String> scriptList) {
    _autoStartScriptList = scriptList;
    _storage.write(StorageKey.autoStartScriptList.name, scriptList);
  }

  /// 自动运行storage中存储的且当前存在的script
  Future<void> autoRunScript() async {
    // 没有开启自动运行脚本或没有配置自动运行的脚本
    if (!autoStartScript.value || _autoStartScriptList.isEmpty) {
      return;
    }
    final scriptNameList = await ApiClient().getConfigList();
    final filteredList = scriptNameList
        .where((name) => name.toLowerCase() != 'home') // 不包含home
        .where((name) => _autoStartScriptList.contains(name)) // 已配置启动
        .toList();
    // 没有可以运行的脚本
    if (filteredList.isEmpty) return;

    Get.snackbar(I18n.tip.tr, 'Detect $filteredList need auto start, starting!',
        duration: const Duration(seconds: 5), showProgressIndicator: true);
    final wsService = Get.find<WebSocketService>();
    for (String scriptName in filteredList) {
      try {
        final socketClient = await wsService.connect(name: scriptName);
        final state = await socketClient.sendAndWaitOnce('get_state',
            onResult: _getState);
        // 已经运行
        if (state == 1) continue;
        final msg = await socketClient.sendAndWaitUntil(
          'start',
          check: (msg) => _getState(msg) == 1,
          onResult: _getState,
        );
        if (msg != 1) {
          Get.snackbar(
              I18n.error.tr, 'The script[$scriptName] starts fail......',
              duration: const Duration(seconds: 3));
        }
      } catch (e) {
        Get.snackbar(
            I18n.error.tr, 'Error while starting script[$scriptName]: $e',
            duration: const Duration(seconds: 3));
      }
    }
  }

  int _getState(dynamic msg) {
    if (msg is! String || !msg.contains('state')) {
      return 0;
    }
    Map<String, dynamic> data = jsonDecode(msg);
    return data['state'];
  }
}
