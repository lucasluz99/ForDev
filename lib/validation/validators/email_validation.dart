import 'package:equatable/equatable.dart';

import '../../presentation/presentation.dart';
import '../protocols/protocols.dart';

class EmailValidation extends Equatable implements FieldValidation {
  final String field;

  List get props => [field];

  EmailValidation(this.field);

  ValidationError validate(String value) {
    final regex = RegExp(
        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
    final isValid = value?.isEmpty == true || regex.hasMatch(value);

    return isValid ? null : ValidationError.invalidField;
  }
}
