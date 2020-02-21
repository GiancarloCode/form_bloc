import 'package:form_bloc/form_bloc.dart';
import 'package:meta/meta.dart';

class FormBlocUtils {
  FormBlocUtils._();

  static List<SingleFieldBloc> getAllSingleFieldBlocs(
      Iterable<FieldBloc> fieldBlocs) {
    final singleFieldBlocs = <SingleFieldBloc>[];
    fieldBlocs.forEach(
      (fieldBloc) {
        if (fieldBloc is SingleFieldBloc) {
          singleFieldBlocs.add(fieldBloc);
        } else if (fieldBloc is GroupFieldBloc) {
          singleFieldBlocs.addAll(getAllSingleFieldBlocs(fieldBloc.values));
        }
        if (fieldBloc is FieldBlocList) {
          singleFieldBlocs.addAll(getAllSingleFieldBlocs(fieldBloc));
        }
      },
    );

    return singleFieldBlocs;
  }

  /// Returns the corresponding [FieldBloc] to the [path].
  /// if it does not exist, return `null`.
  static FieldBloc getFieldBlocFromPath({
    @required String path,
    @required Map<String, FieldBloc> fieldBlocs,
  }) {
    if (path == null) {
      return null;
    }

    var names = path.split('/');

    FieldBloc currentFieldBloc;

    for (var i = 0; i < names.length; i++) {
      final name = names[i];
      final isFirstName = i == 0;

      var isListIndex = name.startsWith('[') && name.endsWith(']');
      int listIndex;

      if (isListIndex) {
        listIndex = int.tryParse(name.substring(1, name.length - 1));

        if (listIndex != null) {
          isListIndex = true;
        } else {
          isListIndex = false;
        }
      }

      if (isFirstName) {
        if (isListIndex) {
          return null;
        } else {
          currentFieldBloc = fieldBlocs[name];
        }
      } else {
        if (currentFieldBloc == null || currentFieldBloc is SingleFieldBloc) {
          return null;
        }

        if (isListIndex) {
          if (currentFieldBloc is FieldBlocList) {
            try {
              currentFieldBloc = currentFieldBloc.asFieldBlocList[listIndex];
            } on RangeError {
              return null;
            }
          } else {
            return null;
          }
        } else {
          if (currentFieldBloc is GroupFieldBloc) {
            currentFieldBloc = currentFieldBloc.asGroupFieldBloc[name];
          } else {
            return null;
          }
        }
      }
    }

    return currentFieldBloc;
  }

  /// Returns the [FieldBloc] removed from the [path].
  /// if it does not exist, return `null`.
  static FieldBloc removeFieldBlocFromPath({
    @required String path,
    @required Map<String, FieldBloc> fieldBlocs,
  }) {
    if (path == null) {
      return null;
    }

    final fieldBlocToRemove =
        getFieldBlocFromPath(path: path, fieldBlocs: fieldBlocs);

    if (fieldBlocToRemove == null) {
      return null;
    } else {
      var names = path.split('/');
      final nameOfFieldToRemove = names.last;

      if (names.length == 1) {
        fieldBlocs.remove(names[0]);
        return fieldBlocToRemove;
      } else {
        final parentPathNames = List<String>.from(names)..removeLast();
        var parentPath = '';

        parentPathNames.forEach((name) => parentPath = parentPath + '$name/');

        parentPath = parentPath.substring(0, parentPath.length - 1);

        final fieldBlocToRemoveParent =
            getFieldBlocFromPath(path: parentPath, fieldBlocs: fieldBlocs);

        if (fieldBlocToRemoveParent is GroupFieldBloc) {
          fieldBlocToRemoveParent.remove(nameOfFieldToRemove);
          return fieldBlocToRemove;
        } else if (fieldBlocToRemoveParent is FieldBlocList) {
          fieldBlocToRemoveParent.removeAt(int.tryParse(nameOfFieldToRemove
              .substring(1, nameOfFieldToRemove.length - 1)));
          return fieldBlocToRemove;
        } else {
          return null;
        }
      }
    }
  }

  /// Adds the [fieldBloc] to the [path].
  /// Return `true` if the [fieldBloc] is added;
  static bool addFieldBlocToPath({
    @required String path,
    @required Map<String, FieldBloc> fieldBlocs,
    @required FieldBloc fieldBloc,
  }) {
    if (path == null) {
      // TODO: Throw exception if the name already exist

      if (fieldBloc is SingleFieldBloc) {
        fieldBlocs[fieldBloc.state.name] = fieldBloc;
        return true;
      } else if (fieldBloc is GroupFieldBloc) {
        fieldBlocs[fieldBloc.name] = fieldBloc;
        return true;
      } else if (fieldBloc is FieldBlocList) {
        fieldBlocs[fieldBloc.name] = fieldBloc;
        return true;
      } else {
        return false;
      }
    } else {
      final fieldBlocToAddParent =
          getFieldBlocFromPath(path: path, fieldBlocs: fieldBlocs);
      if (fieldBlocToAddParent is SingleFieldBloc) {
        return false;
      } else if (fieldBlocToAddParent is GroupFieldBloc) {
        if (fieldBloc is SingleFieldBloc) {
          fieldBlocToAddParent.asGroupFieldBloc[fieldBloc.state.name] =
              fieldBloc;
          return true;
        } else if (fieldBloc is GroupFieldBloc) {
          fieldBlocToAddParent.asGroupFieldBloc[fieldBloc.name] = fieldBloc;
          return true;
        } else if (fieldBloc is FieldBlocList) {
          fieldBlocToAddParent.asGroupFieldBloc[fieldBloc.name] = fieldBloc;
          return true;
        } else {
          return false;
        }
      } else if (fieldBlocToAddParent is FieldBlocList) {
        fieldBlocToAddParent.add(fieldBloc);
        return true;
      } else {
        return false;
      }
    }
  }
}
