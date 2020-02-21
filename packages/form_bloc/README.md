# form_bloc
[![Pub](https://img.shields.io/pub/v/form_bloc.svg)](https://pub.dev/packages/form_bloc)

Easy Form State Management using BLoC pattern. Separate the Form State and Business Logic from the User Interface. Dynamic Fields, Async Validation, Progress, Failures, Successes, and more.

---

To create beautiful forms in Flutter using `form_bloc` check out [flutter_form_bloc](https://github.com/GiancarloCode/form_bloc/tree/master/packages/flutter_form_bloc/).

___
Before to use this package you need to know the [core concepts](https://felangel.github.io/bloc/#/coreconcepts) of bloc package.

---


# Examples
* Form with dynamic fields: [BLoC](https://github.com/GiancarloCode/form_bloc/blob/master/packages/flutter_form_bloc/example/lib/forms/dynamic_fields_form_bloc.dart) - [UI](https://github.com/GiancarloCode/form_bloc/blob/master/packages/flutter_form_bloc/example/lib/forms/dynamic_fields_form.dart).
* FieldBlocs with async validation: [BLoC](https://github.com/GiancarloCode/form_bloc/blob/master/packages/flutter_form_bloc/example/lib/forms/field_bloc_async_validation_form_bloc.dart) - [UI](https://github.com/GiancarloCode/form_bloc/blob/master/packages/flutter_form_bloc/example/lib/forms/field_bloc_async_validation_form.dart).
* Manually set FieldBloc error: [BLoC](https://github.com/GiancarloCode/form_bloc/blob/master/packages/flutter_form_bloc/example/lib/forms/manually_set_field_bloc_error_form_bloc.dart) - [UI](https://github.com/GiancarloCode/form_bloc/blob/master/packages/flutter_form_bloc/example/lib/forms/manually_set_field_bloc_error_form.dart).
* FormBloc with submission progress: [BLoC](https://github.com/GiancarloCode/form_bloc/blob/master/packages/flutter_form_bloc/example/lib/forms/progress_form_bloc.dart) - [UI](https://github.com/GiancarloCode/form_bloc/blob/master/packages/flutter_form_bloc/example/lib/forms/progress_form_bloc.dart).
* FormBloc without auto validation: [BLoC](https://github.com/GiancarloCode/form_bloc/blob/master/packages/flutter_form_bloc/example/lib/forms/not_auto_validation_form_bloc.dart) - [UI](https://github.com/GiancarloCode/form_bloc/blob/master/packages/flutter_form_bloc/example/lib/forms/not_auto_validation_form.dart).
* Complex async prefilled FormBloc: [BLoC](https://github.com/GiancarloCode/form_bloc/blob/master/packages/flutter_form_bloc/example/lib/forms/complex_async_prefilled_form_bloc.dart) - [UI](https://github.com/GiancarloCode/form_bloc/blob/master/packages/flutter_form_bloc/example/lib/forms/complex_async_prefilled_form.dart).
* [And more examples](https://github.com/GiancarloCode/form_bloc/tree/master/packages/flutter_form_bloc/example/lib/forms).





## Basic Example

```yaml
dependencies:
  form_bloc: ^0.10.0
```

```dart
import 'package:form_bloc/form_bloc.dart';

class LoginFormBloc extends FormBloc<String, String> {
  LoginFormBloc() {
    addFieldBloc(
      fieldBloc: TextFieldBloc(
        name: 'email',
        validators: [FieldBlocValidators.email],
      ),
    );

    addFieldBloc(
      fieldBloc: TextFieldBloc(
        name: 'password',
        validators: [FieldBlocValidators.requiredTextFieldBloc],
      ),
    );
  }

  @override
  Stream<FormBlocState<String, String>> onSubmitting() async* {
    // Login logic...

    // Get the fields values:
    print(state.fieldBlocFromPath('email').asTextFieldBloc.value);
    print(state.fieldBlocFromPath('password').asTextFieldBloc.value);

    await Future<void>.delayed(Duration(seconds: 2));
    yield state.toSuccess();
  }
}
```


# Basic usage

## 1. Import it
```dart
import 'package:form_bloc/form_bloc.dart';
```

## 2. Create a class that extends FormBloc<SuccessResponse, FailureResponse>

[FormBloc<SuccessResponse, FailureResponse>](https://pub.dev/documentation/form_bloc/latest/form_bloc/FormBloc-class.html)

**`SuccessResponse`** The type of the success response.

**`FailureResponse`** The type of the failure response.

For example, the `SuccessResponse` type and `FailureResponse` type of `LoginFormBloc` will be `String`.

```dart
import 'package:form_bloc/form_bloc.dart';

class LoginFormBloc extends FormBloc<String, String> {}

```

## 3. Create the Field Blocs
Add the field blocs to the form bloc using `addFieldBloc` method.

You can create:

* [InputFieldBloc`<Value>`](https://pub.dev/documentation/form_bloc/latest/form_bloc/InputFieldBloc-class.html).
* [TextFieldBloc](https://pub.dev/documentation/form_bloc/latest/form_bloc/TextFieldBloc-class.html).
* [BooleanFieldBloc](https://pub.dev/documentation/form_bloc/latest/form_bloc/BooleanFieldBloc-class.html).
* [SelectFieldBloc`<Value>`](https://pub.dev/documentation/form_bloc/latest/form_bloc/SelectFieldBloc-class.html).
* [MultiSelectFieldBloc`<Value>`](https://pub.dev/documentation/form_bloc/latest/form_bloc/MultiSelectFieldBloc-class.html).

For example the `LoginFormBloc` will have two `TextFieldBloc`.

The `name` parameter must be an unique string and will serve to identify that field bloc.

The state of the form has a `Map<String, FieldBloc> fieldBlocs` property, in which each field bloc can be accessed using its name as a key.

```dart
import 'package:form_bloc/form_bloc.dart';

class LoginFormBloc extends FormBloc<String, String> {
  LoginFormBloc() {
    addFieldBloc(
      fieldBloc: TextFieldBloc(
        name: 'email',
        validators: [FieldBlocValidators.email],
      ),
    );

    addFieldBloc(
      fieldBloc: TextFieldBloc(
        name: 'password',
        validators: [FieldBlocValidators.requiredTextFieldBloc],
      ),
    );
  }
}

```

## 4. Implement onSubmitting method

[onSubmitting](https://pub.dev/documentation/form_bloc/latest/form_bloc/FormBloc/onSubmitting.html) returns a `Stream<FormBlocState<SuccessResponse, FailureResponse>>`.

This method is called when you call `loginFormBloc.submit()` and `FormBlocState.isValid` is `true`, so each field bloc has a valid value.

To get the value of each field bloc you can do it through the `state` of the form bloc, and using the `fieldBlocFromPath` method that receives a `path` and will return the corresponding field bloc. Then you will have to cast the corresponding type and you will get the value by using the `value` property.

The `path` is a `String` that allows easy access to the `Map<String, FieldBloc> fieldBlocs` that is found in `state.fieldBlocs`.

To access nested field Blocs, you must use the `/` character.

Examples:
* `email`
* `group1/name`
* `group1/group2/name/`


You must call all your business logic of this form here, and `yield` the corresponding state.

You can yield a new state using:  


* [state.toFailure([FailureResponse failureResponse])](https://pub.dev/documentation/form_bloc/latest/form_bloc/FormBlocState/toFailure.html).
* [state.toSuccess([SuccessResponse successResponse])](https://pub.dev/documentation/form_bloc/latest/form_bloc/FormBlocState/toSuccess.html).
* [state.toLoaded()](https://pub.dev/documentation/form_bloc/latest/form_bloc/FormBlocState/toLoaded.html).

See other states [here](https://pub.dev/documentation/form_bloc/latest/form_bloc/FormBlocState-class.html#instance-methods).


```dart
import 'package:form_bloc/form_bloc.dart';

class LoginFormBloc extends FormBloc<String, String> {
  LoginFormBloc() {
    addFieldBloc(
      fieldBloc: TextFieldBloc(
        name: 'email',
        validators: [FieldBlocValidators.email],
      ),
    );

    addFieldBloc(
      fieldBloc: TextFieldBloc(
        name: 'password',
        validators: [FieldBlocValidators.requiredTextFieldBloc],
      ),
    );
  }

  @override
  Stream<FormBlocState<String, String>> onSubmitting() async* {
    // Login logic...

    // Get the fields values:
    print(state.fieldBlocFromPath('email').asTextFieldBloc.value);
    print(state.fieldBlocFromPath('password').asTextFieldBloc.value);

    await Future<void>.delayed(Duration(seconds: 2));
    yield state.toSuccess();
  }
}
```
# Credits
This package uses the following packages:

* [bloc](https://pub.dev/packages/bloc)
* [rxdart](https://pub.dev/packages/rxdart)
* [equatable](https://pub.dev/packages/equatable)
* [quiver](https://pub.dev/packages/quiver)
