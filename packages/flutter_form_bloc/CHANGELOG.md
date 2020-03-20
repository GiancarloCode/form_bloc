# 0.10.7
* Fixed bug in `DropdownFieldBlocBuilder` and `TextFieldBlocBuilder` on Flutter Web.

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
