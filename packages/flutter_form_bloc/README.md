# flutter_form_bloc

[![Pub](https://img.shields.io/pub/v/flutter_form_bloc.svg)](https://pub.dev/packages/flutter_form_bloc)

A Flutter package with flutter widgets that helps to create forms with [form_bloc](https://github.com/GiancarloCode/form_bloc/tree/master/packages/form_bloc) package.

---

To see complex examples check the [example project](https://github.com/GiancarloCode/form_bloc/tree/master/packages/flutter_form_bloc/example/lib/forms).

___

Before to use this package you need to know the [core concepts of bloc package](https://felangel.github.io/bloc/#/coreconcepts)  and the [basics of flutter_bloc](https://github.com/felangel/bloc/tree/master/packages/flutter_bloc)

---


<div>
    <table>
        <tr>
            <td> 
                <a>
                    <img src="https://giancarlocode.com/wp-content/uploads/flutter_form_bloc_example_1.gif" width="230"/>
                </a>
            </td>    
            <td>   
                <a>
                    <img src="https://giancarlocode.com/wp-content/uploads/flutter_form_bloc_example_2.gif" width="230"/>                   
                </a>
            </td>        
        </tr>
        <tr>
            <td> 
                <a>
                    <img src="https://giancarlocode.com/wp-content/uploads/flutter_form_bloc_example_3.gif" width="230"/>
                </a>
            </td>    
            <td>   
                <a>
                    <img src="https://giancarlocode.com/wp-content/uploads/flutter_form_bloc_example_4.gif" width="230"/>                   
                </a>
            </td>         
        </tr>
    </table>
</div>

# Widgets
* [TextFieldBlocBuilder`<Error>`](https://pub.dev/documentation/flutter_form_bloc/latest/flutter_form_bloc/TextFieldBlocBuilder-class.html)
* [DropdownFieldBlocBuilder`<Value>`](https://pub.dev/documentation/flutter_form_bloc/latest/flutter_form_bloc/DropdownFieldBlocBuilder-class.html)
* [RadioButtonGroupFieldBlocBuilder`<Value>`](https://pub.dev/documentation/flutter_form_bloc/latest/flutter_form_bloc/RadioButtonGroupFieldBlocBuilder-class.html)
* [CheckboxFieldBlocBuilder](https://pub.dev/documentation/flutter_form_bloc/latest/flutter_form_bloc/CheckboxFieldBlocBuilder-class.html)
* [FormBlocListener](https://pub.dev/documentation/flutter_form_bloc/latest/flutter_form_bloc/FormBlocListener-class.html)


## Note
`FormBloc`, `TextFieldBloc`, `SelectFieldBloc`, `FileFieldBloc` and `BooleanFieldBloc` are [blocs](https://pub.dev/documentation/bloc/latest/bloc/Bloc-class.html), so you can use `BlocBuilder` or `BlocListener` of [flutter_bloc](https://pub.dev/packages/flutter_bloc) for make any widget you want compatible with any `FieldBloc` or `FormBloc`.

If you want me to add other widgets please let me know, or make a pull request.



# Example

```yaml
dependencies:
  form_bloc: ^0.3.0
  flutter_form_bloc: ^0.2.0
  flutter_bloc: ^0.21.0
```

```dart
import 'package:form_bloc/form_bloc.dart';

class SimpleLoginFormBloc extends FormBloc<String, String> {
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


```dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:flutter_form_bloc_example/forms/simple_login_form_bloc.dart';
import 'package:flutter_form_bloc_example/widgets/widgets.dart';

class SimpleLoginForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<SimpleLoginFormBloc>(
      builder: (context) => SimpleLoginFormBloc(),
      child: Builder(
        builder: (context) {
          final formBloc = BlocProvider.of<SimpleLoginFormBloc>(context);

          return Scaffold(
            appBar: AppBar(title: Text('Simple login')),
            body: FormBlocListener<SimpleLoginFormBloc, String, String>(
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
                  TextFieldBlocBuilder<String>(
                    textFieldBloc: formBloc.emailField,
                    formBloc: formBloc,
                    errorBuilder: (context, error) => error,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      prefixIcon: Icon(Icons.email),
                    ),
                  ),
                  TextFieldBlocBuilder<String>(
                    textFieldBloc: formBloc.passwordField,
                    formBloc: formBloc,
                    errorBuilder: (context, error) => error,
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

For example, the `SuccessResponse` type and `FailureResponse` type of `SimpleLoginFormBloc` will be `String`.

```dart
import 'package:form_bloc/form_bloc.dart';

class SimpleLoginFormBloc extends FormBloc<String, String> {}

```

## 2. Create Field Blocs
You need to create field blocs, and these need to be final.

You can create:

* [TextFieldBloc`<Error>`](https://pub.dev/documentation/form_bloc/latest/form_bloc/TextFieldBloc-class.html)
* [SelectFieldBloc`<Value>`](https://pub.dev/documentation/form_bloc/latest/form_bloc/SelectFieldBloc-class.html)
* [BooleanFieldBloc](https://pub.dev/documentation/form_bloc/latest/form_bloc/BooleanFieldBloc-class.html)

For example the `SimpleLoginFormBloc` will have two `TextFieldBloc<String>`, so the `Error` type will be `String`, and the validators must return a error of `String` type.

```dart
import 'package:form_bloc/form_bloc.dart';

class SimpleLoginFormBloc extends FormBloc<String, String> {
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


For example the `SimpleLoginFormBloc` must return a List with `emailField` and `passwordField`.


```dart
import 'package:form_bloc/form_bloc.dart';

class SimpleLoginFormBloc extends FormBloc<String, String> {
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

For example `onSubmitting` of `SimpleLoginFormBloc` will return a `Stream<FormBlocState<String, String>> ` and  yield `currentState.toSuccess()`.

```dart
import 'package:form_bloc/form_bloc.dart';

class SimpleLoginFormBloc extends FormBloc<String, String> {
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

## 5. Create a Form Widget
You need to create a widget with access to the `FormBloc`.
In this case I will use `BlocProvider` for do it.
```dart
class SimpleLoginForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<SimpleLoginFormBloc>(
      builder: (context) => SimpleLoginFormBloc(),
      child: Builder(
        builder: (context) {
          final formBloc = BlocProvider.of<SimpleLoginFormBloc>(context);

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
            body: FormBlocListener<SimpleLoginFormBloc, String, String>(
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

In this example I will use `TextFieldBlocBuilder<String>` for connect with `emailField` and `passwordField` of `SimpleLoginFormBloc`.

```dart
...
              child: ListView(
                children: <Widget>[
                  TextFieldBlocBuilder<String>(
                    textFieldBloc: formBloc.emailField,
                    formBloc: formBloc,
                    errorBuilder: (context, error) => error,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      prefixIcon: Icon(Icons.email),
                    ),
                  ),
                  TextFieldBlocBuilder<String>(
                    textFieldBloc: formBloc.passwordField,
                    formBloc: formBloc,
                    errorBuilder: (context, error) => error,
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

In this example I will add a `RaisedButton` and pass `submit` method of `FormBloc` to submit the form

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

