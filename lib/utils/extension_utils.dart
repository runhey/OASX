extension StringExtension on String {
  String upperFirstWord() {
    if (isEmpty) return this;
    return this[0].toUpperCase() + substring(1);
  }
}

extension MapExtension<K, V> on Iterable<MapEntry<K, V>> {
  Map<K, V> toMap() => Map.fromEntries(this);
}