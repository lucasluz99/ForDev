import 'package:faker/faker.dart';
import 'package:test/test.dart';

import 'package:ForDev/validation/validators/email_validation.dart';

void main() {
  EmailValidation sut;

  setUp(() {
    sut = EmailValidation('any');
  });

  test('Should return null if email is empty', () {
    final error = sut.validate('');

    expect(error, null);
  });

  test('Should return null if email is valid', () {
    final error = sut.validate(faker.internet.email());

    expect(error, null);
  });

  test('Should return error if email is invalid', () {
    final error = sut.validate('12@');

    expect(error, 'Campo inválido');
  });
}
