import 'package:flutter/widgets.dart';

/// {@macro flutter_form_bloc.FieldBlocBuilder.errorBuilder}
typedef FieldBlocErrorBuilder = String? Function(
    BuildContext context, Object error);

typedef BlocValueBuilder<S, V> = V Function(BuildContext context, S state);
