import 'package:bloc/bloc.dart';
import 'package:rxdart/rxdart.dart';

extension RemoveAllListExtension<T> on List<T> {
  void removeAll(Iterable<T> elements) => elements.forEach(remove);
}

extension WhereMapExtension<K, V> on Map<K, V> {
  Map<K, V> where(bool Function(K key, V value) predicate) {
    return Map.fromEntries(entries.where((entry) => predicate(entry.key, entry.value)));
  }
}

extension StreamExtension<T> on Stream<T> {
  Future<T?> firstWhereOrNull(bool Function(T element) test) async {
    try {
      return firstWhere(test);
    } catch (_) {
      return null;
    }
  }
}

extension HotStreamBloc<T> on BlocBase<T> {
  Stream<T> get hotStream => Rx.merge([Stream.value(state), stream]);
}
