part of '../field/field_bloc.dart';

class FormBlocUtils {
  FormBlocUtils._();

  static Iterable<SingleFieldBloc> getAllSingleFieldBlocs(
      Iterable<FieldBloc> fieldBlocs) {
    return fieldBlocs.expand((fieldBloc) {
      if (fieldBloc is SingleFieldBloc) {
        return [fieldBloc];
      } else if (fieldBloc is MultiFieldBloc) {
        return getAllSingleFieldBlocs(fieldBloc.flatFieldBlocs);
      }
      return const <SingleFieldBloc>[];
    });
  }

  static Iterable<FieldBloc> getAllFieldBlocs(Iterable<FieldBloc> fieldBlocs) {
    return fieldBlocs.expand<FieldBloc>((fieldBloc) {
      for (var fieldBloc in fieldBlocs) {
        if (fieldBloc is SingleFieldBloc) {
          return [fieldBloc];
        } else if (fieldBloc is MultiFieldBloc) {
          return <FieldBloc>[fieldBloc]
              .followedBy(getAllFieldBlocs(fieldBloc.flatFieldBlocs));
        }
      }
      return const <FieldBloc>[];
    });
  }

  /// Returns the corresponding [FieldBloc] to the [path].
  /// if it does not exist, return `null`.
  static FieldBloc? getFieldBlocFromPath({
    required String path,
    required Map<String, FieldBloc> fieldBlocs,
  }) {
    var names = path.split('/');

    FieldBloc? currentFieldBloc;

    for (var i = 0; i < names.length; i++) {
      final name = names[i];
      final isFirstName = i == 0;

      var isListIndex = name.startsWith('[') && name.endsWith(']');
      int? listIndex;

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
          if (currentFieldBloc is ListFieldBloc) {
            try {
              currentFieldBloc = currentFieldBloc.state.fieldBlocs[listIndex!];
            } on RangeError {
              return null;
            }
          } else {
            return null;
          }
        } else {
          if (currentFieldBloc is GroupFieldBloc) {
            currentFieldBloc = currentFieldBloc.state.fieldBlocs[name];
          } else {
            return null;
          }
        }
      }
    }

    return currentFieldBloc;
  }

  /// Returns the [FieldBloc] removed from the [name].
  /// if it does not exist, return `null`.
