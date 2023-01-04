//Util class to use for Dropdown widget
class DropdownEntry<K, V>{
  /// The key of the entry.
  final K key;

  ///The value associated to [key] in the map.
  final V? value;

  DropdownEntry(this.key, this.value);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is DropdownEntry && runtimeType == other.runtimeType && key == other.key && value == other.value;

  @override
  int get hashCode => key.hashCode ^ value.hashCode;

  @override
  String toString() {
    return 'DropdownEntry{key: $key, value: $value}';
  }
}
