import 'package:faker/faker.dart';
import 'package:test/test.dart';

import 'package:ForDev/presentation/protocols/protocols.dart';
import 'package:ForDev/validation/validators/validators.dart';

void main() {
  MinLengthValidation sut;

  setUp(() {
    sut = MinLengthValidation(field: 'any', size: 5);
  });

  test('Should return error if value is empty', () {
    final formData = {
      'any' : ''
    };
    final error = sut.validate(formData);

    expect(error, ValidationError.invalidField);
  });

  test('Should return error if value is null', () {

     final formData = {
      'any' : null
    };

    final error = sut.validate(formData);

    expect(error, ValidationError.invalidField);
  });

  test('Should return error if value is less than min size', () {
    final formData = {
      'any' : 'abc'
    };
    final error = sut.validate(formData);

    expect(error, ValidationError.invalidField);
  });

  test('Should return null if value is equal than min size', () {
     final formData = {
      'any' : 'abcde'
    };
    final error = sut.validate(formData);

    expect(error, null);
  });

  test('Should return null if value is bigger than min size', () {
     final formData = {
      'any' : 'abcdefg'
    };
    final error = sut.validate(formData);

    expect(error, null);
  });
}
