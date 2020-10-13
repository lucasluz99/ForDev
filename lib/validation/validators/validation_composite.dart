import 'package:flutter/foundation.dart';

import '../../presentation/protocols/validation.dart';
import '../protocols/protocols.dart';


class ValidationComposite implements Validation {
  final List<FieldValidation> validations;

  ValidationComposite(this.validations);

  ValidationError validate({@required String field, @required Map input}) {
    ValidationError error;
    final filterValidations =
        validations.where((e) => e.field == field).toList();

    for (final validation in filterValidations) {
      error = validation.validate(input);
      if (error != null) {
        return error;
      }
    }
    return error;
  }
}