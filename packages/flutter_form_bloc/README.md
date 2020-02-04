# flutter_form_bloc

[![Pub](https://img.shields.io/pub/v/flutter_form_bloc.svg)](https://pub.dev/packages/flutter_form_bloc)

Create Beautiful Forms in Flutter. The easiest way to Prefill, Async Validation, Update Form Fields, and Show Progress, Failures, Successes or Navigate by Reacting to the Form State. 

Separate the Form State and Business Logic from the User Interface using [form_bloc](https://github.com/GiancarloCode/form_bloc/tree/master/packages/form_bloc).

---

To see complex examples, check out the [example project](https://github.com/GiancarloCode/form_bloc/tree/master/packages/flutter_form_bloc/example/lib/forms).

___

Before to use this package you need to know the [core concepts of bloc package](https://felangel.github.io/bloc/#/coreconcepts) and the [basics of flutter_bloc](https://github.com/felangel/bloc/tree/master/packages/flutter_bloc)

---


<div>
    <table>
        <tr>
            <td> 
                <a>
                    <img src="https://giancarlocode.com/wp-content/uploads/flutter_form_bloc_demo_1.gif" width="230"/>
                </a>
            </td>    
            <td>   
                <a>
                    <img src="https://giancarlocode.com/wp-content/uploads/flutter_form_bloc_demo_2.gif" width="230"/>                   
                </a>
            </td>
             <td>   
                <a>
                    <img src="https://giancarlocode.com/wp-content/uploads/flutter_form_bloc_demo_3.gif" width="230"/>                   
                </a>
            </td>        
        </tr>
        <tr>
            <td> 
                <a>
                    <img src="https://giancarlocode.com/wp-content/uploads/flutter_form_bloc_demo_4.gif" width="230"/>
                </a>
            </td>    
            <td>   
                <a>
                    <img src="https://giancarlocode.com/wp-content/uploads/flutter_form_bloc_demo_5.gif" width="230"/>                   
                </a>
            </td>
            <td>   
                <a>
                    <img src="https://giancarlocode.com/wp-content/uploads/flutter_form_bloc_demo_6.gif" width="230"/>                   
                </a>
            </td>            
        </tr>
        <tr>
            <td> 
                <a>
                    <img src="https://giancarlocode.com/wp-content/uploads/flutter_form_bloc_demo_7.gif" width="230"/>
                </a>
            </td>
            <td> 
                <a>
                    <img src="https://giancarlocode.com/wp-content/uploads/flutter_form_bloc_demo_8.gif" width="230"/>
                </a>
            </td>
            <td> 
                <a>
                    <img src="https://giancarlocode.com/wp-content/uploads/flutter_form_bloc_demo_9.gif" width="230"/>
                </a>
            </td>                      
        </tr>
    </table>
</div>

# Widgets
* [TextFieldBlocBuilder](https://pub.dev/documentation/flutter_form_bloc/latest/flutter_form_bloc/TextFieldBlocBuilder-class.html): A material design text field that can show suggestions.
* [DropdownFieldBlocBuilder](https://pub.dev/documentation/flutter_form_bloc/latest/flutter_form_bloc/DropdownFieldBlocBuilder-class.html): A material design dropdown.
* [RadioButtonGroupFieldBlocBuilder](https://pub.dev/documentation/flutter_form_bloc/latest/flutter_form_bloc/RadioButtonGroupFieldBlocBuilder-class.html): A material design radio buttons.
* [CheckboxFieldBlocBuilder](https://pub.dev/documentation/flutter_form_bloc/latest/flutter_form_bloc/CheckboxFieldBlocBuilder-class.html): A material design checkbox.
* [CheckboxGroupFieldBlocBuilder](https://pub.dev/documentation/flutter_form_bloc/latest/flutter_form_bloc/CheckboxGroupFieldBlocBuilder-class.html): A material design checkboxes.
* [FormBlocListener](https://pub.dev/documentation/flutter_form_bloc/latest/flutter_form_bloc/FormBlocListener-class.html): BlocListener that reacts to the state changes of the FormBloc.


## Note
[FormBloc](https://pub.dev/documentation/form_bloc/latest/form_bloc/FormBloc-class.html), [InputFieldBloc](https://pub.dev/documentation/form_bloc/latest/form_bloc/InputFieldBloc-class.html), [TextFieldBloc](https://pub.dev/documentation/form_bloc/latest/form_bloc/TextFieldBloc-class.html), [BooleanFieldBloc](https://pub.dev/documentation/form_bloc/latest/form_bloc/BooleanFieldBloc-class.html), [SelectFieldBloc](https://pub.dev/documentation/form_bloc/latest/form_bloc/SelectFieldBloc-class.html), [MultiSelectFieldBloc](https://pub.dev/documentation/form_bloc/latest/form_bloc/MultiSelectFieldBloc-class.html) are [blocs](https://pub.dev/documentation/bloc/latest/bloc/Bloc-class.html), so you can use [BlocBuilder](https://pub.dev/documentation/flutter_bloc/latest/flutter_bloc/BlocBuilder-class.html) or [BlocListener](https://pub.dev/documentation/flutter_bloc/latest/flutter_bloc/BlocListener-class.html) of [flutter_bloc](https://pub.dev/packages/flutter_bloc) for make any widget you want compatible with any `FieldBloc` or `FormBloc`.

If you want me to add other widgets please let me know, or make a pull request.

# Examples
* FieldBlocs with async validation: [BLoC](https://github.com/GiancarloCode/form_bloc/blob/master/packages/flutter_form_bloc/example/lib/forms/field_bloc_async_validation_form_bloc.dart) - [UI](https://github.com/GiancarloCode/form_bloc/blob/master/packages/flutter_form_bloc/example/lib/forms/field_bloc_async_validation_form.dart).
* Manually set FieldBloc error: [BLoC](https://github.com/GiancarloCode/form_bloc/blob/master/packages/flutter_form_bloc/example/lib/forms/manually_set_field_bloc_error_form_bloc.dart) - [UI](https://github.com/GiancarloCode/form_bloc/blob/master/packages/flutter_form_bloc/example/lib/forms/manually_set_field_bloc_error_form.dart).
* FormBloc with submission progress: [BLoC](https://github.com/GiancarloCode/form_bloc/blob/master/packages/flutter_form_bloc/example/lib/forms/progress_form_bloc.dart) - [UI](https://github.com/GiancarloCode/form_bloc/blob/master/packages/flutter_form_bloc/example/lib/forms/progress_form_bloc.dart).
* FormBloc without auto validation: [BLoC](https://github.com/GiancarloCode/form_bloc/blob/master/packages/flutter_form_bloc/example/lib/forms/not_auto_validation_form_bloc.dart) - [UI](https://github.com/GiancarloCode/form_bloc/blob/master/packages/flutter_form_bloc/example/lib/forms/not_auto_validation_form.dart).
* Complex async prefilled FormBloc: [BLoC](https://github.com/GiancarloCode/form_bloc/blob/master/packages/flutter_form_bloc/example/lib/forms/complex_async_prefilled_form_bloc.dart) - [UI](https://github.com/GiancarloCode/form_bloc/blob/master/packages/flutter_form_bloc/example/lib/forms/complex_async_prefilled_form.dart).
* [And more examples](https://github.com/GiancarloCode/form_bloc/tree/master/packages/flutter_form_bloc/example/lib/forms).



## Basic Example

```yaml
dependencies:
  form_bloc: ^0.8.0
  flutter_form_bloc: ^0.7.0
  flutter_bloc: ^3.2.0
```

```dart
import 'package:form_bloc/form_bloc.dart';

class LoginFormBloc extends FormBloc<String, String> {
  final emailField = TextFieldBloc(validators: [FieldBlocValidators.email]);
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
      yield state.toSuccess();
    } catch (e) {
      yield state.toFailure();
    }
  }
}
```


```dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:flutter_form_bloc_example/forms/simple_login_form_bloc.dart';
import 'package:flutter_form_bloc_example/widgets/widgets.dart';

class LoginForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<LoginFormBloc>(
      create: (context) =>
          LoginFormBloc(RepositoryProvider.of<UserRepository>(context)),
      child: Builder(
        builder: (context) {
          final formBloc = BlocProvider.of<LoginFormBloc>(context);

          return Scaffold(
            appBar: AppBar(title: Text('Simple login')),
            body: FormBlocListener<LoginFormBloc, String, String>(
              onSubmitting: (context, state) => LoadingDialog.show(context),
              onSuccess: (context, state) {
                LoadingDialog.hide(context);
                Navigator.of(context).pushReplacementNamed('success');
              },
              onFailure: (context, state) {
                LoadingDialog.hide(context);
                Notifications.showSnackBarWithError(
                    context, state.failureResponse);
              },
              child: ListView(
                children: <Widget>[
                  TextFieldBlocBuilder(
                    textFieldBloc: formBloc.emailField,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      prefixIcon: Icon(Icons.email),
                    ),
                  ),
                  TextFieldBlocBuilder(
                    textFieldBloc: formBloc.passwordField,
                    suffixButton: SuffixButton.obscureText,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      prefixIcon: Icon(Icons.lock),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: RaisedButton(
                      onPressed: formBloc.submit,
                      child: Center(child: Text('LOGIN')),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
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
  final emailField = TextFieldBloc(validators: [FieldBlocValidators.email]);
  final passwordField = TextFieldBloc();
}

```

## 3. Add Services/Repositories
In this example we need a `UserRepository` for make the login.

```dart
import 'package:form_bloc/form_bloc.dart';

class LoginFormBloc extends FormBloc<String, String> {
  final emailField = TextFieldBloc(validators: [FieldBlocValidators.email]);
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
  final emailField = TextFieldBloc(validators: [FieldBlocValidators.email]);
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


* [state.toFailure([FailureResponse failureResponse])](https://pub.dev/documentation/form_bloc/latest/form_bloc/FormBlocState/toFailure.html).
* [state.toSuccess([SuccessResponse successResponse])](https://pub.dev/documentation/form_bloc/latest/form_bloc/FormBlocState/toSuccess.html).
* [state.toLoaded()](https://pub.dev/documentation/form_bloc/latest/form_bloc/FormBlocState/toLoaded.html).

See other states [here](https://pub.dev/documentation/form_bloc/latest/form_bloc/FormBlocState-class.html#instance-methods).

For example `onSubmitting` of `LoginFormBloc` will return a `Stream<FormBlocState<String, String>> ` and yield `state.toSuccess()` if the `_userRepository.login` method not throw any exception, and yield ``state.toFailure()` if throw a exception.

```dart
import 'package:form_bloc/form_bloc.dart';

class LoginFormBloc extends FormBloc<String, String> {
  final emailField = TextFieldBloc(validators: [FieldBlocValidators.email]);
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
      yield state.toSuccess();
    } catch (e) {
      yield state.toFailure();
    }
  }
}
```

## 6. Create a Form Widget
You need to create a widget with access to the `FormBloc`.

In this case I will use `BlocProvider` for do it.


```dart
class LoginForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<LoginFormBloc>(
      create: (context) =>
          LoginFormBloc(RepositoryProvider.of<UserRepository>(context)),
      child: Builder(
        builder: (context) {
          final formBloc = BlocProvider.of<LoginFormBloc>(context);

          return Scaffold();
        },
      ),
    );
  }
}

```

## 6. Add FormBlocListener for manage form state changes

You need to add a `FormBlocListener`.

In this example:
* I will show a loading dialog when the state is loading.
* I will hide the dialog when the state is success, and navigate to success screen.
* I will hide the dialog when the state is failure, and show a snackBar with the error.

```dart
...
          return Scaffold(
            appBar: AppBar(title: Text('Simple login')),
            body: FormBlocListener<LoginFormBloc, String, String>(
              onSubmitting: (context, state) => LoadingDialog.show(context),
              onSuccess: (context, state) {
                LoadingDialog.hide(context);
                Navigator.of(context).pushReplacementNamed('success');
              },
              onFailure: (context, state) {
                LoadingDialog.hide(context);
                Notifications.showSnackBarWithError(
                    context, state.failureResponse);
              },
              child: 
              ),
            ),
          );
...          

```

## 6. Connect the Field Blocs with Field Blocs Builder

In this example I will use `TextFieldBlocBuilder` for connect with `emailField` and `passwordField` of `LoginFormBloc`.

```dart
...
              child: ListView(
                children: <Widget>[
                  TextFieldBlocBuilder(
                    textFieldBloc: formBloc.emailField,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      prefixIcon: Icon(Icons.email),
                    ),
                  ),
                  TextFieldBlocBuilder(
                    textFieldBloc: formBloc.passwordField,
                    suffixButton: SuffixButton.obscureText,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      prefixIcon: Icon(Icons.lock),
                    ),
                  ),
                ],
              ),
...          

```
## 7. Add a widget for submit the FormBloc

In this example I will add a `RaisedButton` and pass `submit` method of `FormBloc` to submit the form.

```dart
...
              child: ListView(
                children: <Widget>[
                  ...,
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: RaisedButton(
                      onPressed: formBloc.submit,
                      child: Center(child: Text('LOGIN')),
                    ),
                  ),
                ],
              ),
...          

```



# Credits
This package uses the following packages:

* [form_bloc](https://pub.dev/packages/form_bloc)
* [flutter_bloc](https://pub.dev/packages/flutter_bloc)
* [flutter_typeahead](https://pub.dev/packages/flutter_typeahead)
* [rxdart](https://pub.dev/packages/rxdart)
* [keyboard_visibility](https://pub.dev/packages/keyboard_visibility)

