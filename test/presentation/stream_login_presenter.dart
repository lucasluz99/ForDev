import 'package:faker/faker.dart';
import 'package:flutter/foundation.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

abstract class Validation {
  String validate({@required String field, @required String value});
}

class MockValidation extends Mock implements Validation {}

class StreamLoginPresenter {
  final Validation validation;

  StreamLoginPresenter({this.validation});

  void validateEmail(String email) {}
}

void main() {
  test('Should call Validation with correct email', () {
    final validation = MockValidation();
    final sut = StreamLoginPresenter(validation: validation);
    String email = faker.internet.email();

    sut.validateEmail(email);

    verify(validation.validate(field: 'email', value: email)).called(1);
  });
}
