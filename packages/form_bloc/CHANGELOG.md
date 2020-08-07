# 0.19.1
* Fix add `FormBloc` of items in `ListFieldBloc`.

# 0.19.0
## Breaking changes
* Updated to `bloc: ^6.0.0`.
* Fix `onError` of `FormBlocObserver`.

# 0.18.0
Bad version, you should use `>=0.19.0` or `<= 0.15.0`

# 0.17.0
Bad version, you should use `>=0.19.0` or `<= 0.15.0`

# 0.16.0
Bad version, you should use `>=0.19.0` or `<= 0.15.0`

# 0.15.0
## Breaking changes
* Updated to `bloc: ^5.0.1`.
* Change `Bloc.addError` to `Bloc.addFieldError`.
* Change `FormBlocDelegate` to `FormBlocObserver`.

# 0.14.0
* Updated to `bloc: ^4.0.0`

# 0.13.1
* Fixed pedantic version.

# 0.13.0
* Now the value of all field blocs are updated when call `updateValue` and `updateInitialValue` when the `FormBlocState` is `FormBlocSubmitting`.

# 0.12.0
## Breaking changes
* Removed `isRequired` parameter in all field blocs.

# 0.11.1
* Deprecated `isRequired` parameter in all field blocs, in form_bloc `^0.12.0` will be removed, if you want a field to be required, please use the validator `FieldBlocValidators.required`.

# 0.11.0
## Breaking changes
* Add support for forms with steps.
  * Use `AddFieldBloc({int step, List<FieldBloc> fieldBlocs})`.
* All `SingleFieldBloc`s now have `ExtraData` type.
* Changes `FieldBlocList` to `ListFieldBloc`.
* Add `GroupFieldBloc` as base class for create typed groups of field blocs.
* Add `toJson` method to `FormBlocState`.
* Remove `FormBlocState.getFieldBlocFromPath`.
* Add `valueOf` method to `FormBlocState`.
* Add `fieldBlocOf` method to `FormBlocState`.
* Remove `onReload` of `FormBloc`, now when you call `FormBloc.reload`, `onLoading` will be called.
* Add `onValueChanges` StreamSubscription to `SingleFieldBloc`.
* Add `FormBlocUpdatingFields` state.
* Add `isRequired` parameter to `FieldBloc`, and the error is `FieldBlocValidatorsError.required`, so the follow validators are removed:
  * `FieldBlocValidators.requiredInputFieldBloc`
  * `FieldBlocValidators.requiredBooleanFieldBloc`
  * `FieldBlocValidators.requiredTextFieldBloc`
  * `FieldBlocValidators.requiredSelectFieldBloc`
  * `FieldBlocValidators.requiredMultiSelectFieldBloc`
* Add `FormBlocUpdatingFields` state.
* Add `progress` property to `FormBlocLoading` and `FormBlocDeleting`.
* Change ` Stream<State> onSubmitting()` to `void onSubmitting()`.
* Change ` Stream<State> onLoading()` to `void onLoading()`.
* Change ` Stream<State> onDeleting()` to `void onDeleting()`.
* Add methods for emit new states:
  * emitSuccess
  * emitFailure
  * emitSubmitting
  * emitLoading
  * emitLoadFailed
  * emitLoaded
  * emitSubmissionCancelled
  * emitDeleteFailed
  * emitDeleteSuccessful
  * emitUpdatingFields

# 0.10.4
* Fixed minor bug.

# 0.10.3
* Fixed `hasFailureResponse` property of `FormBlocLoadFailed`, `FormBlocFailure` and `FormBlocDeleteFailed`.

# 0.10.2
* Changes `FieldBloc.addError(String error)` to `FieldBloc.addError(String error, {bool isPermanent = false})`.
* Documentation Updates.

# 0.10.1

* `clear` method of `FieldBloc` now call `updateInitialValue` instead of `updateValue`.
* Fixed `clear` method of `FormBloc`.
* Documentation Updates.

# 0.10.0
## Breaking changes

