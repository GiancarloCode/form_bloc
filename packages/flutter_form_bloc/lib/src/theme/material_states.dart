import 'package:flutter/material.dart';

class SimpleMaterialStateProperty<T> implements MaterialStateProperty<T> {
  final T normal;
  final T disabled;

  const SimpleMaterialStateProperty({
    required this.normal,
    required this.disabled,
  });

  @override
  T resolve(Set<MaterialState> states) {
    if (states.contains(MaterialState.disabled)) return disabled;
    return normal;
  }
}
