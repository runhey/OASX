import 'package:flutter_nb_net/flutter_net.dart';
import 'package:get/get.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:dio_cache_interceptor_file_store/dio_cache_interceptor_file_store.dart';
import 'package:oasx/api/api_interceptor.dart';

import 'package:oasx/component/dio_http_cache/dio_http_cache.dart';
import 'package:oasx/comom/i18n_content.dart';
import 'package:oasx/comom/i18n.dart';
import 'package:oasx/utils/check_version.dart';
import 'package:oasx/config/constants.dart';
import 'package:oasx/controller/settings.dart';
import './home_model.dart';
import './update_info_model.dart';

/// common result
class ApiResult<T> {
  final T? data;
  final String? error;
  final int? code;

  bool get isSuccess => data != null;

  ApiResult.success(this.data)
      : error = null,
        code = null;

  ApiResult.failure(this.error, [this.code]) : data = null;
}

class ApiClient {
  // 单例
  static final ApiClient _instance = ApiClient._internal();
  factory ApiClient() => _instance;
  ApiClient._internal();

  String address = '127.0.0.1:22288';
  // http://$address 地址的前缀开头

  void setAddress(String address) {
    this.address = address;
    NetOptions.instance
        .setBaseUrl(address)
        .setConnectTimeout(const Duration(seconds: 3))
        .enableLogger(false)
        .addInterceptor(DioCacheInterceptor(
            options: CacheOptions(
          store:
              FileCacheStore(Get.find<SettingsController>().temporaryDirectory),
          policy: CachePolicy.request,
          hitCacheOnErrorExcept: [401, 403],
          maxStale: const Duration(days: 7),
          priority: CachePriority.normal,
          cipher: null,
          keyBuilder: CacheOptions.defaultCacheKeyBuilder,
          allowPostMethod: false,
        )))
        .addInterceptor(ApiInterceptor())
        .create();
  }

  /// common request method
  Future<ApiResult<T>> request<T>(Future<Result<T>> Function() apiFn) async {
    try {
      final res = await apiFn();
      return res.when(
        success: (data) => ApiResult.success(data),
        failure: (msg, code) {
          printError(info: '${I18n.network_error_code}: $msg | $code'.tr);
          switch (code) {
            case 403:
              break;
            case 404:
              showNetErrCodeSnackBar(I18n.network_not_found.tr, code);
              break;
            default:
              showNetErrCodeSnackBar(msg, code);
              break;
          }
          return ApiResult.failure(msg, code);
        },
      );
    } catch (e) {
      printError(info: '${I18n.network_error.tr}: $e');
      showNetErrSnackBar();
      return ApiResult.failure(e.toString());
    }
  }

// ----------------------------------   服务端地址测试   ----------------------------------
  Future<bool> testAddress() async {
    final res = await request(() => get('/test'));
    return res.isSuccess && res.data == 'success';
  }

  Future<bool> killServer() async {
    final res = await request(() => get('/home/kill_server'));
    return res.isSuccess && res.data == 'success';
  }

// ----------------------------------   杂接口  --------------------------------------------
  Future<bool> notifyTest(String setting, String title, String content) async {
    final res = await request(() => post(
          '/home/notify_test',
          queryParameters: {
            'setting': setting,
            'title': title,
            'content': content
          },
        ));
    if (res.isSuccess && res.data == true) {
      Get.snackbar(I18n.notify_test_success.tr, '');
      return true;
    }
    Get.snackbar(I18n.notify_test_failed.tr, res.data.toString());
    return false;
  }

  Future<GithubVersionModel> getGithubVersion() async {
    final res = await request(() => get(
          updateUrlGithub,
          options: buildCacheOptions(const Duration(days: 7)),
          decodeType: GithubVersionModel(),
        ));
    return res.isSuccess ? res.data : GithubVersionModel();
  }

