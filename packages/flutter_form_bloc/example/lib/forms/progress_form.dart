import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:flutter_form_bloc_example/forms/progress_form_bloc.dart';
import 'package:flutter_form_bloc_example/widgets/liquid_linear_progress_indicator_with_text.dart';
import 'package:flutter_form_bloc_example/widgets/widgets.dart';
import 'package:image_picker/image_picker.dart';

class ProgressForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<ProgressFormBloc>(
      create: (context) => ProgressFormBloc(),
      child: Builder(
        builder: (context) {
          final formBloc = BlocProvider.of<ProgressFormBloc>(context);

          return Scaffold(
            appBar: AppBar(title: Text('Form with progress')),
            body: FormBlocListener<ProgressFormBloc, String, String>(
                onSuccess: (context, state) {
              Navigator.of(context).pushReplacementNamed('success');
            }, child: BlocBuilder<ProgressFormBloc, FormBlocState>(
              builder: (context, state) {
                return ListView(
                  physics: ClampingScrollPhysics(),
                  children: <Widget>[
                    AnimatedContainer(
                      duration: Duration(milliseconds: 500),
                      height: state is FormBlocSubmitting ||
                              state is FormBlocSuccess
                          ? 46
                          : 0,
                      padding: EdgeInsets.only(bottom: 16),
                      child: LiquidLinearProgressIndicatorWithText(
                        duration: Duration(milliseconds: 300),
                        percent: state.submissionProgress,
                      ),
                    ),
                    ImageFieldBlocBuilder(
                      fileFieldBloc: state.fieldBlocFromPath('image'),
                    ),
                    TextFieldBlocBuilder(
                      padding: EdgeInsets.fromLTRB(8, 24, 8, 12),
                      textFieldBloc: state.fieldBlocFromPath('name'),
                      decoration: InputDecoration(
                        labelText: 'Name',
                        prefixIcon: Icon(Icons.account_circle),
                      ),
                      enableOnlyWhenFormBlocCanSubmit: true,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: BlocBuilder<ProgressFormBloc, FormBlocState>(
                        builder: (context, state) {
                          if (state is FormBlocSubmitting) {
                            return WillPopScope(
                              onWillPop: () async {
                                Notifications.showSnackBarWithSuccess(context,
                                    'Can\'t close, please wait until form is submitted, or cancel the submission.');
                                return false;
                              },
                              child: state.isCanceling
                                  ? RaisedButton(
                                      onPressed: () => null,
                                      child: Center(child: Text('CANCELING')),
                                    )
                                  : RaisedButton(
                                      onPressed: formBloc.cancelSubmission,
                                      child: Center(child: Text('CANCEL')),
                                    ),
                            );
                          } else {
                            return RaisedButton(
                              onPressed: formBloc.submit,
                              child: Center(child: Text('SUBMIT')),
                            );
                          }
                        },
                      ),
                    )
                  ],
                );
              },
            )),
          );
        },
      ),
    );
  }
}

class ImageFieldBlocBuilder extends StatelessWidget {
  final InputFieldBloc<File> fileFieldBloc;
  const ImageFieldBlocBuilder({
    Key key,
    @required this.fileFieldBloc,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (fileFieldBloc == null) {
      return Container();
    }
    return BlocBuilder<InputFieldBloc<File>, InputFieldBlocState<File>>(
      bloc: fileFieldBloc,
      builder: (context, state) {
        return Column(
          children: <Widget>[
            Stack(
              children: <Widget>[
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(60),
                  ),
                  margin: EdgeInsets.zero,
                  clipBehavior: Clip.antiAlias,
                  elevation: 16,
                  color: state.value != null ? Colors.grey[700] : Colors.white,
                  child: Opacity(
                    opacity: state.formBlocState.canSubmit ? 1 : 0.5,
                    child: state.value != null
                        ? Image.file(
                            state.value,
                            height: 120,
                            width: 120,
                            fit: BoxFit.fill,
                          )
                        : Container(
                            height: 120,
                            width: 120,
                            child: Icon(
                              Icons.add_photo_alternate,
                              color: Colors.black87,
                              size: 70,
                            ),
                          ),
                  ),
                ),
                Positioned.fill(
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      splashColor: Theme.of(context).accentColor.withAlpha(50),
                      highlightColor:
                          Theme.of(context).accentColor.withAlpha(50),
                      borderRadius: BorderRadius.circular(60),
                      onTap: state.formBlocState.canSubmit
                          ? () async {
                              final image = await ImagePicker.pickImage(
                                source: ImageSource.gallery,
                              );
                              if (image != null) {
                                fileFieldBloc.updateValue(image);
                              }
                            }
                          : null,
                    ),
                  ),
                ),
              ],
            ),
            AnimatedContainer(
              duration: Duration(milliseconds: 300),
              height: state.canShowError ? 30 : 0,
              child: SingleChildScrollView(
                physics: ClampingScrollPhysics(),
                child: Column(
                  children: <Widget>[
                    SizedBox(height: 8),
                    Text(
                      'Please select an Image',
                      style: TextStyle(
                        color: Theme.of(context).errorColor,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
