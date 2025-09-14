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

  Future<WebSocketClient> sendAndWaitOnce(
    String data, {
    Duration timeout = const Duration(seconds: 5),
  }) async {
    final client = await this;
    client.sendAndWaitOnce(data, timeout: timeout);
    return client;
  }
}
