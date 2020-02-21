part of 'field_bloc.dart';

/// `List<FieldBloc>` used usually to dynamic fields.
class FieldBlocList extends DelegatingList<FieldBloc> with FieldBloc {
  final List<FieldBloc> _l = [];

  final List<FieldBloc> fieldBlocs;

  final String name;

  /// `List<FieldBloc>` used usually to dynamic fields.
  ///
  /// ### Properties:
  ///
  /// * [name] : It is the string that identifies the fieldBloc.
  /// * [fieldBlocs] : `List<FieldBloc>` that will be used for the list.
  FieldBlocList({@required this.name, @required this.fieldBlocs}) {
    if (fieldBlocs != null) {
      _l.addAll(fieldBlocs);
    }
  }
  @override
  List<FieldBloc> get delegate => _l;
}
