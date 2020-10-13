import 'package:faker/faker.dart';

import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'package:ForDev/domain/usecases/usecases.dart';
import 'package:ForDev/domain/helpers/domain_error.dart';
import 'package:ForDev/domain/entities/entities.dart';

import 'package:ForDev/ui/helpers/errors/errors.dart';

import 'package:ForDev/presentation/presenters/presenters.dart';
import 'package:ForDev/presentation/protocols/validation.dart';

class MockValidation extends Mock implements Validation {}

class MockAddAccount extends Mock implements AddAccount {}

class MockSaveCurrentAccount extends Mock implements SaveCurrentAccount {}

void main() {
  GetxSignUpPresenter sut;
  Validation validation;
  AddAccount addAccount;
  SaveCurrentAccount saveCurrentAccount;
  String email;
  String name;
  String password;
  String token;

  PostExpectation mockValidatationCall(String field) {
    return when(validation.validate(
        field: field == null ? anyNamed('field') : field,
        input: anyNamed('input')));
  }

  PostExpectation mockAddAccountCall() {
    return when(addAccount.add(any));
  }

  PostExpectation mockSaveCurrentAccountCall() {
    return when(saveCurrentAccount.save(any));
  }

  void mockValidation({String field, ValidationError value}) {
    mockValidatationCall(field).thenReturn(value);
  }

  void mockAddAccount() {
    mockAddAccountCall().thenAnswer((_) async => AccountEntity(token));
  }

  void mockAddAccountError(DomainError error) {
    mockAddAccountCall().thenThrow(error);
  }

  void mockSaveCurrentAccountError() {
    mockSaveCurrentAccountCall().thenThrow(DomainError.unexpected);
  }

  setUp(() {
    validation = MockValidation();
    addAccount = MockAddAccount();
    saveCurrentAccount = MockSaveCurrentAccount();
    sut = GetxSignUpPresenter(
      validation: validation,
      addAccount: addAccount,
      saveCurrentAccount: saveCurrentAccount,
    );

    name = 'Lucas Luz';
    email = faker.internet.email();
    password = faker.internet.password();
    token = faker.guid.guid();
    mockAddAccount();
  });

  test('Should call Validation with correct email', () {
    final formData = {
      'name': null,
      'email': email,
      'password': null,
      'passwordConfirmation': null
    };
    sut.validateEmail(email);

    verify(validation.validate(field: 'email', input: formData)).called(1);
  });

  test('Should emit invalidFieldError if email is invalid', () {
    mockValidation(value: ValidationError.invalidField);

    sut.emailErrorStream
        .listen(expectAsync1((error) => expect(error, UiError.invalidField)));
    sut.isFormValidStream
        .listen(expectAsync1((isValid) => expect(isValid, false)));

    sut.validateEmail(email);
    sut.validateEmail(email);
  });

  test('Should emit requiredFieldError if email is empty', () {
    mockValidation(value: ValidationError.requiredField);

    sut.emailErrorStream
        .listen(expectAsync1((error) => expect(error, UiError.requiredField)));
    sut.isFormValidStream
        .listen(expectAsync1((isValid) => expect(isValid, false)));

    sut.validateEmail(email);
    sut.validateEmail(email);
  });

  test('Should emit null if emails validation succeeds', () {
    sut.emailErrorStream.listen(expectAsync1((error) => expect(error, null)));
    sut.isFormValidStream
        .listen(expectAsync1((isValid) => expect(isValid, false)));

    sut.validateEmail(email);
    sut.validateEmail(email);
  });

  test('Should call Validation with correct name', () {
    final formData = {
      'name': name,
      'email': null,
      'password': null,
      'passwordConfirmation': null
    };
    sut.validateName(name);

    verify(validation.validate(field: 'name', input: formData)).called(1);
  });

  test('Should emit invalidFieldError if name is invalid', () {
    mockValidation(value: ValidationError.invalidField);

    sut.nameErrorStream
        .listen(expectAsync1((error) => expect(error, UiError.invalidField)));
    sut.isFormValidStream
        .listen(expectAsync1((isValid) => expect(isValid, false)));

    sut.validateName(name);
    sut.validateName(name);
  });

  test('Should emit requiredFieldError if name is empty', () {
    mockValidation(value: ValidationError.requiredField);

    sut.nameErrorStream
        .listen(expectAsync1((error) => expect(error, UiError.requiredField)));
    sut.isFormValidStream
        .listen(expectAsync1((isValid) => expect(isValid, false)));

    sut.validateName(name);
    sut.validateName(name);
  });

  test('Should emit null if name validation succeeds', () {
    sut.nameErrorStream.listen(expectAsync1((error) => expect(error, null)));
    sut.isFormValidStream
        .listen(expectAsync1((isValid) => expect(isValid, false)));

    sut.validateName(name);
    sut.validateName(name);
  });

  test('Should call Validation with correct password', () {
    final formData = {
      'name': null,
      'email': null,
      'password': password,
      'passwordConfirmation': null
    };
    sut.validatePassword(password);

    verify(validation.validate(field: 'password', input: formData)).called(1);
  });

  test('Should emit invalidFieldError if password is invalid', () {
    mockValidation(value: ValidationError.invalidField);

    sut.passwordErrorStream
        .listen(expectAsync1((error) => expect(error, UiError.invalidField)));
    sut.isFormValidStream
        .listen(expectAsync1((isValid) => expect(isValid, false)));

    sut.validatePassword(password);
    sut.validatePassword(password);
  });

  test('Should emit requiredFieldError if password is empty', () {
    mockValidation(value: ValidationError.requiredField);

    sut.passwordErrorStream
        .listen(expectAsync1((error) => expect(error, UiError.requiredField)));
    sut.isFormValidStream
        .listen(expectAsync1((isValid) => expect(isValid, false)));

    sut.validatePassword(password);
    sut.validatePassword(password);
  });

  test('Should emit null if password validation succeeds', () {
    sut.passwordErrorStream
        .listen(expectAsync1((error) => expect(error, null)));
    sut.isFormValidStream
        .listen(expectAsync1((isValid) => expect(isValid, false)));

    sut.validatePassword(password);
    sut.validatePassword(password);
  });

  test('Should call Validation with correct passwordConfirmation', () {
    final formData = {
      'name': null,
      'email': null,
      'password': null,
      'passwordConfirmation': password
    };
    sut.validatePasswordConfirmation(password);

    verify(validation.validate(field: 'passwordConfirmation', input: formData))
        .called(1);
  });

  test('Should emit invalidFieldError if passwordConfirmation is invalid', () {
    mockValidation(value: ValidationError.invalidField);

    sut.passwordConfirmationErrorStream
        .listen(expectAsync1((error) => expect(error, UiError.invalidField)));
    sut.isFormValidStream
        .listen(expectAsync1((isValid) => expect(isValid, false)));

    sut.validatePasswordConfirmation(password);
    sut.validatePasswordConfirmation(password);
  });

  test('Should emit requiredFieldError if passwordConfirmation is empty', () {
    mockValidation(value: ValidationError.requiredField);

    sut.passwordConfirmationErrorStream
        .listen(expectAsync1((error) => expect(error, UiError.requiredField)));
    sut.isFormValidStream
        .listen(expectAsync1((isValid) => expect(isValid, false)));

    sut.validatePasswordConfirmation(password);
    sut.validatePasswordConfirmation(password);
  });

  test('Should emit null if passwordConfirmation validation succeeds', () {
    sut.passwordConfirmationErrorStream
        .listen(expectAsync1((error) => expect(error, null)));
    sut.isFormValidStream
        .listen(expectAsync1((isValid) => expect(isValid, false)));

    sut.validatePasswordConfirmation(password);
    sut.validatePasswordConfirmation(password);
  });

  test('Should enable button if all fields are valid', () async {
    expectLater(sut.isFormValidStream, emitsInOrder([false, true]));

    sut.validateEmail(email);
    await Future.delayed(Duration.zero);
    sut.validateName(name);
    await Future.delayed(Duration.zero);
    sut.validatePasswordConfirmation(password);
    await Future.delayed(Duration.zero);
    sut.validatePassword(password);
    await Future.delayed(Duration.zero);
  });

  test('Should call AddAccount with correct values', () async {
    sut.validateEmail(email);
    sut.validateName(name);
    sut.validatePassword(password);
    sut.validatePasswordConfirmation(password);

    await sut.signUp();

    verify(addAccount.add(AddAccountParams(
      email: email,
      name: name,
      passwordConfirmation: password,
      password: password,
    ))).called(1);
  });

  test('Should call SaveCurrentAccount with correct value', () async {
    sut.validateEmail(email);
    sut.validateName(name);
    sut.validatePassword(password);
    sut.validatePasswordConfirmation(password);

    await sut.signUp();

    verify(saveCurrentAccount.save(AccountEntity(token))).called(1);
  });

  test('Should emit UnexpectedError if SaveCurrentAccount fails', () async {
    mockSaveCurrentAccountError();
    sut.validateEmail(email);
    sut.validateName(name);
    sut.validatePassword(password);
    sut.validatePasswordConfirmation(password);

    expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
    sut.mainErrorStream
        .listen(expectAsync1((error) => expect(error, UiError.unexpected)));

    await sut.signUp();
  });

  test('Should emit correct events on AddAccount success', () async {
    sut.validateEmail(email);
    sut.validateName(name);
    sut.validatePassword(password);
    sut.validatePasswordConfirmation(password);

    expectLater(sut.isLoadingStream, emits(true));

    await sut.signUp();
  });

  test('Should change page on success', () async {
    sut.validateEmail(email);
    sut.validateName(name);
    sut.validatePassword(password);
    sut.validatePasswordConfirmation(password);

    sut.navigateToStream
        .listen(expectAsync1((page) => expect(page, '/surveys')));

    await sut.signUp();
  });

  test('Should emit correct events on EmailInUseError', () async {
    mockAddAccountError(DomainError.emailInUse);
    sut.validateEmail(email);
    sut.validateName(name);
    sut.validatePassword(password);
    sut.validatePasswordConfirmation(password);

    expectLater(sut.isLoadingStream, emitsInOrder([true, false]));

    sut.mainErrorStream
        .listen(expectAsync1((error) => expect(error, UiError.emailInUse)));

    await sut.signUp();
  });

  test('Should emit correct events on UnexpectedError', () async {
    mockAddAccountError(DomainError.unexpected);
    sut.validateEmail(email);
    sut.validatePassword(password);

    expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
    sut.mainErrorStream
        .listen(expectAsync1((error) => expect(error, UiError.unexpected)));

    await sut.signUp();
  });

  test('Should go to LoginPage on link click', () async {
    sut.navigateToStream.listen(expectAsync1((page) => expect(page, '/login')));

    sut.goToLogin();
  });
}
