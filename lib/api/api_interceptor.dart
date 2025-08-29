import 'package:flutter/foundation.dart';
import 'package:flutter_nb_net/flutter_net.dart';
import 'package:get/get.dart' hide Response;

class ApiInterceptor extends Interceptor {

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (kDebugMode) {
      printInfo(info: '${options.uri}[${options.method}]${options.data != null ? ':${options.data}' : ''}');
    }
    return super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (kDebugMode) {
      printInfo(info: '${response.requestOptions.uri}[${response.statusCode}]:${response.data}');
    }
    return super.onResponse(response, handler);
  }
}
