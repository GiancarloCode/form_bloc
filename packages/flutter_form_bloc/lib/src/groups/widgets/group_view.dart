import 'package:collection/collection.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_form_bloc/src/utils/to_string.dart';

/// Base class for the style of [GroupView]
class GroupStyle {
  const GroupStyle._();
}

/// [Flex]
class FlexGroupStyle extends GroupStyle {
  /// [Flex.direction]
  final Axis direction;

  /// [Flex.textDirection]
  final TextDirection? textDirection;

  /// [Flex.verticalDirection]
  final VerticalDirection verticalDirection;

  const FlexGroupStyle({
    this.direction = Axis.vertical,
    this.textDirection,
    this.verticalDirection = VerticalDirection.down,
  }) : super._();

  FlexGroupStyle copyWith({
    Axis? direction,
    TextDirection? textDirection,
    VerticalDirection? verticalDirection,
  }) {
    return FlexGroupStyle(
      direction: direction ?? this.direction,
      textDirection: textDirection ?? this.textDirection,
      verticalDirection: verticalDirection ?? this.verticalDirection,
    );
  }

  @override
  String toString() => (ToString(runtimeType)
        ..add('direction', direction)
        ..add('textDirection', textDirection)
        ..add('verticalDirection', verticalDirection))
      .toString();
}

/// Similar to [Table] without borders or [GridView] without scroll
class TableGroupStyle extends GroupStyle {
  /// [Flex.textDirection]
  final TextDirection? textDirection;

  /// [Flex.verticalDirection]
  final VerticalDirection mainVerticalDirection;

  /// [Flex.verticalDirection]
  final VerticalDirection crossVerticalDirection;

  final int crossAxisCount;

  const TableGroupStyle({
    this.textDirection,
    this.mainVerticalDirection = VerticalDirection.down,
    this.crossVerticalDirection = VerticalDirection.down,
    this.crossAxisCount = 2,
  })  : assert(crossAxisCount >= 2),
        super._();

  TableGroupStyle copyWith({
    TextDirection? textDirection,
    VerticalDirection? mainVerticalDirection,
    VerticalDirection? crossVerticalDirection,
    int? crossAxisCount,
  }) {
    return TableGroupStyle(
      textDirection: textDirection ?? this.textDirection,
      mainVerticalDirection:
          mainVerticalDirection ?? this.mainVerticalDirection,
      crossVerticalDirection:
          crossVerticalDirection ?? this.crossVerticalDirection,
      crossAxisCount: crossAxisCount ?? this.crossAxisCount,
    );
  }

  @override
  String toString() => (ToString(runtimeType)
        ..add('textDirection', textDirection)
        ..add('mainVerticalDirection', mainVerticalDirection)
        ..add('crossVerticalDirection', crossVerticalDirection)
        ..add('crossAxisCount', crossAxisCount))
      .toString();
}

/// [Wrap]
class WrapGroupStyle extends GroupStyle {
  /// [Wrap.direction]
  final Axis direction;

  /// [Wrap.alignment]
  final WrapAlignment alignment;

  /// [Wrap.spacing]
  final double spacing;

  /// [Wrap.runAlignment]
  final WrapAlignment runAlignment;

  /// [Wrap.runSpacing]
  final double runSpacing;

  /// [Wrap.crossAxisAlignment]
  final WrapCrossAlignment crossAxisAlignment;

  /// [Wrap.textDirection]
  final TextDirection? textDirection;

  /// [Wrap.verticalDirection]
  final VerticalDirection verticalDirection;

  /// [Wrap.clipBehavior]
  final Clip clipBehavior;

  const WrapGroupStyle({
    this.direction = Axis.horizontal,
    this.alignment = WrapAlignment.start,
    this.spacing = 0.0,
    this.runAlignment = WrapAlignment.start,
    this.runSpacing = 0.0,
    this.crossAxisAlignment = WrapCrossAlignment.start,
    this.textDirection,
    this.verticalDirection = VerticalDirection.down,
    this.clipBehavior = Clip.none,
  }) : super._();

