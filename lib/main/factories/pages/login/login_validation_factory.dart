import '../../../../validation/validators/validators.dart';

ValidationComposite makeValidationComposite() {
  return ValidationComposite([
    RequiredFieldValidation('email'),
    EmailValidation('email'),
    RequiredFieldValidation('password')
  ]);
}
