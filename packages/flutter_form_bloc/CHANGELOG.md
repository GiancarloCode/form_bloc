# 0.19.0
  ## Breaking changes
  * Updated to `form_bloc: ^0.18.0`.
  * Updated to `flutter_bloc: ^6.0.0`.

# 0.18.0
Bad version, you should use `>=0.19.0` or `<= 0.15.1`.

# 0.17.0
Bad version, you should use `>=0.19.0` or `<= 0.15.1`.

# 0.16.0
Bad version, you should use `>=0.19.0` or `<= 0.15.1`.

# 0.15.1
  * Fix widgets in web platform.

# 0.15.0
  ## Breaking changes
  * Updated to `form_bloc: ^0.15.0`.
  * Updated to `flutter_bloc: ^0.15.1`.

# 0.14.0
* Updated to `form_bloc: ^0.14.0`.
* Updated to `flutter_bloc: ^0.4.0`.

# 0.13.1
* Updated to `form_bloc: ^0.13.1`.

# 0.13.0+1
* Fixed pub health suggestions

# 0.13.0
* Changed `keyboard_utils` to `flutter_keyboard_visibility`.
* `FormBlocListener` now is compatible with `MultiBlocListener`.
* Added `FocusNode` and `NextFocusNode` to:
  * `DateTimeFieldBlocBuilder`
  * `TimeFieldBlocBuilder`

# 0.12.3
* Fixed `pickerBuilder` in `DateTimeFieldBlocBuilder`.

# 0.12.2
* Fixed Intl version.

# 0.12.1
* Fixed minor bug in Stepper [54](https://github.com/GiancarloCode/form_bloc/issues/54).

# 0.12.0+1
* Fixed changelog.

# 0.12.0
* ## Breaking changes
  * Updated to `form_bloc: ^0.12.0`.

* Added properties to `TextFieldBlocBuilder`:
  * obscureTextTrueIcon
  * obscureTextFalseIcon
  * clearTextIcon
  * asyncValidatingIcon

# 0.11.2
* Added `clearIcon` to:
  * `DateTimeFieldBlocBuilder`
  * `TimeFieldBlocBuilder`

# 0.11.1
* Fixed content padding of decoration in:
  * `DropdownFieldBlocBuilder`
  * `DateTimeFieldBlocBuilder`
  * `TimeFieldBlocBuilder`

# 0.11.0+1
* Fixed pub health issues

# 0.11.0
## Breaking changes

* Updated to `form_bloc: ^0.11.0`.
* Added `StepperFormBlocBuilder`.
* Added `DateTimeFieldBlocBuilder`.
* Added `TimeFieldBlocBuilder`.
* Added `CanShowFieldBlocBuilder`.
* All widgets now are animated by default if the `FieldBloc` is added or removed from the `FormBloc`.
* Documentation Updates.


# 0.10.6
* Fixed bug of size on first rendered of `DropdownFieldBlocBuilder`.

# 0.10.5
* Fixed `decoration.hintText` property of `DropdownFieldBlocBuilder`

# 0.10.4
* Fixed `DropdownFieldBlocBuilder` focus [28](https://github.com/GiancarloCode/form_bloc/issues/28).

# 0.10.3

* Added `SwitchFieldBlocBuilder`.
* Added/Fixed properties of `TextFieldBlocBuilder`:
    * readOnly
    * buildCounter
    * dragStartBehavior
    * enableInteractiveSelection
    * enableSuggestions
    * expands
    * scrollController
    * strutStyle
    * showCursor
    * scrollPhysics
    * textAlignVertical
    * toolbarOptions
* Added `controlAffinity` property to `CheckboxFieldBlocBuilder`.
* Documentation Updates.

# 0.10.2

* Fixed `minLines` property of `TextFieldBlocBuilder`.

# 0.10.1

* Fixed `SuffixButton.clearText` of `TextFieldBlocBuilder`.

# 0.10.0
## Breaking changes

* Updated to `form_bloc: ^0.10.0`.
* Documentation Updates.
* Added more examples.

# 0.7.0
* Added `defaultErrorBuilder` property to `FieldBlocBuilder`.
* Updated to `form_bloc: ^0.8.0`.
* Updated to `flutter_bloc: ^3.2.0`.
* Added `onDeleting`, `onDeleteFailed`, `onDeleteSuccessful` callbacks to `FormBlocListener`.
* Added more examples.

# 0.6.1-beta-1
* Added `defaultErrorBuilder` property to `FieldBlocBuilder`.

# 0.6.0
* Updated to `bloc: ^3.0.0`.
* Updated to `flutter_bloc: ^3.1.0`.
* Updated to `form_bloc: ^0.7.0`.
* Fixed bug in `onTap` method of `TextFieldBlocBuilder`.
* Documentation Updates.

# 0.5.0
* Updated to `bloc: ^1.0.0`.
* Updated to `flutter_bloc: ^1.0.0`.
* Updated to `form_bloc: ^0.6.0`.
* Documentation Updates.

# 0.4.4
* Dependencies Updates.
* Fixed bug in suggestions of `TextFieldBlocBuilder`.
* Added the next properties to `TextFieldBlocBuilder`.
  * hideOnLoadingSuggestions = false,
  * hideOnEmptySuggestions = false,
  * hideOnSuggestionsError = false,
  * loadingSuggestionsBuilder,
  * suggestionsNotFoundBuilder,
  * suggestionsErrorBuilder,
  * keepSuggestionsOnLoading = false,
  * showSuggestionsWhenIsEmpty = true,

# 0.4.3
* Updated to `form_bloc: ^0.5.2`.
* Documentation Updates.

# 0.4.2
* Updated to `form_bloc: ^0.5.1`.

# 0.4.1+1
* Documentation Updates.

# 0.4.1
* `FormBlocListener` improved.

# 0.4.0+1
* Documentation Updates.

# 0.4.0
* Documentation Updates.
* Updated to `form_bloc: ^0.5.0`.
* Added more examples.

# 0.3.1
* Documentation Updates.

# 0.3.0
* Documentation Updates.
* Updated to `form_bloc: ^0.4.1`.
* Added `CheckBoxGroupFieldBlocBuilder`.
* Added more examples.

# 0.2.1

* Updated to `form_bloc: ^0.3.1`.

# 0.2.0

* Dependencies and Documentation Updates.
* Added `RadioButtonGroupFieldBlocBuilder` ([#1](https://github.com/GiancarloCode/form_bloc/issues/1)).
* Add Form with progress example.

# 0.1.0

Initial Version of the library.