  WrapGroupStyle copyWith({
    Axis? direction,
    WrapAlignment? alignment,
    double? spacing,
    WrapAlignment? runAlignment,
    double? runSpacing,
    WrapCrossAlignment? crossAxisAlignment,
    TextDirection? textDirection,
    VerticalDirection? verticalDirection,
    Clip? clipBehavior,
  }) {
    return WrapGroupStyle(
      direction: direction ?? this.direction,
      alignment: alignment ?? this.alignment,
      spacing: spacing ?? this.spacing,
      runAlignment: runAlignment ?? this.runAlignment,
      runSpacing: runSpacing ?? this.runSpacing,
      crossAxisAlignment: crossAxisAlignment ?? this.crossAxisAlignment,
      textDirection: textDirection ?? this.textDirection,
      verticalDirection: verticalDirection ?? this.verticalDirection,
      clipBehavior: clipBehavior ?? this.clipBehavior,
    );
  }

  @override
  String toString() => (ToString(runtimeType)
        ..add('direction', direction)
        ..add('alignment', alignment)
        ..add('spacing', spacing)
        ..add('runAlignment', runAlignment)
        ..add('crossAxisAlignment', crossAxisAlignment)
        ..add('textDirection', textDirection)
        ..add('verticalDirection', verticalDirection)
        ..add('clipBehavior', clipBehavior))
      .toString();
}

/// [ListView]
class ListGroupStyle extends GroupStyle {
  /// {@macro flutter.widgets.scroll_view.controller}
  final ScrollController? controller;

  /// {@macro flutter.widgets.scroll_view.primary}
  final bool? primary;

  /// {@macro flutter.widgets.scroll_view.scrollDirection}
  final Axis scrollDirection;

  /// {@macro flutter.widgets.scroll_view.reverse}
  final bool reverse;

  /// {@macro flutter.widgets.scroll_view.physics}
  final ScrollPhysics? physics;

  /// Fixed height of the group
  final double? height;

  /// Fixed width of the group
  final double? width;

  /// Pass either the [height] or the [width] according
  /// to the layout direction of the parent widget
  const ListGroupStyle({
    this.scrollDirection = Axis.vertical,
    this.reverse = false,
    this.controller,
    this.primary,
    this.physics,
    this.height,
    this.width,
  })  : assert(height != null || width != null),
        super._();

  ListGroupStyle copyWith({
    ScrollController? controller,
    bool? primary,
    Axis? scrollDirection,
    bool? reverse,
    ScrollPhysics? physics,
    double? height,
    double? width,
  }) {
    return ListGroupStyle(
      controller: controller ?? this.controller,
      primary: primary ?? this.primary,
      scrollDirection: scrollDirection ?? this.scrollDirection,
      reverse: reverse ?? this.reverse,
      physics: physics ?? this.physics,
      height: height ?? this.height,
      width: width ?? this.width,
    );
  }

  @override
  String toString() => (ToString(runtimeType)
        ..add('scrollDirection', scrollDirection)
        ..add('reverse', reverse)
        ..add('controller', controller)
        ..add('primary', primary)
        ..add('physics', physics)
        ..add('height', height)
        ..add('width', width))
      .toString();
}

/// [GridView]
class GridGroupStyle extends GroupStyle {
  /// {@macro flutter.widgets.scroll_view.controller}
  final ScrollController? controller;

  /// {@macro flutter.widgets.scroll_view.primary}
  final bool? primary;

  /// {@macro flutter.widgets.scroll_view.scrollDirection}
  final Axis scrollDirection;

  /// {@macro flutter.widgets.scroll_view.reverse}
  final bool reverse;

  /// {@macro flutter.widgets.scroll_view.physics}
  final ScrollPhysics? physics;

  /// [GridView.gridDelegate]
  final SliverGridDelegate gridDelegate;

  /// Fixed height of the group
  final double? height;

  /// Fixed width of the group
  final double? width;

  /// Pass either the [height] or the [width] according
  /// to the layout direction of the parent widget
  const GridGroupStyle({
    this.scrollDirection = Axis.vertical,
    this.reverse = false,
    this.controller,
    this.primary,
    this.physics,
    required this.gridDelegate,
    this.height,
    this.width,
  })  : assert(height != null || width != null),
        super._();

