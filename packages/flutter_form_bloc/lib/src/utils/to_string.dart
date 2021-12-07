class ToString {
  static int _indentingIndent = 0;
  StringBuffer? _buffer = StringBuffer();

  ToString(Type classType) {
    _buffer!
      ..write('$classType')
      ..write(' {\n');
    _indentingIndent += 2;
  }

  void add(String field, Object? value) {
    if (value != null) addNull(field, value);
  }

  void addNull(String field, Object? value) {
    _buffer!
      ..write(' ' * _indentingIndent)
      ..write(field)
      ..write('=')
      ..write(value)
      ..write(',\n');
  }

  ToString? check(bool condition) => condition ? this : null;

  @override
  String toString() {
    _indentingIndent -= 2;
    _buffer!
      ..write(' ' * _indentingIndent)
      ..write('}');
    var stringResult = _buffer.toString();
    _buffer = null;
    return stringResult;
  }
}
