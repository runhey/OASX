import 'package:oasx/model/script_model.dart';

import '../service/websocket_service.dart';

extension StringExtension on String {
  String upperFirstWord() {
    if (isEmpty) return this;
    return this[0].toUpperCase() + substring(1);
  }
}

extension MapExtension<K, V> on Iterable<MapEntry<K, V>> {
  Map<K, V> toMap() => Map.fromEntries(this);
}

extension WebSocketClientExtension on Future<WebSocketClient> {
  Future<WebSocketClient> send(String data) async {
    final client = await this;
    client.send(data);
    return client;
  }

  Future<T?> sendAndWaitOnce<T>(
    String data, {T Function(dynamic msg)? onResult,
    Duration timeout = const Duration(seconds: 5),
  }) async {
    final client = await this;
    return await client.sendAndWaitOnce(data, onResult: onResult, timeout: timeout);
  }

  Future<T?> sendAndWaitUntil<T>(
      String data, {
        required Future<bool> Function(dynamic msg) check,
        T Function(dynamic msg)? onResult,
        Duration timeout = const Duration(seconds: 5),
      }) async {
    final client = await this;
    return await client.sendAndWaitUntil(data, check: check, onResult: onResult, timeout: timeout);
  }
}

extension WsStatusX on WsStatus {
  ScriptState get scriptState {
    switch (this) {
      case WsStatus.connecting:
      case WsStatus.connected:
        return ScriptState.running;
      case WsStatus.reconnecting:
      case WsStatus.error:
        return ScriptState.warning;
      case WsStatus.closed:
        return ScriptState.updating;
    }
  }
}