  GridGroupStyle copyWith({
    ScrollController? controller,
    bool? primary,
    Axis? scrollDirection,
    bool? reverse,
    ScrollPhysics? physics,
    SliverGridDelegate? gridDelegate,
    double? height,
    double? width,
  }) {
    return GridGroupStyle(
      controller: controller ?? this.controller,
      primary: primary ?? this.primary,
      scrollDirection: scrollDirection ?? this.scrollDirection,
      reverse: reverse ?? this.reverse,
      physics: physics ?? this.physics,
      gridDelegate: gridDelegate ?? this.gridDelegate,
      height: height ?? this.height,
      width: width ?? this.width,
    );
  }

  @override
  String toString() => (ToString(runtimeType)
        ..add('scrollDirection', scrollDirection)
        ..add('reverse', reverse)
        ..add('controller', controller)
        ..add('primary', primary)
        ..add('physics', physics)
        ..add('height', height)
        ..add('gridDelegate', gridDelegate)
        ..add('width', width))
      .toString();
}

/// {@template flutter_form_bloc.FieldBlocBuilder.groupStyle}
/// You can build the layout of your items (group)
/// based on the [style] you want to apply.
/// {@endtemplate}
class GroupView extends StatelessWidget {
  /// You can use:
  /// - [FlexGroupStyle] use a [Flex] widget. ([Column] or [Row])
  /// - [TableGroupStyle] uses a combination of [Column] and [Row] widgets
  ///   to create a table
  /// - [WrapGroupStyle] use a [Wrap] widget
  final GroupStyle style;

  /// Padding of the items the group
  final EdgeInsetsGeometry? padding;

  /// Quantity of the items in the group
  final int count;

  /// Builder of the items in the group
  final IndexedWidgetBuilder builder;

  const GroupView({
    Key? key,
    required this.style,
    this.padding,
    required this.count,
    required this.builder,
  })  : assert(count >= 0),
        super(key: key);

  Iterable<Widget> _generateChildren(BuildContext context) sync* {
    for (var i = 0; i < count; i++) {
      yield builder(context, i);
    }
  }

  Widget _buildPadded(Widget child) {
    if (padding != null) {
      return Padding(
        padding: padding!,
        child: child,
      );
    }
    return child;
  }

  Widget _buildLayout(BuildContext context, GroupStyle style) {
    if (style is FlexGroupStyle) {
      return _buildPadded(Flex(
        direction: style.direction,
        textDirection: style.textDirection,
        verticalDirection: style.verticalDirection,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: _generateChildren(context).toList(),
      ));
    } else if (style is TableGroupStyle) {
      final children = _generateChildren(context).map((child) {
        return Expanded(child: child);
      }).splitBetweenIndexed((index, _, __) {
        return (index % style.crossAxisCount) == 0;
      });
      return _buildPadded(Column(
        textDirection: style.textDirection,
        verticalDirection: style.mainVerticalDirection,
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: children.map((children) {
          return Row(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            verticalDirection: style.crossVerticalDirection,
            children: children,
          );
        }).toList(),
      ));
    } else if (style is WrapGroupStyle) {
      return _buildPadded(Wrap(
        direction: style.direction,
        alignment: style.alignment,
        spacing: style.spacing,
        runAlignment: style.runAlignment,
        runSpacing: style.runSpacing,
        crossAxisAlignment: style.crossAxisAlignment,
        textDirection: style.textDirection,
        verticalDirection: style.verticalDirection,
        children: _generateChildren(context).toList(),
      ));
    } else if (style is ListGroupStyle) {
      return SizedBox(
        height: style.height,
        width: style.width,
        child: ListView.builder(
          controller: style.controller,
          primary: style.primary,
          scrollDirection: style.scrollDirection,
          reverse: style.reverse,
          physics: style.physics,
          padding: padding,
          itemCount: count,
          itemBuilder: builder,
        ),
      );
    } else if (style is GridGroupStyle) {
      return SizedBox(
        height: style.height,
        width: style.width,
        child: GridView.builder(
          controller: style.controller,
          primary: style.primary,
          scrollDirection: style.scrollDirection,
          reverse: style.reverse,
          physics: style.physics,
          gridDelegate: style.gridDelegate,
          padding: padding,
          itemCount: count,
          itemBuilder: builder,
        ),
      );
    }
    throw 'Not support ${style.runtimeType} style';
  }

  @override
  Widget build(BuildContext context) => _buildLayout(context, style);
}
