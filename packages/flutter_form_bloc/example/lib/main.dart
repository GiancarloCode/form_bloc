import 'package:flutter/material.dart';
import 'package:flutter_form_bloc_example/bloc_delegate.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter_form_bloc_example/forms/complex_async_prefilled_form.dart';
import 'package:flutter_form_bloc_example/forms/complex_login_form.dart';
import 'package:flutter_form_bloc_example/forms/simple_async_prefilled_form.dart';
import 'package:flutter_form_bloc_example/forms/simple_login_form.dart';
import 'package:flutter_form_bloc_example/forms/simple_register_form.dart';
import 'package:flutter_form_bloc_example/styles/themes.dart';
import 'package:flutter_form_bloc_example/widgets/widgets.dart';

void main() {
  BlocSupervisor.delegate = SimpleBlocDelegate();
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: Themes.formTheme,
      routes: {
        '/': (context) => Home(),
        '/success': (context) => SuccessScreen(),
      },
    ),
  );
}

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter Form BLoC Example'),
        elevation: 2,
      ),
      body: ListView.separated(
        separatorBuilder: (_, __) => Divider(height: 1),
        itemCount: Form.forms.length,
        itemBuilder: (context, index) => ListItem(index, Form.forms[index]),
      ),
    );
  }
}

class ListItem extends StatelessWidget {
  final int index;
  final Form form;
  const ListItem(this.index, this.form, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(
        height: 28,
        child: CircleAvatar(
          backgroundColor: Theme.of(context).iconTheme.color,
          child: Text(
            '${index + 1}',
            style: TextStyle(
              color: Theme.of(context).scaffoldBackgroundColor,
            ),
          ),
        ),
      ),
      isThreeLine: true,
      title: Text(form.title),
      subtitle: Text(
        form.description,
        maxLines: 3,
        overflow: TextOverflow.ellipsis,
      ),
      onTap: () => Navigator.of(context)
          .push<void>(MaterialPageRoute(builder: (_) => form.widget)),
    );
  }
}

class Form {
  final String title;
  final String description;
  final Widget widget;

  Form(this.title, this.description, this.widget);

  static List<Form> forms = [
    Form(
      'Simple login',
      'Stateless, validators, text fields, and success response.',
      SimpleLoginForm(),
    ),
    Form(
      'Complex login',
      'Text field with used emails suggestions (delete on long press), dropdown field, focus nodes, and multiple responses.',
      ComplexLoginForm(),
    ),
    Form(
      'Simple register',
      'Focus nodes, complex validators, text fields, check box field, and success response.',
      SimpleRegisterForm(),
    ),
    Form(
      'Simple Async prefilled form',
      'Prefilled form with async data like Shared Preferences.',
      SimpleAsyncPrefilledForm(),
    ),
    Form(
      'Complex Async prefilled form',
      'Prefilled form with async data (like API fetch), and retry when fail to load.',
      ComplexAsyncPrefilledForm(),
    ),
  ];
}
