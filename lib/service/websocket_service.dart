import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:oasx/api/api_client.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

typedef MessageListener = void Function(dynamic message);

class WebSocketService extends GetxService {
  final Map<String, WebSocketClient> _clients = {};

  /// connect to webSocket
  /// name: scriptName
  /// url(optional): webSocket url, if it is null, it will change to 'ws://${ApiClient().address}/ws/$name'
  /// listener(optional): webSocket message listener. it will add to ws listeners, message broadcast to all listeners
  /// force(optional): Although ws already opened, it will force connect to ws.Deal some ws problems(opened, but error)
  /// return: WebSocketClient. can send message
  Future<WebSocketClient> connect(
      {required String name,
      String? url,
      MessageListener? listener,
      bool force = false}) async {
    if (!force && _clients.containsKey(name)) {
      return _clients[name]!._addListener(listener);
    }
    if (force && _clients.containsKey(name)) {
      await close(name, reconnect: false);
    }

    url ??= 'ws://${ApiClient().address}/ws/$name';
    final client = WebSocketClient(
      name: name,
      url: url,
    )._addListener(listener);
    _clients[name] = client;
    await client._connect();
    return client;
  }

  /// use manager sends message to script socket
  void send(String name, String message) {
    final client = _clients[name];
    if (client != null) {
      client.send(message);
    } else {
      printInfo(info: "WebSocket [$name] not connected");
    }
  }

  /// use WebSocketClient to close webSocket and remove this client
  Future<void> close(String name,
      {int code = WebSocketStatus.normalClosure,
      String reason = "normal close",
      bool reconnect = false}) async {
    final client = _clients[name];
    if (client != null) {
      await client._close(code, reason, reconnect: reconnect);
      _clients.remove(name);
    }
  }

  Future<void> closeAll() async {
    for (final client in _clients.values) {
      await client._close(WebSocketStatus.normalClosure, "global close");
    }
    _clients.clear();
  }
}

enum WsStatus {
  /// prepare to connect ws
  connecting,

  /// ws connected
  connected,

  /// ws closed but try to connect
  reconnecting,

  /// ws closed
  closed,

  /// ws error but may also connected
  error,
}

class WebSocketClient {
  final String name;
  final String url;

  WebSocketChannel? _channel;
  final List<MessageListener> _listeners = [];
  bool _shouldReconnect = true;
  int _reconnectCount = 0;
  static const int maxReconnect = 10;
  final status = WsStatus.connecting.obs;

  WebSocketClient({
    required this.name,
    required this.url,
  });

  void send(String data) {
    if (status.value == WsStatus.connected) {
      _channel?.sink.add(data);
    } else {
      printInfo(info: "[$name] cannot send, status=${status.value}");
    }
  }

  /// 发送消息收到第一条消息就立马返回,超时返回null
  Future<T?> sendAndWaitOnce<T>(
    String data, {
    T Function(dynamic msg)? onResult,
    Duration timeout = const Duration(seconds: 5),
  }) async {
    return sendAndWaitUntil(data,
        check: (msg) => true, onResult: onResult, timeout: timeout);
  }

  /// 发送消息等到check条件满足返回收到的消息,超时返回null
  /// [onResult] 自定义转换返回结果,默认直接返回收到消息
  Future<T?> sendAndWaitUntil<T>(
    String data, {
    required bool Function(dynamic msg) check,
    T Function(dynamic msg)? onResult,
    Duration timeout = const Duration(seconds: 5),
  }) async {
    final completer = Completer<T?>();

    late MessageListener tmpListener;
    tmpListener = (msg) {
      try {
        if (check(msg) && !completer.isCompleted) {
          if (onResult != null) {
            completer.complete(onResult(msg));
          } else {
            completer.complete(msg);
          }
          _removeListener(tmpListener);
        }
      } catch (e) {
        // check 抛错忽略
      }
    };

    _addListener(tmpListener);
    send(data);

    // 超时处理
    Future.delayed(timeout, () {
      if (!completer.isCompleted) {
        completer.complete(null);
        _removeListener(tmpListener);
      }
    });

    return completer.future;
  }

  /// process url and connect websocket
  Future<void> _connect() async {
    try {
      status.value = WsStatus.connecting;
      var address = url;
      if (address.contains('http://')) {
        address = address.replaceAll('http://', '');
      }
      printInfo(info: "[$name] connecting to $address");
      _channel = WebSocketChannel.connect(Uri.parse(address));
      await _channel!.ready;

      status.value = WsStatus.connected;
      printInfo(info: "[$name] ws connected!");

      _channel!.stream.listen(
        (msg) {
          for (final listener in List.from(_listeners)) {
            listener(msg);
          }
        },
        onDone: _reconnect,
        onError: (e) {
          printError(info: "[$name] WebSocket error: $e");
          status.value = WsStatus.error;
          _reconnect();
        },
      );
    } on SocketException {
      printError(info: "[$name] SocketException: $url");
      status.value = WsStatus.error;
      _reconnect();
    } on Exception catch (e) {
      printError(info: "[$name] WebSocket Exception: $e");
      status.value = WsStatus.error;
      _reconnect();
    }
  }

  WebSocketClient _addListener(MessageListener? listener) {
    if (listener != null && !_listeners.contains(listener)) {
      _listeners.add(listener);
      if (kDebugMode) {
        printInfo(info: "ws listener add success!");
      }
    }
    return this;
  }

  void _removeListener(MessageListener listener) {
    _listeners.remove(listener);
  }

  /// close websocket and clear message listeners
  /// reconnect(optional): default false to stop reconnect websocket
  Future<void> _close(int code, String reason, {bool reconnect = false}) async {
    _shouldReconnect = reconnect;
    printInfo(info: "[$name] closing: $reason");
    await _channel?.sink.close(code, reason);
    status.value = WsStatus.closed;
    _listeners.clear();
  }

  /// reconnect webSocket when should reconnect. interval 2s
  void _reconnect() {
    if (!_shouldReconnect) {
      printInfo(info: "[$name] closed intentionally, no reconnect");
      status.value = WsStatus.closed;
      return;
    }
    _reconnectCount++;
    if (_reconnectCount > maxReconnect) {
      printInfo(info: "[$name] reconnect failed more than $maxReconnect times");
      status.value = WsStatus.error;
      return;
    }
    printInfo(info: "[$name] reconnecting... ($_reconnectCount)");
    status.value = WsStatus.reconnecting;
    Future.delayed(const Duration(seconds: 2), () => _connect());
  }
}
