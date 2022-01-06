extension StreamExtension<T> on Stream<T> {
  Future<T?> firstWhereOrNull(bool Function(T element) test) async {
    try {
      return firstWhere(test);
    } catch (_) {
      return null;
    }
  }
}

extension RemoveAllListExtension<T> on List<T> {
  void removeAll(Iterable<T> elements) => elements.forEach(remove);
}
