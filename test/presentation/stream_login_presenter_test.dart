import 'package:faker/faker.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'package:ForDev/domain/helpers/domain_error.dart';
import 'package:ForDev/domain/entities/entities.dart';
import 'package:ForDev/domain/usecases/authentication.dart';

import 'package:ForDev/presentation/presenters/stream_login_presenter.dart';
import 'package:ForDev/presentation/protocols/validation.dart';

class MockValidation extends Mock implements Validation {}

class MockAuthentication extends Mock implements Authentication {}

void main() {
  Validation validation;
  Authentication authentication;
  StreamLoginPresenter sut;
  String email;
  String password;

  PostExpectation mockValidatationCall(String field) {
    return when(validation.validate(
        field: field == null ? anyNamed('field') : field,
        value: anyNamed('value')));
  }

  void mockValidation({String field, String value}) {
    mockValidatationCall(field).thenReturn(value);
  }

  PostExpectation mockAuthenticationCall() {
    return when(authentication.auth(any));
  }

  void mockAuthentication() {
    mockAuthenticationCall()
        .thenAnswer((_) async => AccountEntity(faker.guid.guid()));
  }

  void mockAuthenticationError(DomainError error) {
    mockAuthenticationCall().thenThrow(error);
  }

  setUp(() {
    validation = MockValidation();
    authentication = MockAuthentication();
    sut = StreamLoginPresenter(
        validation: validation, authentication: authentication);
    email = faker.internet.email();
    password = faker.internet.password();
    mockValidation();
    mockAuthentication();
  });

  test('Should call Validation with correct email', () {
    sut.validateEmail(email);

    verify(validation.validate(field: 'email', value: email)).called(1);
  });

  test('Should emit email error if validation fails', () {
    mockValidation(value: 'error');

    sut.emailErrorStream
        .listen(expectAsync1((error) => expect(error, 'error')));
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

  test('Should call Validation with correct password', () {
    sut.validatePassword(password);

    verify(validation.validate(field: 'password', value: password)).called(1);
  });

  test('Should emit password error if validation fails', () {
    mockValidation(value: 'error');

    sut.passwordErrorStream
        .listen(expectAsync1((error) => expect(error, 'error')));
    sut.isFormValidStream
        .listen(expectAsync1((isValid) => expect(isValid, false)));

    sut.validatePassword(password);
    sut.validatePassword(password);
  });

  test('Should emit null if passwords validation succeeds', () {
    sut.passwordErrorStream
        .listen(expectAsync1((error) => expect(error, null)));
    sut.isFormValidStream
        .listen(expectAsync1((isValid) => expect(isValid, false)));

    sut.validatePassword(password);
    sut.validatePassword(password);
  });

  test('Should emit null if passwords validation succeeds', () {
    mockValidation(field: 'email', value: 'error');
    sut.emailErrorStream
        .listen(expectAsync1((error) => expect(error, 'error')));
    sut.passwordErrorStream
        .listen(expectAsync1((error) => expect(error, null)));
    sut.isFormValidStream
        .listen(expectAsync1((isValid) => expect(isValid, false)));

    sut.validateEmail(email);
    sut.validatePassword(password);
  });

  test('Should emit success if validation succeeds', () async {
    sut.emailErrorStream.listen(expectAsync1((error) => expect(error, null)));
    sut.passwordErrorStream
        .listen(expectAsync1((error) => expect(error, null)));

    expectLater(sut.isFormValidStream, emitsInOrder([false, true]));
    sut.validateEmail(email);
    await Future.delayed(Duration.zero);
    sut.validatePassword(password);
  });

  test('Should call Authentication with correct values', () async {
    sut.validateEmail(email);
    sut.validatePassword(password);

    await sut.auth();

    verify(authentication
            .auth(AuthenticationParams(email: email, secret: password)))
        .called(1);
  });

  test('Should emit correct events on Authentication success', () async {
    sut.validateEmail(email);
    sut.validatePassword(password);

    expectLater(sut.isLoadingStream, emitsInOrder([true, false]));

    await sut.auth();
  });

  test('Should emit correct events on InvalidCredentialsError', () async {
    mockAuthenticationError(DomainError.invalidCredentials);
    sut.validateEmail(email);
    sut.validatePassword(password);

    expectLater(sut.isLoadingStream, emits(false));

    sut.mainErrorStream.listen(
        expectAsync1((error) => expect(error, 'Credenciais inválidas')));

    await sut.auth();
  });

  test('Should emit correct events on UnexpectedError', () async {
    mockAuthenticationError(DomainError.unexpected);
    sut.validateEmail(email);
    sut.validatePassword(password);

    expectLater(sut.isLoadingStream, emits(false));

    sut.mainErrorStream.listen(
        expectAsync1((error) => expect(error, 'Ocorreu um erro inesperado')));

    await sut.auth();
  });

  test('Should not emit after dispose', () async {
    expectLater(sut.emailErrorStream, neverEmits(null));
    
     sut.dispose();  

    sut.validateEmail(email);

     

  });
}