* Removed `fieldBlocs` getter of `FormBloc`. now you must use `addFieldBloc` method.
* Renamed `onDelete` method of `FormBloc` to `onDeleting`.
* Added `canSubmitAgain` parameter to `toSuccess` method of `FormBlocState`.
* Now `FieldBloc` can be dynamically added to a `FormBloc` with `addFieldBloc`.
* Now `FieldBloc` can be dynamically removed from a `FormBloc` with `removeFieldBloc`.
* Added `fieldBlocs` property to `FormBlocState`.
* `FieldBloc` is now implemented by 3 classes:
  * `SingleFieldBloc` which is the Interface of:
    * `InputFieldBloc`.
    * `TextFieldBloc`.
    * `BooleanFieldBloc`.
    * `SelectFieldBloc`.
    * `MultiSelectFieldBloc`.
  * `GroupFieldBloc`.
  * `FieldBlocList`.
* Documentation Updates.




# 0.8.0
* Added `isEditing` property to `FormBlocState` ([#9](https://github.com/GiancarloCode/form_bloc/issues/9)).
* Added `delete` event to `FormBloc` ([#9](https://github.com/GiancarloCode/form_bloc/issues/9)).
* Added `toDeleteFailed` and `toDeleteSuccessful` methods to `FormBlocState` ([#9](https://github.com/GiancarloCode/form_bloc/issues/9)).
* If the `initialValue` of `TextFieldBloc` is `null` is will be an empty String `''`.
* If the `initialValue` of `BooleanFieldBloc` is `null` it will be `false`.
* If the `initialValue` of `MultiSelectFieldBloc` is `null` it will be an empty list `[]`.

# 0.7.0
* Updated to `bloc: ^3.0.0`

# 0.6.0
* Updated to `bloc: ^1.0.0`
    * `bloc.state.listen` -> `bloc.listen`
    * `bloc.currentState` -> `bloc.state`
    * `dispatch` -> `add`
    * `dispose` -> `close`
* Documentation Updates.
* `Validators` -> `FieldBlocValidators`
* `ValidatorsError` -> `FieldBlocValidatorsErrors`
* Removed `isRequired` property from `FieldBloc` and `FieldBlocState`.

# 0.5.2
* Documentation Updates.
* Fixed a bug in `isValid` property of `fieldBlocState`.
* Prevented to update `FieldBloc.value` if is the same value and is validated.
* Improved `requiredTextFieldBloc` validator.

# 0.5.1
* Fixed a bug in `MultiSelectFieldBloc`.

# 0.5.0
* Dependency and Documentation Updates.
* Added `isValidating` property to `FieldBlocState`.
* Added `asyncValidators` property to `FieldBloc`.
* Added `asyncValidatorDebounceTime` property to `FieldBloc`.
* Added `addAsyncValidators` method to `FieldBloc`.
* Added `updateAsyncValidators` method to `FieldBloc`.
* Added `addError` method to `FieldBloc`.
* Added `subscribeToFieldBlocs` method to `FieldBloc`.

# 0.4.1
* Documentation Updates.

# 0.4.0
* Documentation Updates.
* Added Tests.
* Added `autoValidate` property to `FormBloc`.
* Added `InputFieldBloc<Value>`.
* Removed `FileFieldBloc`, now you can use `InputFieldBloc<File>`.
* Added `MultiSelectFieldBloc<Value>`.
* Added `error` property to `FieldBlocState`.
* Added `canShowError` property to `FieldBlocState`.
* Added `canShowProgress` property to `FieldBlocState`.
* Added `suggestions` property to `FieldBlocState`.
* Added `isRequired` property to `FieldBlocState`.
* Changes `TextFieldBloc<Error>` to `TextFieldBloc`.
* Added `valueToInt` property to `TextFieldBlocState`.
* Added `valueToDouble` property to `TextFieldBlocState`.
* Added `FormBlocDelegate`.

# 0.3.1

* Added `isCanceling` property to `FormBlocSubmitting`.

# 0.3.0

* Dependency and Documentation Updates.
* Added `submissionProgress` property to `FormBlocState`.
* Added `canSubmit` property to `FormBlocState`.
* Added `FormBlocSubmissionFailed` state to `FormBloc`.
* Added `FormBlocSubmissionCancelled` state to `FormBloc`.
* Added `cancelSubmission` event to `FormBloc`.
* Added `updateState` event to `FormBloc`.
* Added `onCancelSubmission` method to `FormBloc`.
* Added `FileFieldBloc`.

# 0.2.0

* Documentation Updates
# 0.1.0

* Initial Version of the library.
