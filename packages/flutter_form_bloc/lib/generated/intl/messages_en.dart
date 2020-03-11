// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a en locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'en';

  final messages = _notInlinedMessages(_notInlinedMessages);
  static _notInlinedMessages(_) => <String, Function> {
    "confirmPassword" : MessageLookupByLibrary.simpleMessage("Must be equal to password."),
    "email" : MessageLookupByLibrary.simpleMessage("The email address is badly formatted."),
    "passwordMin6Chars" : MessageLookupByLibrary.simpleMessage("The password must contain at least 6 characters."),
    "requiredBooleanFieldBloc" : MessageLookupByLibrary.simpleMessage("This field is required."),
    "requiredInputFieldBloc" : MessageLookupByLibrary.simpleMessage("This field is required."),
    "requiredMultiSelectFieldBloc" : MessageLookupByLibrary.simpleMessage("Please select an option."),
    "requiredSelectFieldBloc" : MessageLookupByLibrary.simpleMessage("Please select an option."),
    "requiredTextFieldBloc" : MessageLookupByLibrary.simpleMessage("This field is required.")
  };
}
