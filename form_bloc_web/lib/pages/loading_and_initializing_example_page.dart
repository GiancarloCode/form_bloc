import 'package:flutter/material.dart';
import 'package:form_bloc_web/examples/loading_and_initializing_form.dart';
import 'package:form_bloc_web/widgets/widgets.dart';

class LoadingAndInitializingExamplePage extends StatelessWidget {
  const LoadingAndInitializingExamplePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ExampleScaffold(
      title: 'Loading and Initializing Example',
      demo: const DeviceScreen(app: LoadingForm()),
      code: const CodeScreen(
          codePath: 'lib/examples/loading_and_initializing_form.dart'),
      tutorial: TutorialScreen(
        children: <Widget>[
          const TutorialText('''
# 1. Create the field blocs         
'''),
          CodeCard.main(
            nestedPath: 'LoadingFormBloc',
            code: '''
class LoadingFormBloc extends FormBloc<String, String> {
  final text = TextFieldBloc();

  final select = SelectFieldBloc<String, dynamic>();
  
}  
''',
          ),
          TutorialText.sub('''
# 2. Set isLoading to true in the super constructor

By default `isLoading` is `false`, and the state of the form bloc is `FormBlocLoaded`, but when `isLoading` is `true`, the initial state of the form will be `FormBlocLoading`.
'''),
          CodeCard.main(
            nestedPath: 'LoadingFormBloc > LoadingFormBloc',
            code: '''
  LoadingFormBloc() : super(isLoading: true) {

  }
''',
          ),
          TutorialText.sub('''
# 3. Add the field blocs to the form bloc

'''),
          CodeCard.main(
            nestedPath: 'LoadingFormBloc > LoadingFormBloc',
            code: '''
    addFieldBlocs(
      fieldBlocs: [text, select],
    );
''',
          ),
          TutorialText.sub('''
# 3. Implement onLoading method

you must implement the `onLoading` method, which will be invoked after creating the form bloc if you set `isLoading` to `true` in the super constructor, 

This method will allow you to perform any type of logic to initialize the field blocs.

* To update the initial value of a field bloc you must use the `updateInitialValue` method
* to update the items of a select / multi-select field bloc you mus use the `updateItems` method.

Once you are initialized the field blocs you must emit a loaded state using `emitLoaded` and the state of the form bloc will be `FormBlocLoaded`

And in case you have not been able to initialize the field blocs, for example a network error, you must emit a  load failed state using `emitLoadFailed` and the state of the from bloc will be `FormBlocLoadFailed`

* And when the state is `FormBlocLoadFailed` you can call the `reload` method, so that `onLoading` is invoked again.

In our case the first time `onLoading` is called, it will fail, so we will use `emitLoadFailed` and the second time they will be initialized successfully, so we will use `emitLoaded.
'''),
          CodeCard.main(
            nestedPath: 'LoadingFormBloc > onLoading',
            code: '''
  var _throwException = true;

  @override
  void onLoading() async {
    try {
      await Future<void>.delayed(Duration(milliseconds: 1500));

      if (_throwException) {
        // Simulate network error
        throw Exception('Network request failed. Please try again later.');
      }

      text.updateInitialValue('I am prefilled');

      select
        ..updateItems(['Option A', 'Option B', 'Option C'])
        ..updateInitialValue('Option B');

      emitLoaded();
    } catch (e) {
      _throwException = false;

      emitLoadFailed();
    }
  }
''',
          ),
          TutorialText.sub('''
# 4. Show different widgets based on the state of the form bloc

You must use a `BlocBuilder` that will rebuild every time the form bloc changes state, so you can show different widgets based on each state.
In our case:
* FormBlocLoading: we will show a loading indicator
* FormBlocLoadFailed: we will show an error, and a button that will call the `reload` method so that `onLoading` will be called again.
* FormBlocLoaded and the remaining states: let's show the fields
'''),
          CodeCard.main(
            nestedPath: 'LoadingFormBloc > build',
            code: '''
              child: BlocBuilder<LoadingFormBloc, FormBlocState>(
                builder: (context, state) {
                  if (state is FormBlocLoading) {
                    return LoadingWidget();
                  } else if (state is FormBlocLoadFailed) {
                    return LoadFailedWidget();
                  } else {
                    return LoadedWidget();
                  }
                },
              ),
''',
          ),
          TutorialText.sub('''
That would be all, but if we want to optimize the number of rebuilds, the builder pad allows us to assign a condition so that it only rebuilds when it returns true.

In our case we want it to be rebuilt only when the state type changes, or in case the previous state and the current state are `FormBlocLoading` since the progress has changed, because you can add progress :).
'''),
          CodeCard.main(
            nestedPath: 'LoadingFormBloc > build',
            code: '''
              child: BlocBuilder<LoadingFormBloc, FormBlocState>(
                condition: (previous, current) =>
                    previous.runtimeType != current.runtimeType ||
                    previous is FormBlocLoading && current is FormBlocLoading,
                    builder: (context, state) {

                },
              ),
''',
          ),
        ],
      ),
    );
  }
}
