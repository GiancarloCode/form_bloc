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
  flutter_form_bloc: ^0.10.0
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


```dart
import 'package:flutter/material.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:flutter_form_bloc_example/widgets/widgets.dart';
import 'package:flutter_form_bloc_example/forms/login_form_bloc.dart';

class LoginForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<LoginFormBloc>(
      create: (context) => LoginFormBloc(),
      child: Builder(
        builder: (context) {
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
              child: BlocBuilder<LoginFormBloc, FormBlocState>(
                builder: (context, state) {
                  return ListView(
                    physics: ClampingScrollPhysics(),
                    children: <Widget>[
                      TextFieldBlocBuilder(
                        textFieldBloc: state.fieldBlocFromPath('email'),
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          labelText: 'Email',
                          prefixIcon: Icon(Icons.email),
                        ),
                      ),
                      TextFieldBlocBuilder(
                        textFieldBloc: state.fieldBlocFromPath('password'),
                        suffixButton: SuffixButton.obscureText,
                        decoration: InputDecoration(
                          labelText: 'Password',
                          prefixIcon: Icon(Icons.lock),
                        ),
                      ),
                      FormButton(
                        text: 'LOGIN',
                        onPressed: context.bloc<LoginFormBloc>().submit,
                      ),
                    ],
                  );
                },
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

## 5. Create a Form Widget
You need to create a widget with access to the `FormBloc`.

In this case I will use `BlocProvider` for do it.


```dart
class LoginForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<LoginFormBloc>(
      create: (context) =>
          LoginFormBloc(),
      child: Builder(
        builder: (context) {
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

## 7. Connect the Field Blocs with Field Blocs Builder

You need to use a `BlocBuilder` with the `FormBloc`, then you can access to each field bloc by using `state.fieldBlocFromPath('path')`.

In this example I will use `TextFieldBlocBuilder` for connect with `email` field and `password` field of `LoginFormBloc`.

```dart
...
              child: BlocBuilder<LoginFormBloc, FormBlocState>(
                builder: (context, state) {
                  return ListView(
                    physics: ClampingScrollPhysics(),
                    children: <Widget>[
                      TextFieldBlocBuilder(
                        textFieldBloc: state.fieldBlocFromPath('email'),
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          labelText: 'Email',
                          prefixIcon: Icon(Icons.email),
                        ),
                      ),
                      TextFieldBlocBuilder(
                        textFieldBloc: state.fieldBlocFromPath('password'),
                        suffixButton: SuffixButton.obscureText,
                        decoration: InputDecoration(
                          labelText: 'Password',
                          prefixIcon: Icon(Icons.lock),
                        ),
                      ),
                    ],
                  );
                },
              ),
...          

```
## 8. Add a widget for submit the FormBloc

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

