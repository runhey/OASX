import 'package:flutter/foundation.dart';
import 'package:flutter_nb_net/flutter_net.dart';
import 'package:get/get.dart' hide Response;

class ApiInterceptor extends Interceptor {
  static const _startTimeKey = 'api_start_time';
  static const _maxLen = 200; // 最大打印长度

  String _short(Object? data) {
    if (data == null) return 'null';
    final str = data.toString();
    if (str.length > _maxLen) {
      return '${str.substring(0, _maxLen)}...';
    }
    return str;
  }

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.extra[_startTimeKey] = DateTime.now().millisecondsSinceEpoch;

    final method = options.method;
    final uri = options.uri.toString();
    final queryParams = options.queryParameters;
    final data = options.data;

    printInfo(
      info:
          '[$method]$uri | query=${_short(queryParams)} | body=${_short(data)}',
    );
    return super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    final start = response.requestOptions.extra[_startTimeKey] as int?;
    final duration =
        start != null ? DateTime.now().millisecondsSinceEpoch - start : null;

    final status = response.statusCode;
    final uri = response.requestOptions.uri;

    printInfo(
      info:
          '[$status]$uri | ${duration ?? '-'} ms | data=${_short(response.data)}',
    );
    return super.onResponse(response, handler);
  }
}
