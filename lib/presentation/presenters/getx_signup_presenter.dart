import 'package:get/get.dart';

import '../../domain/helpers/domain_error.dart';
import '../../ui/helpers/errors/errors.dart';

import '../../ui/pages/login/login_presenter.dart';

import '../../domain/usecases/usecases.dart';

import '../protocols/validation.dart';

class GetxSignUpPresenter extends GetxController {
  final Validation validation;

  var _emailError = Rx<UiError>();
  var _nameError = Rx<UiError>();
  var _passwordError = Rx<UiError>();
  var _passwordConfirmationError = Rx<UiError>();
  var _isFormValid = false.obs;

  Stream<UiError> get emailErrorStream => _emailError.stream;
  Stream<UiError> get nameErrorStream => _nameError.stream;
  Stream<UiError> get passwordErrorStream => _passwordError.stream;
  Stream<UiError> get passwordConfirmationErrorStream => _passwordConfirmationError.stream;
  Stream<bool> get isFormValidStream => _isFormValid.stream;

  GetxSignUpPresenter({
    this.validation,
  });

  void validateEmail(String email) {
    _emailError.value = _validateField(field: 'email', value: email);
    _validateForm();
  }

  void validateName(String name) {
    _nameError.value = _validateField(field: 'name', value: name);
    _validateForm();
  }

  void validatePassword(String password) {
    _passwordError.value = _validateField(field: 'password', value: password);
    _validateForm();
  }
  void validatePasswordConfirmation(String password) {
      _passwordConfirmationError.value = _validateField(field: 'passwordConfirmation', value: password);
    _validateForm();
  }
  
  void _validateForm() {
    _isFormValid.value = false;
  }

  UiError _validateField({String field, String value}) {
    final error = validation.validate(field: field, value: value);
    switch (error) {
      case ValidationError.invalidField:
        return UiError.invalidField;
      case ValidationError.requiredField:
        return UiError.requiredField;
      default:
        return null;
    }
  }

  void dispose() {}
}