  Future<ReadmeGithubModel> getGithubReadme() async {
    final res = await request(() => get(
          readmeUrlGithub,
          options: buildCacheOptions(const Duration(days: 7),
              options: Options(extra: {"cache": true})),
          decodeType: ReadmeGithubModel(),
        ));
    return res.isSuccess ? res.data : ReadmeGithubModel();
  }

  Future<UpdateInfoModel> getUpdateInfo() async {
    final res = await request(() => get(
          '/home/update_info',
          decodeType: UpdateInfoModel(),
        ));
    return res.isSuccess ? res.data : UpdateInfoModel();
  }

  Future<String?> getExecuteUpdate() async {
    final res = await request(() => get('/home/execute_update'));
    if (res.isSuccess) {
      showDialog('Update', res.data.toString());
      return res.data;
    }
    return res.data;
  }

  Future<bool> putChineseTranslate() async {
    final res = await request(() => put(
          '/home/chinese_translate',
          data: Messages().all_cn_translate,
        ));
    return res.isSuccess && res.data == true;
  }

// ----------------------------------   菜单项管理   ----------------------------------
  Future<Map<String, List<String>>> getScriptMenu() async {
    final res = await request(() => get('/script_menu'));
    return ((res.data ?? {}) as Map).map((k, v) =>
        MapEntry(k.toString(), (v as List).map((e) => e.toString()).toList()));
  }

  Future<Map<String, List<String>>> getHomeMenu() async {
    final res = await request(() => get('/home/home_menu'));
    return ((res.data ?? {}) as Map).map((k, v) =>
        MapEntry(k.toString(), (v as List).map((e) => e.toString()).toList()));
  }

// ----------------------------------   配置文件管理   ----------------------------------
  Future<List<String>> getConfigList() async {
    final res = await request(() => get('/config_list'));
    return ['Home', ...(res.data?.cast<String>() ?? [])];
  }

  Future<String> getNewConfigName() async {
    final res = await request(() => get('/config_new_name'));
    return res.isSuccess ? res.data : '';
  }

  Future<List<String>> configCopy(String newName, String template) async {
    final res = await request(() => post(
          '/config_copy',
          queryParameters: {'file': newName, 'template': template},
        ));
    return ['Home', ...(res.data?.cast<String>() ?? [])];
  }

  Future<List<String>> getConfigAll() async {
    final res = await request(() => get('/config_all'));
    return res.data?.cast<String>() ?? ['template'];
  }

  Future<bool> deleteConfig(String name) async {
    final res = await request(() => delete(
          '/config',
          queryParameters: {'name': name},
        ));
    return res.isSuccess && res.data;
  }

  Future<bool> renameConfig(String oldName, String newName) async {
    final res = await request(() => put(
          '/config',
          queryParameters: {'old_name': oldName, 'new_name': newName},
        ));
    return res.isSuccess && res.data;
  }

// ---------------------------------   脚本实例管理   ----------------------------------

  Future<Map<String, dynamic>> getScriptTask(
      String scriptName, String taskName) async {
    final res = await request(() => get('/$scriptName/$taskName/args'));
    return res.data ?? {};
  }

  Future<bool> putScriptArg(
    String scriptName,
    String taskName,
    String groupName,
    String argumentName,
    String type,
    dynamic value,
  ) async {
    final res = await request(() => put(
          '/$scriptName/$taskName/$groupName/$argumentName/value',
          queryParameters: {'types': type, 'value': value},
        ));
    return res.isSuccess && res.data == true;
  }

// ---------------------------------   Snackbar --------------------------------
  void showDialog(String title, String content) {
    Get.snackbar(title, content);
  }

  void showNetErrSnackBar() {
    Get.snackbar(I18n.network_error.tr, I18n.network_connect_timeout.tr,
        duration: const Duration(seconds: 2));
  }

  void showNetErrCodeSnackBar(String msg, int code) {
    Get.snackbar(
        I18n.network_error.tr, '${I18n.network_error_code.tr}: $code | $msg',
        duration: const Duration(seconds: 2));
  }
}
