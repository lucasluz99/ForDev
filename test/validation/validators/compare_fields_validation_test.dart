import 'package:test/test.dart';

import 'package:ForDev/presentation/protocols/protocols.dart';
import 'package:ForDev/validation/validators/validators.dart';

void main() {
  CompareFieldsValidation sut;

  setUp(() {
    sut = CompareFieldsValidation(
      field: 'any',
      valueToCompare: 'any',
    );
  });

  test('Should return error if values are differents', () {
    final error = sut.validate('wrong_value');

    expect(error, ValidationError.invalidField);
  });

  test('Should return null if values are equal', () {
    final error = sut.validate('any');

    expect(error, null);
  });
}
