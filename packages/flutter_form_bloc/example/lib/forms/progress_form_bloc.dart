import 'dart:async';
import 'dart:io';
import 'package:form_bloc/form_bloc.dart';
import 'package:rxdart/rxdart.dart';

class ProgressFormBloc extends FormBloc<String, String> {
  List<FakeUpload> _fakeUploads = List();
  List<StreamSubscription<double>> _fakeUploadProgressSubscriptions = List();

  ProgressFormBloc() {
    addFieldBloc(fieldBloc: InputFieldBloc<File>(name: 'image'));
    addFieldBloc(
      fieldBloc: TextFieldBloc(
        name: 'name',
        initialValue: '🔥 GiancarloCode 🔥',
      ),
    );
  }

  @override
  Stream<FormBlocState<String, String>> onCancelSubmission() async* {
    _fakeUploads.last.cancel();
    yield state.toSubmitting(0.0);
    await Future<void>.delayed(Duration(milliseconds: 400));
    updateState(state.toSubmissionCancelled());
  }

  @override
  Stream<FormBlocState<String, String>> onSubmitting() async* {
    print(state.fieldBlocFromPath('name').asTextFieldBloc.value);
    print(state.fieldBlocFromPath('image').asInputFieldBloc<File>().value);

    final int _currentUploadIndex = _fakeUploads.length;
    _fakeUploads.add(FakeUpload());
    _fakeUploadProgressSubscriptions.add(
      _fakeUploads[_currentUploadIndex].uploadProgress.listen(
        (progress) {
          if (!_fakeUploads[_currentUploadIndex].isCancelled) {
            updateState(state.toSubmitting(progress));
          }
        },
        onDone: () async {
          if (!_fakeUploads[_currentUploadIndex]._isCancelled) {
            await Future<void>.delayed(Duration(milliseconds: 400));
            updateState(state.toSuccess());
          }
        },
      ),
    );
  }
}

class FakeUpload {
  final BehaviorSubject<double> _subject = BehaviorSubject.seeded(0.0);
  bool _isCancelled = false;
  bool get isCancelled => _isCancelled;

  Stream<double> get uploadProgress => _subject.stream;

  FakeUpload() {
    _subject.doOnDone(() {
      _subject.close();
    });
    _initUpload();
  }

  void _initUpload() async {
    int milliseconds = 400;
    while (_subject.value < 1) {
      await Future.delayed(Duration(milliseconds: milliseconds));

      if (!_isCancelled) {
        _subject.add(_subject.value + 0.2);
        milliseconds += 400;
      } else {
        break;
      }
    }
    _subject.close();
  }

  void cancel() {
    _isCancelled = true;
    _subject.close();
  }
}
