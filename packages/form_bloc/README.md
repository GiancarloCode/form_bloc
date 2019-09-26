# form_bloc
[![Pub](https://img.shields.io/pub/v/form_bloc.svg)](https://pub.dev/packages/form_bloc)

Easy Form State Management using BLoC pattern. Separate the Form State and Business Logic from the User Interface. Validation, Progress, Failures, Successes, and more.

---

To see complex examples, check out [flutter_form_bloc](https://github.com/GiancarloCode/form_bloc/tree/master/packages/flutter_form_bloc/).

___
Before to use this package you need to know the [core concepts](https://felangel.github.io/bloc/#/coreconcepts) of bloc package.

---

# Example

```yaml
dependencies:
  form_bloc: ^0.4.0
```

```dart
import 'package:form_bloc/form_bloc.dart';

class LoginFormBloc extends FormBloc<String, String> {
  final emailField = TextFieldBloc(validators: [Validators.email]);
  final passwordField = TextFieldBloc();

  final UserRepository _userRepository;

  LoginFormBloc(this._userRepository);

  @override
  List<FieldBloc> get fieldBlocs => [emailField, passwordField];

  @override
  Stream<FormBlocState<String, String>> onSubmitting() async* {
    try {
      _userRepository.login(
        email: emailField.value,
        password: passwordField.value,
      );
      yield currentState.toSuccess();
    } catch (e) {
      yield currentState.toFailure();
    }
  }
}

```

# Basic use

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

* [InputFieldBloc`<Value>`](https://pub.dev/documentation/form_bloc/latest/form_bloc/InputFieldBloc-class.html).
* [TextFieldBloc](https://pub.dev/documentation/form_bloc/latest/form_bloc/TextFieldBloc-class.html).
* [BooleanFieldBloc](https://pub.dev/documentation/form_bloc/latest/form_bloc/BooleanFieldBloc-class.html).
* [SelectFieldBloc`<Value>`](https://pub.dev/documentation/form_bloc/latest/form_bloc/SelectFieldBloc-class.html).
* [MultiSelectFieldBloc`<Value>`](https://pub.dev/documentation/form_bloc/latest/form_bloc/MultiSelectFieldBloc-class.html).

For example the `LoginFormBloc` will have two `TextFieldBloc`.

```dart
import 'package:form_bloc/form_bloc.dart';

class LoginFormBloc extends FormBloc<String, String> {
  final emailField = TextFieldBloc(validators: [Validators.email]);
  final passwordField = TextFieldBloc();
}

```


## 3. Add Services/Repositories
In this example we need a `UserRepository` for make the login.

```dart
import 'package:form_bloc/form_bloc.dart';

class LoginFormBloc extends FormBloc<String, String> {
  final emailField = TextFieldBloc(validators: [Validators.email]);
  final passwordField = TextFieldBloc();

  final UserRepository _userRepository;

  LoginFormBloc(this._userRepository);
}

```

## 4. Implement the get method fieldBlocs
You need to override the get method [fieldBlocs](https://pub.dev/documentation/form_bloc/latest/form_bloc/FormBloc/fieldBlocs.html) and return a list with all `FieldBlocs`.


For example the `LoginFormBloc` need to return a List with `emailField` and `passwordField`.


```dart
import 'package:form_bloc/form_bloc.dart';

class LoginFormBloc extends FormBloc<String, String> {
  final emailField = TextFieldBloc(validators: [Validators.email]);
  final passwordField = TextFieldBloc();

  final UserRepository _userRepository;

  LoginFormBloc(this._userRepository);

  @override
  List<FieldBloc> get fieldBlocs => [emailField, passwordField];
}

```

## 5. Implement onSubmitting method

[onSubmitting](https://pub.dev/documentation/form_bloc/latest/form_bloc/FormBloc/onSubmitting.html) returns a `Stream<FormBlocState<SuccessResponse, FailureResponse>>`.

This method is called when you call `loginFormBloc.submit()` and `FormBlocState.isValid` is `true`, so each field bloc has a valid value.

You can get the current `value` of each field bloc calling `emailField.value` or `passwordField.value`.

You must call all your business logic of this form here, and `yield` the corresponding state.

You can yield a new state using:  


* [currentState.toFailure([FailureResponse failureResponse])](https://pub.dev/documentation/form_bloc/latest/form_bloc/FormBlocState/toFailure.html).
* [currentState.toSuccess([SuccessResponse successResponse])](https://pub.dev/documentation/form_bloc/latest/form_bloc/FormBlocState/toSuccess.html).
* [currentState.toLoaded()](https://pub.dev/documentation/form_bloc/latest/form_bloc/FormBlocState/toLoaded.html).

See other states [here](https://pub.dev/documentation/form_bloc/latest/form_bloc/FormBlocState-class.html#instance-methods).

For example `onSubmitting` of `LoginFormBloc` will return a `Stream<FormBlocState<String, String>> ` and yield `currentState.toSuccess()` if the `_userRepository.login` method not throw any exception, and yield `currentState.toFailure()` if throw a exception.

```dart
import 'package:form_bloc/form_bloc.dart';

class LoginFormBloc extends FormBloc<String, String> {
  final emailField = TextFieldBloc(validators: [Validators.email]);
  final passwordField = TextFieldBloc();

  final UserRepository _userRepository;

  LoginFormBloc(this._userRepository);

  @override
  List<FieldBloc> get fieldBlocs => [emailField, passwordField];

  @override
  Stream<FormBlocState<String, String>> onSubmitting() async* {
    try {
      _userRepository.login(
        email: emailField.value,
        password: passwordField.value,
      );
      yield currentState.toSuccess();
    } catch (e) {
      yield currentState.toFailure();
    }
  }
}
```

# Credits
This package uses the following packages:

* [bloc](https://pub.dev/packages/bloc)
* [rxdart](https://pub.dev/packages/rxdart)
* [equatable](https://pub.dev/packages/equatable)
* [quiver](https://pub.dev/packages/quiver)
