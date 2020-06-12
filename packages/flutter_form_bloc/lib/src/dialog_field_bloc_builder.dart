import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:flutter_form_bloc/src/can_show_field_bloc_builder.dart';
import 'package:flutter_form_bloc/src/utils/utils.dart';
import 'package:form_bloc/form_bloc.dart';

class DialogFieldBlocBuilder<T> extends StatefulWidget {
  const DialogFieldBlocBuilder({
    Key key,
    @required this.inputFieldBloc,
    @required this.showDialog,
    @required this.convertToString,
    this.enableOnlyWhenFormBlocCanSubmit = false,
    this.isEnabled = true,
    this.errorBuilder,
    this.padding,
    this.decoration = const InputDecoration(),
    this.textDirection,
    @required this.animateWhenCanShow,
    this.showClearIcon = true,
    this.clearIcon,
    this.nextFocusNode,
    this.focusNode,
  })  : assert(enableOnlyWhenFormBlocCanSubmit != null),
        assert(isEnabled != null),
        assert(decoration != null),
        super(key: key);

  final InputFieldBloc<T, Object> inputFieldBloc;

  final FieldBlocErrorBuilder errorBuilder;

  final bool enableOnlyWhenFormBlocCanSubmit;

  final bool isEnabled;

  final EdgeInsetsGeometry padding;

  final InputDecoration decoration;

  final bool animateWhenCanShow;

  final FocusNode nextFocusNode;

  final FocusNode focusNode;

  final bool showClearIcon;

  final Icon clearIcon;

  final TextDirection textDirection;

  final Future<T> Function(BuildContext context) showDialog;

  final String Function(T value) convertToString;

  @override
  _DialogFieldBlocBuilderState createState() =>
      _DialogFieldBlocBuilderState<T>();
}

class _DialogFieldBlocBuilderState<T> extends State<DialogFieldBlocBuilder<T>> {
  FocusNode _focusNode = FocusNode();

  FocusNode get _effectiveFocusNode => widget.focusNode ?? _focusNode;

  @override
  void initState() {
    _effectiveFocusNode.addListener(_onFocusRequest);
    super.initState();
  }

  @override
  void dispose() {
    _effectiveFocusNode.removeListener(_onFocusRequest);
    _focusNode.dispose();
    super.dispose();
  }

  void _onFocusRequest() {
    if (_effectiveFocusNode.hasFocus) {
      _showDialog(context);
    }
  }

  Future<void> _showDialog(BuildContext context) async {
    FocusScope.of(context).requestFocus(FocusNode());
    T result = await widget.showDialog(context);
    if (result != null) {
      fieldBlocBuilderOnChange<T>(
        isEnabled: widget.isEnabled,
        nextFocusNode: widget.nextFocusNode,
        onChanged: (value) {
          widget.inputFieldBloc.updateInitialValue(value);
        },
      )(result);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.inputFieldBloc == null) {
      return SizedBox();
    }

    return Focus(
      focusNode: _effectiveFocusNode,
      child: CanShowFieldBlocBuilder(
        fieldBloc: widget.inputFieldBloc,
        animate: widget.animateWhenCanShow,
        builder: (_, __) {
          return BlocBuilder<InputFieldBloc<T, Object>,
              InputFieldBlocState<T, Object>>(
            bloc: widget.inputFieldBloc,
            builder: (context, state) {
              final isEnabled = fieldBlocIsEnabled(
                isEnabled: widget.isEnabled,
                enableOnlyWhenFormBlocCanSubmit:
                    widget.enableOnlyWhenFormBlocCanSubmit,
                fieldBlocState: state,
              );

              Widget child;

              if (state.value == null && widget.decoration.hintText != null) {
                child = Text(
                  widget.decoration.hintText,
                  style: widget.decoration.hintStyle,
                  overflow: TextOverflow.ellipsis,
                  maxLines: widget.decoration.hintMaxLines,
                );
              } else {
                child = Text(
                  state.value != null
                      ? widget.convertToString(state.value)
                      : '',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  softWrap: true,
                  style: Style.getDefaultTextStyle(
                    context: context,
                    isEnabled: isEnabled,
                  ),
                );
              }

              return DefaultFieldBlocBuilderPadding(
                padding: widget.padding,
                child: GestureDetector(
                  onTap: !isEnabled ? null : () => _showDialog(context),
                  child: InputDecorator(
                    decoration: _buildDecoration(context, state, isEnabled),
                    isEmpty: state.value == null &&
                        widget.decoration.hintText == null,
                    child: child,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  InputDecoration _buildDecoration(BuildContext context,
      InputFieldBlocState<T, Object> state, bool isEnabled) {
    InputDecoration decoration = this.widget.decoration;

    decoration = decoration.copyWith(
      enabled: isEnabled,
      errorText: Style.getErrorText(
        context: context,
        errorBuilder: widget.errorBuilder,
        fieldBlocState: state,
        fieldBloc: widget.inputFieldBloc,
      ),
      suffixIcon: decoration.suffixIcon ??
          (widget.showClearIcon
              ? AnimatedOpacity(
                  duration: Duration(milliseconds: 400),
                  opacity:
                      widget.inputFieldBloc.state.value == null ? 0.0 : 1.0,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(25),
                    child: widget.clearIcon ?? Icon(Icons.clear),
                    onTap: widget.inputFieldBloc.state.value == null
                        ? null
                        : widget.inputFieldBloc.clear,
                  ),
                )
              : null),
    );

    return decoration;
  }
}
