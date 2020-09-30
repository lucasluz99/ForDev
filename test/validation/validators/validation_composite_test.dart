import 'package:ForDev/presentation/protocols/validation.dart';
import 'package:ForDev/validation/protocols/field_validation.dart';
import 'package:flutter/foundation.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

class ValidationComposite implements Validation {
  final List<FieldValidation> validations;

  ValidationComposite(this.validations);

  String validate({@required String field, @required String value}) {
    return null;
  }
}

class MockFieldValidation extends Mock implements FieldValidation {}

void main() {
  ValidationComposite sut;
  MockFieldValidation validation1;
  MockFieldValidation validation2;
  MockFieldValidation validation3;

  void mockValidation1(String error) {
    when(validation1.validate(any)).thenReturn(error);
  }

  void mockValidation2(String error) {
    when(validation2.validate(any)).thenReturn(error);
  }

  setUp(() {
    validation1 = MockFieldValidation();
    when(validation1.field).thenReturn('any');
    mockValidation1(null);

    validation2 = MockFieldValidation();
    when(validation2.field).thenReturn('any');
    mockValidation2(null);

    validation3 = MockFieldValidation();
    when(validation3.field).thenReturn('other');
    mockValidation2(null);

    sut = ValidationComposite([validation1, validation2,validation3]);
  });
  test('Should return null if all validations returns null or empty', () {
    mockValidation2('');

    final error = sut.validate(field: 'any', value: 'any');

    expect(error, null);
  });
}
