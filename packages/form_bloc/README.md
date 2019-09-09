# form_bloc
[![Pub](https://img.shields.io/pub/v/form_bloc.svg)](https://pub.dev/packages/form_bloc)

A dart package that helps to create forms with BLoC pattern using [bloc package](https://github.com/felangel/bloc/tree/master/packages/bloc) without writing a lot of boilerplate code.

---

To see complex examples check [flutter_form_bloc](https://github.com/GiancarloCode/form_bloc/tree/master/packages/flutter_form_bloc/).

___
Before to use this package you need to know the [core concepts](https://felangel.github.io/bloc/#/coreconcepts) of bloc package.

---

# Example

```yaml
dependencies:
  form_bloc: ^0.3.1
```

```dart
import 'package:form_bloc/form_bloc.dart';

class LoginFormBloc extends FormBloc<String, String> {
  final emailField = TextFieldBloc<String>(
    validators: [Validators.validEmail],
  );
  final passwordField = TextFieldBloc<String>(
    validators: [Validators.notEmpty],
  );

  @override
  List<FieldBloc> get fieldBlocs => [emailField, passwordField];

  @override
  Stream<FormBlocState<String, String>> onSubmitting() async* {
    // Login logic...
    await Future<void>.delayed(Duration(seconds: 2));
    yield currentState.toSuccess();
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

For example, the `SuccessResponse` type and `FailureResponse` type of `LoginFormBloc` will be `String`

```dart
import 'package:form_bloc/form_bloc.dart';

class LoginFormBloc extends FormBloc<String, String> {}

```

## 2. Create Field Blocs
You need to create field blocs, and these need to be final.

You can create:

* [TextFieldBloc`<Error>`](https://pub.dev/documentation/form_bloc/latest/form_bloc/TextFieldBloc-class.html)
* [SelectFieldBloc`<Value>`](https://pub.dev/documentation/form_bloc/latest/form_bloc/SelectFieldBloc-class.html)
* [BooleanFieldBloc](https://pub.dev/documentation/form_bloc/latest/form_bloc/BooleanFieldBloc-class.html)
* [FileFieldBloc](https://pub.dev/documentation/form_bloc/latest/form_bloc/FileFieldBloc-class.html)

For example the `LoginFormBloc` will have two `TextFieldBloc<String>`, so the `Error` type will be `String`, and the validators must return a error of `String` type.

```dart
import 'package:form_bloc/form_bloc.dart';

class LoginFormBloc extends FormBloc<String, String> {
  final emailField = TextFieldBloc<String>(
    validators: [Validators.validEmail],
  );
  final passwordField = TextFieldBloc<String>(
    validators: [Validators.notEmpty],
  );

}

```

## 3. Implement the get method fieldBlocs
You need to override the get method [fieldBlocs](https://pub.dev/documentation/form_bloc/latest/form_bloc/FormBloc/fieldBlocs.html) and return a list with all `FieldBlocs`.


For example the `LoginFormBloc` need to return a List with `emailField` and `passwordField`.


```dart
import 'package:form_bloc/form_bloc.dart';

class LoginFormBloc extends FormBloc<String, String> {
  final emailField = TextFieldBloc<String>(
    validators: [Validators.validEmail],
  );
  final passwordField = TextFieldBloc<String>(
    validators: [Validators.notEmpty],
  );

  @override
  List<FieldBloc> get fieldBlocs => [emailField, passwordField];

}

```

## 4. Implement onSubmitting method

[onSubmitting](https://pub.dev/documentation/form_bloc/latest/form_bloc/FormBloc/onSubmitting.html) return a `Stream<FormBlocState<SuccessResponse, FailureResponse>>` and will called when the form is submitting.

You must call all your business logic of this form here, and `yield` the corresponding state.

You can yield a new state using:  


* [currentState.toFailure([FailureResponse failureResponse])](https://pub.dev/documentation/form_bloc/latest/form_bloc/FormBlocState/toFailure.html)
* [currentState.toSuccess([SuccessResponse successResponse])](https://pub.dev/documentation/form_bloc/latest/form_bloc/FormBlocState/toFailure.html)
* [currentState.toLoaded()](https://pub.dev/documentation/form_bloc/latest/form_bloc/FormBlocState/toLoading.html)

For example `onSubmitting` of `LoginFormBloc` will return a `Stream<FormBlocState<String, String>> ` and  yield `currentState.toSuccess()`.

```dart
import 'package:form_bloc/form_bloc.dart';

class LoginFormBloc extends FormBloc<String, String> {
  final emailField = TextFieldBloc<String>(
    validators: [Validators.validEmail],
  );
  final passwordField = TextFieldBloc<String>(
    validators: [Validators.notEmpty],
  );

  @override
  List<FieldBloc> get fieldBlocs => [emailField, passwordField];

  @override
  Stream<FormBlocState<String, String>> onSubmitting() async* {
    // Login logic...
    await Future<void>.delayed(Duration(seconds: 2));
    yield currentState.toSuccess();
  }
}

```

# Credits
This package uses the following packages:

* [bloc](https://pub.dev/packages/bloc)
* [rxdart](https://pub.dev/packages/rxdart)
* [equatable](https://pub.dev/packages/equatable)
