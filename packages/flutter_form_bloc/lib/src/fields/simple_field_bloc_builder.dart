import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_bloc/src/cubit_consumer.dart';
import 'package:flutter_form_bloc/src/features/appear/can_show_field_bloc_builder.dart';
import 'package:flutter_form_bloc/src/features/scroll/scrollable_field_bloc_target.dart';
import 'package:flutter_form_bloc/src/form/form_bloc_provider.dart';
import 'package:form_bloc/form_bloc.dart';

class FieldBlocBuilderData extends Equatable {
  final bool canShow;
  final bool isReadonly;
  final bool isEnabled;
  final FocusNode? nextFocusNode;

  const FieldBlocBuilderData({
    required this.canShow,
    required this.isReadonly,
    required this.isEnabled,
    required this.nextFocusNode,
  });

  bool canChange({bool isEnabled = true}) =>
      !isReadonly && this.isEnabled && isEnabled;

  ValueChanged<T>? buildOnChange<T>({
    bool isEnabled = true,
    required void Function(T value) onChanged,
  }) {
    if (isReadonly) return null;
    if (!this.isEnabled || !isEnabled) return null;
    final nextFocusNode = this.nextFocusNode;
    if (nextFocusNode != null) {
      return (value) {
        onChanged(value);
        nextFocusNode.nextFocus();
      };
    }
    return onChanged;
  }

  @override
  List<Object?> get props => [canShow, isReadonly, isEnabled];
}

/// Use these widgets:
/// - [CanShowFieldBlocBuilder]
/// - [ScrollableFieldBlocTarget]
class SimpleFieldBlocBuilder<TState extends FieldBlocStateBase>
    extends StatelessWidget {
  final FieldBloc<TState> fieldBloc;
  final bool animateWhenCanShow;
  final bool focusOnValidationFailed;
  final bool enableOnlyWhenFormBlocCanSubmit;
  final bool isEnabled;
  final bool readOnly;
  final FocusNode? nextFocusNode;
  final Widget Function(
    BuildContext context,
    TState state,
    FieldBlocBuilderData data,
  ) builder;

  const SimpleFieldBlocBuilder({
    Key? key,
    required this.fieldBloc,
    this.animateWhenCanShow = true,
    this.focusOnValidationFailed = true,
    this.enableOnlyWhenFormBlocCanSubmit = true,
    this.isEnabled = true,
    this.readOnly = false,
    this.nextFocusNode,
    required this.builder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget _buildField({
      bool canShow = true,
      bool isSubmitting = false,
      required TState state,
    }) {
      final data = FieldBlocBuilderData(
        canShow: canShow,
        isReadonly: readOnly || isSubmitting,
        isEnabled: isEnabled,
        nextFocusNode: nextFocusNode,
      );
      final child = builder(context, state, data);

      if (!canShow) {
        return child;
      }

      return ScrollableFieldBlocTarget(
        singleFieldBloc: fieldBloc,
        canScroll: focusOnValidationFailed,
        child: child,
      );
    }

    Widget _buildAnimatedField({
      required FieldBloc formBloc,
      bool isSubmitting = false,
      required TState state,
    }) {
      return CanShowFieldBlocBuilder(
        formBloc: formBloc,
        fieldBloc: fieldBloc,
        animate: animateWhenCanShow,
        builder: (context, canShow) {
          return _buildField(
            canShow: canShow,
            isSubmitting: isSubmitting,
            state: state,
          );
        },
      );
    }

    Widget _buildLockableField({
      required FormBloc formBloc,
      required TState state,
    }) {
      return SourceConsumer<bool>(
        source: formBloc.select((state) => state is FormBlocSubmitting),
        builder: (context, isSubmitting, _) {
          return _buildAnimatedField(
            formBloc: formBloc,
            isSubmitting: isSubmitting,
            state: state,
          );
        },
      );
    }

    return SourceConsumer<TState>(
      source: fieldBloc,
      builder: (context, state, _) {
        final formBloc = FormBlocProvider.maybeOf(context);

        if (formBloc == null) {
          return _buildField(
            state: state,
          );
        }

        if (!enableOnlyWhenFormBlocCanSubmit || formBloc is! FormBloc) {
          return _buildAnimatedField(
            formBloc: formBloc,
            state: state,
          );
        }

        return _buildLockableField(
          formBloc: formBloc,
          state: state,
        );
      },
    );
  }
}
