import 'package:test/test.dart';

import 'package:ForDev/presentation/protocols/protocols.dart';
import 'package:ForDev/validation/validators/validators.dart';

void main() {
  CompareFieldsValidation sut;

  setUp(() {
    sut = CompareFieldsValidation(
      field: 'any_field',
      fieldToCompare: 'other_field',
    );
  });
  test('Should return null on invalid cases', () {
    expect(sut.validate({
      'any_field': 'any',
    }), null);

    expect(sut.validate({'other_field': 'other'}), null);

    expect(sut.validate({}), null);
  });

  test('Should return error if values are differents', () {
    final formData = {'any_field': 'any', 'other_field': 'other'};

    final error = sut.validate(formData);

    expect(error, ValidationError.invalidField);
  });

  test('Should return null if values are equal', () {
    final formData = {'any_field': 'any', 'other_field': 'any'};
    final error = sut.validate(formData);

    expect(error, null);
  });
}