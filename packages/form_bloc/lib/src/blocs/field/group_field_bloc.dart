part of 'field_bloc.dart';

/// `Map<String, FieldBloc>` used to group [FieldBloc]s.
class GroupFieldBloc extends DelegatingMap<String, FieldBloc> with FieldBloc {
  final Map<String, FieldBloc> _m = {};

  final List<FieldBloc> fieldBlocs;
  final String name;

  /// `Map<String, FieldBloc>` used to group [FieldBloc]s.
  ///
  /// ### Properties:
  ///
  /// * [name] : It is the string that identifies the fieldBloc.
  /// * [fieldBlocs] : `List<FieldBloc>` that will be used for the map,
  ///  where the `key` for each [FieldBloc] will be its `name`.
  GroupFieldBloc({@required this.name, @required this.fieldBlocs}) {
    if (fieldBlocs != null) {
      fieldBlocs.forEach((fieldBloc) {
        // TODO: Throw exception if the name already exist

        if (fieldBloc is SingleFieldBloc) {
          _m[fieldBloc.state.name] = fieldBloc;
        } else if (fieldBloc is GroupFieldBloc) {
          _m[fieldBloc.name] = fieldBloc;
        } else if (fieldBloc is FieldBlocList) {
          _m[fieldBloc.name] = fieldBloc;
        }
      });
    }
  }

  @override
  Map<String, FieldBloc> get delegate => _m;
}