/*   static FieldBloc removeFieldBlocFromPath({
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

          // fieldBlocToRemoveParent.remove(nameOfFieldToRemove);
          return fieldBlocToRemove;
        } else if (fieldBlocToRemoveParent is FieldBlocList) {
          fieldBlocToRemoveParent.removeFieldBloc(int.tryParse(
              nameOfFieldToRemove.substring(
                  1, nameOfFieldToRemove.length - 1)));
          return fieldBlocToRemove;
        } else {
          return null;
        }
      }
    }
  } */

  /*  /// Adds the [fieldBloc] to the [path].
  /// Return `true` if the [fieldBloc] is added;
  static bool addFieldBlocToPath({
    @required String path,
    @required Map<String, FieldBloc> fieldBlocs,
    @required FieldBloc fieldBloc,
  }) {
    if (path == null) {
      Throw exception if the name already exist

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
  } */

  static Map<String, dynamic> fieldBlocsStatesToJson(
      Map<String, dynamic> fieldBlocsStates) {
    final json = <String, dynamic>{};

    fieldBlocsStates.forEach((name, dynamic fieldBlocState) {
      if (fieldBlocState is FieldBlocState) {
        json[name] = fieldBlocState.toJson();
      } else if (fieldBlocState is Map<String, dynamic>) {
        json[name] = fieldBlocsStatesToJson(fieldBlocState);
      }
      if (fieldBlocState is List<dynamic>) {
        json[name] = fieldBlocsStatesListToJsonList(fieldBlocState);
      }
    });
    return json;
  }

  static List<dynamic> fieldBlocsStatesListToJsonList(
      List<dynamic> fieldBlocsStatesList) {
    final list = <dynamic>[];

    for (var fieldBlocState in fieldBlocsStatesList) {
      if (fieldBlocState is FieldBlocState) {
        list.add(fieldBlocState.toJson());
      } else if (fieldBlocState is Map<String, dynamic>) {
        list.add(fieldBlocsStatesToJson(fieldBlocState));
      } else if (fieldBlocState is List<dynamic>) {
        list.add(fieldBlocsStatesListToJsonList(fieldBlocState));
      }
    }
    return list;
  }

  static Map<String, dynamic> fieldBlocsToFieldBlocsStates(
      Map<String, FieldBloc> fieldBlocs) {
    final json = <String, dynamic>{};

    fieldBlocs.forEach((name, fieldBloc) {
      if (fieldBloc is SingleFieldBloc) {
        json[name] = fieldBloc.state;
      } else if (fieldBloc is GroupFieldBloc) {
        json[name] = fieldBlocsToFieldBlocsStates(fieldBloc.state.fieldBlocs);
      }
      if (fieldBloc is ListFieldBloc) {
        json[name] = fieldBlocListToFieldBlocsStatesList(fieldBloc);
      }
    });
    return json;
  }

  static List<dynamic> fieldBlocListToFieldBlocsStatesList(
      ListFieldBloc fieldBlocList) {
    final list = <dynamic>[];

    for (var fieldBloc in fieldBlocList.state.fieldBlocs) {
      if (fieldBloc is SingleFieldBloc) {
        list.add(fieldBloc.state);
      } else if (fieldBloc is GroupFieldBloc) {
        list.add(fieldBlocsToFieldBlocsStates(fieldBloc.state.fieldBlocs));
      } else if (fieldBloc is ListFieldBloc) {
        list.add(fieldBlocListToFieldBlocsStatesList(fieldBloc));
      }
    }
    return list;
  }

  static Iterable<FieldBlocState> flattenFieldBlocsStateList(
      Iterable<dynamic> fieldBlocStateList) {
    final list = <FieldBlocState>[];

    for (var fieldBlocState in fieldBlocStateList) {
      if (fieldBlocState is FieldBlocState) {
        list.add(fieldBlocState);
      } else if (fieldBlocState is Map<String, dynamic>) {
        list.addAll(flattenFieldBlocsStateList(fieldBlocState.values));
      } else if (fieldBlocState is Iterable) {
        list.addAll(flattenFieldBlocsStateList(fieldBlocState));
      }
    }
    return list;
  }

  /// Returns the corresponding [FieldBlocState] of the
  /// [FieldBlocState] that is on the path.
  /// if it does not exist, return `null`.
  static dynamic getFieldBlocStateFromPath({
    required String path,
    required Map<String, dynamic> fieldBlocsStates,
  }) {
    var names = path.split('/');

    dynamic currentFieldBlocState;

    for (var i = 0; i < names.length; i++) {
      final name = names[i];
      final isFirstName = i == 0;

      var isListIndex = name.startsWith('[') && name.endsWith(']');
      int? listIndex;

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
          currentFieldBlocState = fieldBlocsStates[name];
        }
      } else {
        if (currentFieldBlocState == null ||
            currentFieldBlocState is FieldBlocState) {
          return null;
        }

        if (isListIndex) {
          if (currentFieldBlocState is List<dynamic>) {
            try {
              currentFieldBlocState = currentFieldBlocState[listIndex!];
            } on RangeError {
              return null;
            }
          } else {
            return null;
          }
        } else {
          if (currentFieldBlocState is Map<String, dynamic>) {
            currentFieldBlocState = currentFieldBlocState[name];
          } else {
            return null;
          }
        }
      }
    }

    return currentFieldBlocState;
  }

  static dynamic getValueOfFieldBlocsStates({
    required String path,
    required Map<String, dynamic> fieldBlocsStates,
  }) {
    final dynamic fieldBlocState = FormBlocUtils.getFieldBlocStateFromPath(
        path: path, fieldBlocsStates: fieldBlocsStates);

    if (fieldBlocState is FieldBlocState) {
      return fieldBlocState.value;
    } else if (fieldBlocState is List<dynamic>) {
      return fieldBlocsStatesListToJsonList(fieldBlocState);
    } else if (fieldBlocState is Map<String, dynamic>) {
      return fieldBlocsStatesToJson(fieldBlocState);
    } else {
      return null;
    }
  }

  static void updateFormBloc({
    required Iterable<FieldBloc> fieldBlocs,
    required FormBloc? formBloc,
    bool autoValidate = false,
  }) {
    if (formBloc == null) return;

    for (final fieldBloc in fieldBlocs) {
      fieldBloc.updateFormBloc(formBloc, autoValidate: autoValidate);
    }
  }

  static void removeFormBloc({
    required Iterable<FieldBloc> fieldBlocs,
    required FormBloc? formBloc,
  }) {
    if (formBloc == null) return;

    for (final fieldBloc in fieldBlocs) {
      fieldBloc.removeFormBloc(formBloc);
    }
  }

  /// See [FormBloc.isValuesChanged]
  static bool isValuesChanged(
    Iterable<FieldBloc> fieldBlocs, {
    bool fallback = false,
  }) {
    return fieldBlocs.any((fb) {
      if (fb is SingleFieldBloc) {
        return fb.isValueChanged;
      } else if (fb is MultiFieldBloc) {
        return fb.isValuesChanged;
      }
      return fallback;
    });
  }

  /// See [FormBloc.hasInitialValues]
  static bool hasInitialValues(
    Iterable<FieldBloc> fieldBlocs, {
    bool fallback = true,
  }) {
    return fieldBlocs.every((fb) {
      if (fb is SingleFieldBloc) {
        return fb.hasInitialValue;
      } else if (fb is MultiFieldBloc) {
        return fb.hasInitialValues;
      }
      return fallback;
    });
  }

  /// See [FormBloc.hasUpdatedValues]
  static bool hasUpdatedValues(
    Iterable<FieldBloc> fieldBlocs, {
    bool fallback = true,
  }) {
    return fieldBlocs.every((fb) {
      if (fb is SingleFieldBloc) {
        return fb.hasUpdatedValue;
      } else if (fb is MultiFieldBloc) {
        return fb.hasUpdatedValues;
      }
      return fallback;
    });
  }
}
