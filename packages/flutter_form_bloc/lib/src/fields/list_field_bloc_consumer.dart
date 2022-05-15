import 'package:collection/collection.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_form_bloc/src/cubit_consumer.dart';
import 'package:form_bloc/form_bloc.dart';

class MultiFieldBlocConsumer<TFieldBloc extends FieldBloc,
    TState extends MultiFieldBlocState> extends StatelessWidget {
  final MultiFieldBloc<dynamic, TState> multiFieldBloc;
  final CubitCondition<TState>? listenWhen;
  final CubitListener<TState>? listener;
  final CubitCondition<TState>? buildWhen;
  final Widget? child;
  final CubitBuilder<TState>? builder;

  const MultiFieldBlocConsumer({
    Key? key,
    required this.multiFieldBloc,
    this.listenWhen,
    this.listener,
    this.buildWhen,
    this.child,
    this.builder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SourceConsumer<TState>(
      source: multiFieldBloc,
      listenWhen: listenWhen,
      listener: listener,
      buildWhen: buildWhen,
      child: child,
      builder: builder,
    );
  }
}

class ListFieldBlocConsumer<TFieldBloc extends FieldBloc, TExtraData>
    extends MultiFieldBlocConsumer<TFieldBloc,
        ListFieldBlocState<TFieldBloc, TExtraData>> {
  const ListFieldBlocConsumer({
    Key? key,
    required ListFieldBloc<TFieldBloc, TExtraData> listFieldBloc,
    CubitCondition<ListFieldBlocState<TFieldBloc, TExtraData>>? listenWhen,
    CubitListener<ListFieldBlocState<TFieldBloc, TExtraData>>? listener,
    CubitCondition<ListFieldBlocState<TFieldBloc, TExtraData>>? buildWhen =
        fieldBlocsChanges,
    Widget? child,
    CubitBuilder<ListFieldBlocState<TFieldBloc, TExtraData>>? builder,
  }) : super(
          key: key,
          multiFieldBloc: listFieldBloc,
          listener: listener,
          builder: builder,
          child: child,
        );

  static bool fieldBlocsChanges(
      ListFieldBlocState prev, ListFieldBlocState curr) {
    return prev.fieldBlocs.equals(curr.fieldBlocs);
  }
}
