import 'package:faker/faker.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'package:ForDev/presentation/presenters/stream_login_presenter.dart';
import 'package:ForDev/presentation/protocols/validation.dart';

class MockValidation extends Mock implements Validation {}

void main() {
  Validation validation;
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

  setUp(() {
    validation = MockValidation();
    sut = StreamLoginPresenter(validation: validation);
    email = faker.internet.email();
    password = faker.internet.password();
    mockValidation();
  });

  test('Should call Validation with correct email', () {
    sut.validateEmail(email);

    verify(validation.validate(field: 'email', value: email)).called(1);
  });

  test('Should emit email error if validation fails', () {
    mockValidation(value: 'error');

    sut.emailErrorStream.listen(expectAsync1((error) => expect(error,'error')));
    sut.isFormValidStream.listen(expectAsync1((isValid) => expect(isValid,false)));

    sut.validateEmail(email);
    sut.validateEmail(email);
  });

    test('Should emit null if emails validation succeeds', () {
  
    sut.emailErrorStream.listen(expectAsync1((error) => expect(error,null)));
    sut.isFormValidStream.listen(expectAsync1((isValid) => expect(isValid,false)));

    sut.validateEmail(email);
    sut.validateEmail(email);
  });



  test('Should call Validation with correct password', () {
    sut.validatePassword(password);

    verify(validation.validate(field: 'password', value: password)).called(1);
  });



  test('Should emit password error if validation fails', () {
    mockValidation(value: 'error');

    sut.passwordErrorStream.listen(expectAsync1((error) => expect(error,'error')));
    sut.isFormValidStream.listen(expectAsync1((isValid) => expect(isValid,false)));

    sut.validatePassword(password);
    sut.validatePassword(password);
  });


    test('Should emit null if passwords validation succeeds', () {
  
    sut.passwordErrorStream.listen(expectAsync1((error) => expect(error,null)));
    sut.isFormValidStream.listen(expectAsync1((isValid) => expect(isValid,false)));

    sut.validatePassword(password);
    sut.validatePassword(password);
  });

}
