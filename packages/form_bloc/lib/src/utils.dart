class Param<T> {
  final T value;

  const Param(this.value);
}

extension ParamCopyWithExtension<T> on Param<T>? {
  T or(T value) => this == null ? value : this!.value;
}
