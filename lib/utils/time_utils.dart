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