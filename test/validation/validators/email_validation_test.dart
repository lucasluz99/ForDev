import 'package:ForDev/presentation/protocols/protocols.dart';
import 'package:faker/faker.dart';
import 'package:test/test.dart';

import 'package:ForDev/validation/validators/validators.dart';

void main() {
  EmailValidation sut;

  setUp(() {
    sut = EmailValidation('email');
  });

  test('Should return null if email is empty', () {
    final formData = {
      'email': ''
    };
    
    final error = sut.validate(formData);

    expect(error, null);
  });

  test('Should return null if email is valid', () {
     final formData = {
      'email': 'lucas@gmail.com'
    };
    final error = sut.validate(formData);

    expect(error, null);
  });

  test('Should return error if email is invalid', () {
     final formData = {
      'email': 'lu@12'
    };
    final error = sut.validate(formData);

    expect(error, ValidationError.invalidField);
  });
}
