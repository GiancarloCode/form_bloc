import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_form_bloc/src/utils/to_string.dart';

/// The theme of [ClearSuffixButton]
class ClearSuffixButtonTheme extends Equatable {
  /// Determines whether the button should always
  /// be visible even when the field has no value
  final bool? visibleWithoutValue;

  /// Duration of the appearance animation
  /// when the [visibleWithoutValue] is false
  final Duration? appearDuration;

  /// The widget button icon
  final Widget? icon;

  const ClearSuffixButtonTheme({
    this.visibleWithoutValue,
    this.appearDuration,
    this.icon,
  });

  ClearSuffixButtonTheme copyWith({
    bool? visibleWithoutValue,
    Duration? appearDuration,
    Widget? icon,
  }) {
    return ClearSuffixButtonTheme(
      visibleWithoutValue: visibleWithoutValue ?? this.visibleWithoutValue,
      appearDuration: appearDuration ?? this.appearDuration,
      icon: icon ?? this.icon,
    );
  }

  @override
  List<Object?> get props => [visibleWithoutValue, appearDuration, icon];

  @override
  String toString() {
    return (ToString(runtimeType)
          ..add('visibleWithoutValue', visibleWithoutValue)
          ..add('appearDuration', appearDuration)
          ..add('icon', icon))
        .toString();
  }
}

/// The theme of [ObscureSuffixButton]
class ObscureSuffixButtonTheme extends Equatable {
  /// This icon will be displayed when obscure text is `true`.
  final Widget? trueIcon;

  /// This icon will be displayed when obscure text is `false`.
  final Widget? falseIcon;

  const ObscureSuffixButtonTheme({
    this.trueIcon,
    this.falseIcon,
  });

  ObscureSuffixButtonTheme copyWith({
    Widget? trueIcon,
    Widget? falseIcon,
  }) {
    return ObscureSuffixButtonTheme(
      trueIcon: trueIcon ?? this.trueIcon,
      falseIcon: falseIcon ?? this.falseIcon,
    );
  }

  @override
  List<Object?> get props => [trueIcon, falseIcon];

  @override
  String toString() {
    return (ToString(runtimeType)
          ..add('trueIcon', trueIcon)
          ..add('falseIcon', falseIcon))
        .toString();
  }
}
