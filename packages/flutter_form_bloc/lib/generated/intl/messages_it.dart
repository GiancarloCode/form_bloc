// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a it locale. All the
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
  String get localeName => 'it';

  final messages = _notInlinedMessages(_notInlinedMessages);
  static _notInlinedMessages(_) => <String, Function> {
    "confirmPassword" : MessageLookupByLibrary.simpleMessage("Deve essere uguale alla password."),
    "email" : MessageLookupByLibrary.simpleMessage("L\'indirizzo email non è mal formattato."),
    "passwordMin6Chars" : MessageLookupByLibrary.simpleMessage("La password deve contenere almeno 6 caratteri."),
    "requiredBooleanFieldBloc" : MessageLookupByLibrary.simpleMessage("Questo campo è richiesto."),
    "requiredInputFieldBloc" : MessageLookupByLibrary.simpleMessage("Questo campo è richiesto."),
    "requiredMultiSelectFieldBloc" : MessageLookupByLibrary.simpleMessage("Seleziona un\'opzione."),
    "requiredSelectFieldBloc" : MessageLookupByLibrary.simpleMessage("Seleziona un\'opzione."),
    "requiredTextFieldBloc" : MessageLookupByLibrary.simpleMessage("Questo campo è richiesto.")
  };
}
