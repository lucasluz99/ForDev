import 'package:test/test.dart';
import 'package:ForDev/presentation/protocols/protocols.dart';
import 'package:ForDev/validation/validators/validators.dart';

void main() {
  RequiredFieldValidation sut;

  setUp(() {
    sut = RequiredFieldValidation('any');
  });
  test('Should return null if value is not empty', () {
     final formData = {
      'any' : 'abcde'
    };
    final error = sut.validate(formData);

    expect(error, null);
  });

  test('Should return error if value is  empty', () {
     final formData = {
      'any' : ''
    };
    final error = sut.validate(formData);

    expect(error, ValidationError.requiredField);
  });

  test('Should return error if value is null', () {
     final formData = {
      'any' : null
    };
    final error = sut.validate(formData);

    expect(error, ValidationError.requiredField);
  });
}
