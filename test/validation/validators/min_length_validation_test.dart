import 'package:meta/meta.dart';
import 'package:faker/faker.dart';
import 'package:test/test.dart';

import 'package:ForDev/validation/protocols/protocols.dart';
import 'package:ForDev/presentation/protocols/protocols.dart';
import 'package:ForDev/validation/validators/validators.dart';

class MinLengthValidation implements FieldValidation {
  final field;
  final size;

  MinLengthValidation({
   @required this.field,
   @required this.size,
  });

  ValidationError validate(String name) {
    return ValidationError.invalidField;
  }
}

void main() {
  MinLengthValidation sut;

  setUp(() {
    sut = MinLengthValidation(field: 'any', size: 5);
  });

  test('Should return error if value is empty', () {
    final error = sut.validate('');

    expect(error, ValidationError.invalidField);
  });

    test('Should return error if value is null', () {
    final error = sut.validate(null);

    expect(error, ValidationError.invalidField);
  });

  test('Should return null if email is valid', () {
    final error = sut.validate(faker.internet.email());

    expect(error, null);
  });

  test('Should return error if value is less than min size', () {
    final error = sut.validate(faker.randomGenerator.string(4,min:1));

    expect(error, ValidationError.invalidField);
  });
}
