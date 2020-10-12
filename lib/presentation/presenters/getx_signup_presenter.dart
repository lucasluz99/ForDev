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
  var _isFormValid = false.obs;

  Stream<UiError> get emailErrorStream => _emailError.stream;
  Stream<UiError> get nameErrorStream => _nameError.stream;
  Stream<bool> get isFormValidStream => _isFormValid.stream;

  GetxSignUpPresenter({
    this.validation,
  });

  void validateEmail(String email) {
    _emailError.value = _validateField(field: 'email', value: email);
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
