import 'package:ForDev/main/builders/validation_builder.dart';

import '../../../../validation/protocols/protocols.dart';
import '../../../../validation/validators/validators.dart';

import '../../../builders/builders.dart';

ValidationComposite makeSignUpValidationComposite() {
  return ValidationComposite(makeSignUpValidations());
}

List<FieldValidation> makeSignUpValidations() {
  return [
    ...ValidationBuilder.field('name').required().min(3).build(),
    ...ValidationBuilder.field('email').required().email().build(),
    ...ValidationBuilder.field('password').required().min(3).build(),
    ...ValidationBuilder.field('passwordConfirmation').required().min(3).sameAs('password').build()
  ];
}
