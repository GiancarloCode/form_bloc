import 'dart:io';
import 'package:form_bloc/form_bloc.dart';
import 'package:form_bloc/src/blocs/file_field/file_field_event.dart';
import 'package:form_bloc/src/blocs/file_field/file_field_state.dart';

export 'package:form_bloc/src/blocs/file_field/file_field_event.dart';
export 'package:form_bloc/src/blocs/file_field/file_field_state.dart';

class FileFieldBloc
    extends FieldBloc<File, FileFieldEvent, FileFieldBlocState> {
  final File _initialValue;
  final String _toStringName;
  final bool _isRequired;

  FileFieldBloc({
    String toStringName,
    File initialValue,
    bool isRequired = true,
  })  : _initialValue = initialValue,
        _toStringName = toStringName,
        _isRequired = isRequired;

  @override
  FileFieldBlocState get initialState => FileFieldBlocState(
        toStringName: _toStringName,
        isInitial: true,
        isRequired: _isRequired,
        value: _initialValue,
      );

  @override
  void clear() => dispatch(UpdateFileFieldBlocInitialValue(null));

  @override
  void updateInitialValue(File value) =>
      dispatch(UpdateFileFieldBlocInitialValue(value));

  @override
  void updateValue(File value) => dispatch(UpdateFileFieldBlocValue(value));

  @override
  Stream<FileFieldBlocState> mapEventToState(FileFieldEvent event) async* {
    if (event is UpdateFileFieldBlocValue) {
      yield currentState.withValue(event.value, isInitial: false);
    } else if (event is UpdateFileFieldBlocInitialValue) {
      yield currentState.withValue(event.value, isInitial: true);
    }
  }
}
