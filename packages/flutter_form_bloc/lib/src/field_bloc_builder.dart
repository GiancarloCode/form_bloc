import 'package:flutter/widgets.dart';
import 'package:flutter_form_bloc/src/utils/utils.dart';
import 'package:form_bloc/form_bloc.dart';

import 'package:flutter_form_bloc/generated/l10n.dart';

class FieldBlocBuilder {
  static FieldBlocErrorBuilder defaultErrorBuilder = (BuildContext context, String error) {
    switch (error) {
      case FieldBlocValidatorsErrors.requiredInputFieldBloc:
        return FormBlocLocalizations.of(context).requiredInputFieldBloc;
      case FieldBlocValidatorsErrors.requiredBooleanFieldBloc:
        return FormBlocLocalizations.of(context).requiredBooleanFieldBloc;
      case FieldBlocValidatorsErrors.requiredTextFieldBloc:
        return FormBlocLocalizations.of(context).requiredTextFieldBloc;
      case FieldBlocValidatorsErrors.requiredSelectFieldBloc:
        return FormBlocLocalizations.of(context).requiredSelectFieldBloc;
      case FieldBlocValidatorsErrors.requiredMultiSelectFieldBloc:
        return FormBlocLocalizations.of(context).requiredMultiSelectFieldBloc;
      case FieldBlocValidatorsErrors.email:
        return FormBlocLocalizations.of(context).email;
      case FieldBlocValidatorsErrors.passwordMin6Chars:
        return FormBlocLocalizations.of(context).passwordMin6Chars;
      case FieldBlocValidatorsErrors.confirmPassword:
        return FormBlocLocalizations.of(context).confirmPassword;
      default:
        return error;
    }
  };
}
