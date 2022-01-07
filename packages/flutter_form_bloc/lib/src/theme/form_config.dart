import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_form_bloc/src/utils/to_string.dart';

/// The theme of [ScrollableFormBlocManager]
class ScrollableFormTheme extends Equatable {
  /// See [ScrollPosition.ensureVisible]
  final Duration duration;

  /// See [ScrollPosition.ensureVisible]
  final double alignment;

  /// See [ScrollPosition.ensureVisible]
  final Curve curve;

  /// See [ScrollPosition.ensureVisible]
  final ScrollPositionAlignmentPolicy alignmentPolicy;

  const ScrollableFormTheme({
    this.duration = const Duration(milliseconds: 500),
    this.alignment = 0.05,
    this.curve = Curves.ease,
    this.alignmentPolicy = ScrollPositionAlignmentPolicy.explicit,
  });

  ScrollableFormTheme copyWith({
    Duration? duration,
    double? alignment,
    Curve? curve,
    ScrollPositionAlignmentPolicy? alignmentPolicy,
  }) {
    return ScrollableFormTheme(
      duration: duration ?? this.duration,
      alignment: alignment ?? this.alignment,
      curve: curve ?? this.curve,
      alignmentPolicy: alignmentPolicy ?? this.alignmentPolicy,
    );
  }

  @override
  String toString() => (ToString(runtimeType)
        ..add('duration', duration)
        ..add('alignment', alignment)
        ..add('curve', curve)
        ..add('alignmentPolicy', alignmentPolicy))
      .toString();

  @override
  List<Object?> get props => [duration, alignment, curve, alignmentPolicy];
}
