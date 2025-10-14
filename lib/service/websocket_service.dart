import 'dart:async';
import 'dart:io';
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
    if (_clients.containsKey(name) &&
        _clients[name]!.status.value == WsStatus.connected) {
      return _clients[name]!._addListener(listener);
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
  Future<void> send(String name, String message) async {
    final client = _clients[name];
    if (client != null) {
      client.send(message);
    } else {
      printInfo(info: "ws[$name] want to send, but not connected");
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
    printInfo(info: "ws[$name] closed");
  }

  Future<void> closeAll() async {
    for (final client in _clients.values) {
      await client._close(WebSocketStatus.normalClosure, "global close");
    }
    _clients.clear();
    printInfo(info: "ws all closed");
  }

  void removeAllListeners(String name) {
    final client = _clients[name];
    if (client != null) {
      client._listeners.clear();
    }
    printInfo(info: "ws[$name] listeners removed");
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
  static const int maxReconnect = 3;
  static const int maxReconnectAfterClosed = 2;
  final status = WsStatus.connecting.obs;

  WebSocketClient({
    required this.name,
    required this.url,
  });

  Future<void> send(String data) async {
    if (status.value == WsStatus.connected) {
      try {
        _channel?.sink.add(data);
      } catch (e) {
        printError(info: e.toString());
        status.value = WsStatus.error;
        await _reconnect();
      }
    } else {
      printInfo(info: "[$name] cannot send, status=${status.value}");
      await _reconnect();
    }
  }

  /// 发送消息收到第一条消息就立马返回,超时返回null
  Future<T?> sendAndWaitOnce<T>(
    String data, {
    T Function(dynamic msg)? onResult,
    Duration timeout = const Duration(seconds: 5),
  }) async {
    return sendAndWaitUntil(data,
        check: (msg) async => true, onResult: onResult, timeout: timeout);
  }

  /// 发送消息等到check条件满足返回收到的消息,超时返回null
  /// [onResult] 自定义转换返回结果,默认直接返回收到消息
  Future<T?> sendAndWaitUntil<T>(
    String data, {
    required Future<bool> Function(dynamic msg) check,
    T Function(dynamic msg)? onResult,
    Duration timeout = const Duration(seconds: 5),
  }) async {
    final completer = Completer<T?>();

    late MessageListener tmpListener;
    tmpListener = (msg) async {
      try {
        if (await check(msg) && !completer.isCompleted) {
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
      printInfo(info: "ws[$name] connecting to $address");
      _channel = WebSocketChannel.connect(Uri.parse(address));
      await _channel!.ready;
      status.value = WsStatus.connected;
      printInfo(info: "ws[$name] connected!");

      // 接收数据通道监听
      _channel!.stream.listen(
        (msg) {
          for (final listener in List.from(_listeners)) {
            listener(msg);
          }
        },
        onDone: _reconnect,
        onError: (e) async {
          printError(info: "ws[$name] error: $e");
          status.value = WsStatus.error;
          await _reconnect();
        },
      );
      // 发送数据通道监听
      _channel!.sink.done.then((_) async {
        printInfo(info: "ws[$name] sink closed");
        if (status.value != WsStatus.closed) {
          status.value = WsStatus.closed;
          await _reconnect();
        }
      });
    } on SocketException catch (e) {
      printError(info: "ws[$name] SocketException: $e");
      status.value = WsStatus.error;
      await _reconnect();
    } on Exception catch (e) {
      printError(info: "ws[$name] Exception: $e");
      status.value = WsStatus.error;
      await _reconnect();
    }
  }

  WebSocketClient _addListener(MessageListener? listener) {
    if (listener != null && !_listeners.contains(listener)) {
      _listeners.add(listener);
      printInfo(info: "ws[$name] listener added");
    }
    return this;
  }

  void _removeListener(MessageListener listener) {
    _listeners.remove(listener);
    printInfo(info: "ws[$name] listener removed");
  }

  /// close websocket and clear message listeners
  /// reconnect(optional): default false to stop reconnect websocket
  Future<void> _close(int code, String reason, {bool reconnect = false}) async {
    _shouldReconnect = reconnect;
    try {
      await _channel?.sink.close(code, reason);
    } catch (e) {
      printError(info: e.toString());
    }
    status.value = WsStatus.closed;
    _listeners.clear();
    printInfo(info: "ws[$name] closed: $reason");
  }

  /// reconnect webSocket when should reconnect. interval 2s
  Future<void> _reconnect() async {
    if (!_shouldReconnect) {
      printInfo(info: "ws[$name] not should reconnect");
      status.value = WsStatus.closed;
      return;
    }
    if (status.value == WsStatus.connected ||
        status.value == WsStatus.connecting ||
        status.value == WsStatus.reconnecting) {
      return;
    }
    _reconnectCount++;
    if (_reconnectCount > maxReconnect) {
      printError(
          info: "ws[$name] reconnect failed more than $maxReconnect times");
      if (status.value != WsStatus.closed) {
        printError(info: 'ws[$name] try close and reconnect');
        await _close(
                WebSocketStatus.normalClosure, 'client try connect, but failed')
            .timeout(const Duration(seconds: 2), onTimeout: () => false);
      }
      status.value = WsStatus.closed;
      if (_reconnectCount > maxReconnect + maxReconnectAfterClosed) {
        _reconnectCount = 0;
        printError(info: 'ws[$name] try reconnect after closed failed, finish');
        return;
      }
    }
    printInfo(info: "ws[$name] reconnecting... ($_reconnectCount)");
    status.value = WsStatus.reconnecting;
    Future.delayed(
        Duration(seconds: _reconnectCount <= 1 ? 0 : 2), () => _connect());
  }
}
