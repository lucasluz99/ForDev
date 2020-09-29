import 'package:ForDev/validation/protocols/field_validation.dart';
import 'package:faker/faker.dart';
import 'package:test/test.dart';

class EmailValidation implements FieldValidation {
  final String field;

  EmailValidation(this.field);

  String validate(String value) {
    return null;
  }
}
void main() {
  EmailValidation sut;

  setUp(() {
    sut = EmailValidation('any');
  });
 
  test('Should return null if email is empty', () {
      final error = sut.validate('');

      expect(error,null);
  });

    test('Should return null if email is valid', () {
      final error = sut.validate(faker.internet.email());

      expect(error,null);
  });
}