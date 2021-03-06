import 'package:get/get.dart';

import '../../domain/helpers/domain_error.dart';

import '../../ui/pages/pages.dart';
import '../../ui/helpers/errors/errors.dart';

import '../../domain/usecases/usecases.dart';

import '../protocols/validation.dart';

class GetxSignUpPresenter extends GetxController implements SignUpPresenter {
  final Validation validation;
  final AddAccount addAccount;
  final SaveCurrentAccount saveCurrentAccount;

  String _email;
  String _name;
  String _password;
  String _passwordConfirmation;

  var _isLoading = false.obs;
  var _emailError = Rx<UiError>();
  var _nameError = Rx<UiError>();
  var _passwordError = Rx<UiError>();
  var _navigateTo = Rx<String>();
  var _passwordConfirmationError = Rx<UiError>();
  var _mainError = Rx<UiError>();
  var _isFormValid = false.obs;

  Stream<UiError> get emailErrorStream => _emailError.stream;
  Stream<UiError> get nameErrorStream => _nameError.stream;
  Stream<UiError> get passwordErrorStream => _passwordError.stream;
  Stream<UiError> get mainErrorStream => _mainError.stream;
  Stream<UiError> get passwordConfirmationErrorStream =>
      _passwordConfirmationError.stream;
  Stream<String> get navigateToStream => _navigateTo.stream;
  Stream<bool> get isFormValidStream => _isFormValid.stream;
  Stream<bool> get isLoadingStream => _isLoading.stream;

  GetxSignUpPresenter({
    this.validation,
    this.addAccount,
    this.saveCurrentAccount,
  });

  void validateEmail(String email) {
    _email = email;
    _emailError.value = _validateField('email');
    _validateForm();
  }

  void validateName(String name) {
    _name = name;
    _nameError.value = _validateField('name');
    _validateForm();
  }

  void validatePassword(String password) {
    _password = password;
    _passwordError.value = _validateField('password');
    _validateForm();
  }

  void validatePasswordConfirmation(String password) {
    _passwordConfirmation = password;
    _passwordConfirmationError.value = _validateField('passwordConfirmation');
    _validateForm();
  }

  void _validateForm() {
    _isFormValid.value = _emailError.value == null &&
        _nameError.value == null &&
        _passwordError.value == null &&
        _passwordConfirmationError.value == null &&
        _email != null &&
        _name != null &&
        _password != null &&
        _passwordConfirmation != null;
  }

  UiError _validateField(String field) {
    final formData = {
      'email': _email,
      'name': _name,
      'password': _password,
      'passwordConfirmation': _passwordConfirmation
    };
    final error = validation.validate(field: field, input: formData);
    switch (error) {
      case ValidationError.invalidField:
        return UiError.invalidField;
      case ValidationError.requiredField:
        return UiError.requiredField;
      default:
        return null;
    }
  }

  Future<void> signUp() async {
    try {
      _isLoading.value = true;
      final account = await addAccount.add(AddAccountParams(
        email: _email,
        name: _name,
        password: _password,
        passwordConfirmation: _passwordConfirmation,
      ));
      await saveCurrentAccount.save(account);
      _navigateTo.value = '/surveys';
    } on DomainError catch (error) {
      switch (error) {
        case DomainError.emailInUse:
          _mainError.value = UiError.emailInUse;
          break;
        default:
          _mainError.value = UiError.unexpected;
      }
      _isLoading.value = false;
    }
  }

  void goToLogin() {
    _navigateTo.value = '/login';
  }

  void dispose() {}
}
