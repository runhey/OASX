import 'package:flutter_client_sse/constants/sse_request_type_enum.dart';
import 'package:flutter_client_sse/flutter_client_sse.dart';
import 'package:flutter_nb_net/flutter_net.dart';
import 'package:get/get.dart';

import 'package:oasx/comom/i18n_content.dart';

class ApiClient {
  // 单例
  static final ApiClient _instance = ApiClient._internal();
  factory ApiClient() => _instance;
  ApiClient._internal();

  String address = '127.0.0.1:22267';

  void setAddress(String address) {
    this.address = address;
    NetOptions.instance
        .setBaseUrl(address)
        .setConnectTimeout(const Duration(seconds: 5))
        .enableLogger(true)
        .create();
  }

// ----------------------------------   服务端地址测试   ----------------------------------
  Future<bool> testAddress() async {
    // ignore: invalid_return_type_for_catch_error
    var appResponse = await get('/test').catchError((e) {
      printInfo(info: I18n.network_connect_timeout.tr);
      return e;
    }, test: (error) {
      return false;
    });
    if (appResponse.when(success: (dynamic) {
      if (dynamic == 'success') {
        return true;
      }
      return false;
    }, failure: (String msg, int code) {
      printError(info: '${I18n.network_error_code}: $msg | $code'.tr);
      showNetworkErrorCode(msg, code);
      return false;
    })) {
      return true;
    }
    return false;
  }

// ----------------------------------   菜单项管理   ----------------------------------
  Future<Map<String, List<String>>> getScriptMenu() async {
    Map<String, List<String>> result = <String, List<String>>{};
    var appResponse = await get(
      '/script_menu',
    ).catchError((e) {
      printInfo(info: I18n.network_connect_timeout.tr);
      return e;
    }, test: (error) {
      return false;
    });
    appResponse.when(success: (json) {
      json.forEach((key, value) {
        result[key] = value.cast<String>();
      });
    }, failure: (String msg, int code) {
      printError(info: '${I18n.network_error_code}: $msg | $code'.tr);
      showNetworkErrorCode(msg, code);
      return msg;
    });
    return result;
  }

  Future<Map<String, List<String>>> getHomeMenu() async {
    Map<String, List<String>> result = <String, List<String>>{};
    var appResponse = await get(
      '/home/home_menu',
    ).catchError((e) {
      printInfo(info: I18n.network_connect_timeout.tr);
      return e;
    }, test: (error) {
      return false;
    });
    appResponse.when(success: (json) {
      json.forEach((key, value) {
        result[key] = value.cast<String>();
      });
    }, failure: (String msg, int code) {
      printError(info: '${I18n.network_error_code}: $msg | $code'.tr);
      showNetworkErrorCode(msg, code);
      return msg;
    });
    return result;
  }

// ----------------------------------   配置文件管理   ----------------------------------
  Future<List<String>> getConfigList() async {
    var appResponse = await get('/config_list').catchError((e) {
      printInfo(info: I18n.network_connect_timeout.tr);
      return e;
    }, test: (error) {
      return false;
    });
    List<String> result = <String>['Home', 'template'];
    appResponse.when(success: (data) {
      printInfo(info: data.toString());
      result = <String>['Home'];
      result.addAll(data.cast<String>());
    }, failure: (String msg, int code) {
      printError(info: '${I18n.network_error_code}: $msg | $code'.tr);
      showNetworkErrorCode(msg, code);
    });
    return result;
  }

  Future<String> getNewConfigName() async {
    String result = '';
    var appResponse = await get('/config_new_name').catchError((e) {
      printInfo(info: I18n.network_connect_timeout.tr);
      return e;
    }, test: (error) {
      return false;
    });
    appResponse.when(success: (data) {
      printInfo(info: data.toString());
      result = data.toString();
    }, failure: (String msg, int code) {
      printError(info: '${I18n.network_error_code}: $msg | $code'.tr);
      showNetworkErrorCode(msg, code);
    });
    return result;
  }

  Future<List<String>> configCopy(String newName, String template) async {
    var appResponse = await post(
      '/config_copy',
      queryParameters: {'file': newName, 'template': template},
    ).catchError((e) {
      printInfo(info: I18n.network_connect_timeout.tr);
      return e;
    }, test: (error) {
      return false;
    });
    List<String> result = <String>['Home', 'template'];
    appResponse.when(success: (data) {
      printInfo(info: data.toString());
      result = <String>['Home'];
      result.addAll(data.cast<String>());
    }, failure: (String msg, int code) {
      printError(info: '${I18n.network_error_code}: $msg | $code'.tr);
      showNetworkErrorCode(msg, code);
    });
    return result;
  }

  Future<List<String>> getConfigAll() async {
    var appResponse = await get('/config_all').catchError((e) {
      printInfo(info: I18n.network_connect_timeout.tr);
      return e;
    }, test: (error) {
      return false;
    });
    List<String> result = <String>['template'];
    appResponse.when(success: (data) {
      printInfo(info: data.toString());
      result = data.cast<String>();
    }, failure: (String msg, int code) {
      printError(info: '${I18n.network_error_code}: $msg | $code'.tr);
      showNetworkErrorCode(msg, code);
    });
    return result;
  }

// ---------------------------------   脚本实例管理   ----------------------------------

  Future<Map> getScriptTask(String scritpName, String taskName) async {
    var result = {};
    var appResponse = await get(
      '/$scritpName/$taskName/args',
    ).catchError((e) {
      printInfo(info: I18n.network_connect_timeout.tr);
      return e;
    }, test: (error) {
      return false;
    });
    appResponse.when(success: (json) {
      result = json;
    }, failure: (String msg, int code) {
      showNetworkErrorCode(msg, code);
      printError(info: '${I18n.network_error_code}: $msg | $code'.tr);
      return msg;
    });
    return result;
  }

  Future<bool> putScriptArg(
    String scritpName,
    String taskName,
    String groupName,
    String argumentName,
    String type,
    dynamic value,
  ) async {
    var result = false;
    var appResponse = await put(
      '/$scritpName/$taskName/$groupName/$argumentName/value',
      queryParameters: {'types': type, 'value': value},
    ).catchError((e) {
      printInfo(info: I18n.network_connect_timeout.tr);
      return e;
    }, test: (error) {
      return false;
    });

    appResponse.when(success: (json) {
      result = json;
    }, failure: (String msg, int code) {
      showNetworkErrorCode(msg, code);
      printError(info: '${I18n.network_error_code}: $msg | $code'.tr);
      return msg;
    });
    return result;
  }

// ---------------------------------   Snackbar --------------------------------
  void showDialog(String title, String content) {
    Get.snackbar(title, content);
  }

  void showNetworkTimeout() {
    Get.snackbar(I18n.network_error.tr, I18n.network_connect_timeout.tr);
  }

  void showNetworkErrorCode(String msg, int code) {
    Get.snackbar(I18n.network_error.tr,
        '${I18n.network_error_code.tr}: $msg | $code'.tr);
  }
}
