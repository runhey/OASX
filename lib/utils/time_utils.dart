import 'dart:async';

class TimeoutUtils {
  /// 周期性执行检查逻辑，直到条件满足或超时
  ///
  /// [check] 返回 true 表示任务完成，会立即结束；
  /// 超过 [timeout] 时会结束并返回 false。
  /// [onTick] 每次周期触发时调用（可选，比如更新进度条）。
  static Future<bool> runWithTimeout({
    required Duration period,
    required Duration timeout,
    required bool Function() check,
    void Function()? onTick,
  }) async {
    final completer = Completer<bool>();
    final startTime = DateTime.now();
    Timer? timer;
    timer = Timer.periodic(period, (t) {
      try {
        final elapsed = DateTime.now().difference(startTime);
        if (check()) {
          timer?.cancel();
          if (!completer.isCompleted) {
            completer.complete(true);
          }
        } else if (elapsed >= timeout) {
          timer?.cancel();
          if (!completer.isCompleted) {
            completer.complete(false);
          }
        } else {
          onTick?.call();
        }
      } catch (e, s) {
        timer?.cancel();
        if (!completer.isCompleted) {
          completer.completeError(e, s);
        }
      }
    });
    return completer.future;
  }
}

String formatDateTime(DateTime dt) {
  String twoDigits(int n) => n.toString().padLeft(2, '0');
  String y = dt.year.toString();
  String m = twoDigits(dt.month);
  String d = twoDigits(dt.day);
  String h = twoDigits(dt.hour);
  String min = twoDigits(dt.minute);
  String s = twoDigits(dt.second);
  return '$y-$m-$d $h:$min:$s';
}