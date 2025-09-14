import 'dart:convert';

import 'package:yaml/yaml.dart';

class YamlUtils{

  static dynamic getValueFromString(String yamlContent, String keyPath){
    var yamlMap = loadYaml(yamlContent);
    return getValueFromYamlMap(yamlMap, keyPath);
  }

  static dynamic getValueFromYamlMap(YamlMap yamlMap, String keyPath) {
    var config = jsonDecode(jsonEncode(yamlMap));
    return getValueFromMap(config, keyPath);
  }

  /// get value from key (support multi level key, ex: "api.base_url")
  static dynamic getValueFromMap(dynamic configMap, String keyPath) {
    if (configMap == null) {
      return null;
    }

    final keys = keyPath.split('.');
    dynamic value = configMap;
    for (final k in keys) {
      if (value is Map<String, dynamic> && value.containsKey(k)) {
        value = value[k];
      } else {
        return null;
      }
    }
    return value;
  }

}