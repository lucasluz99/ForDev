import 'dart:async';

import 'package:faker/faker.dart';
import 'package:flutter/foundation.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

class LoginState {
  String emailError;
}

abstract class Validation {
  String validate({@required String field, @required String value});
}

class MockValidation extends Mock implements Validation {}

class StreamLoginPresenter {
  final Validation validation;
  final _controller = StreamController<LoginState>.broadcast();

  var _state = LoginState();

  Stream<String> get emailErrorStream =>
      _controller.stream.map((state) => state.emailError);

  StreamLoginPresenter({this.validation});

  void validateEmail(String email) {
    _state.emailError = validation.validate(field: 'email', value: email);
    _controller.add(_state);
  }
}

void main() {
  Validation validation;
  StreamLoginPresenter sut;
  String email;

  PostExpectation mockValidatationCall(String field) {
    return when(validation.validate(
        field: field == null ? anyNamed('field') : field,
        value: anyNamed('value')));
  }

  void mockValidation({String field, String value}) {
    mockValidatationCall(field).thenReturn(value);
  }

  setUp(() {
    validation = MockValidation();
    sut = StreamLoginPresenter(validation: validation);
    email = faker.internet.email();
    mockValidation();
  });

  test('Should call Validation with correct email', () {
    sut.validateEmail(email);

    verify(validation.validate(field: 'email', value: email)).called(1);
  });

  test('Should emit email error if validation fails', () {
    mockValidation(value: 'error');
    expectLater(sut.emailErrorStream, emits('error'));

    sut.validateEmail(email);
  });
}
