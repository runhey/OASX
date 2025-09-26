import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:oasx/model/script_model.dart';
import 'package:oasx/utils/extension_utils.dart';

class ScriptService extends GetxService {
  final _storage = GetStorage();
  final scriptModelMap = <String, ScriptModel>{}.obs;

  @override
  void onInit() {
    super.onInit();
  }

  void addScriptModel(dynamic sm) {
    if (sm is String) {
      sm = ScriptModel(sm);
    }
    if (scriptModelMap.containsKey(sm.name)) return;
    scriptModelMap[sm.name] = sm;
  }

  void putAllScriptModel(List<String> scriptNameList) {
    scriptModelMap.assignAll(
        scriptNameList.map((e) => MapEntry(e, ScriptModel(e))).toMap());
  }

  void updateScriptModel(ScriptModel sm) {
    if (!scriptModelMap.containsKey(sm.name)) return;
    scriptModelMap[sm.name] = sm;
  }

  void addOrUpdateScriptModel(ScriptModel sm) {
    if (scriptModelMap.containsKey(sm.name)) {
      updateScriptModel(sm);
    } else {
      addScriptModel(sm);
    }
  }

  void deleteScriptModel(String name) {
    scriptModelMap.removeWhere((k, v) => k == name);
  }

  ScriptModel? findScriptModel(String name) {
    return scriptModelMap[name];
  }
}
