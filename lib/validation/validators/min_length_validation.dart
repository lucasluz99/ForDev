import 'package:meta/meta.dart';
import '../protocols/protocols.dart';

class MinLengthValidation implements FieldValidation {
  final field;
  final size;

  MinLengthValidation({
    @required this.field,
    @required this.size,
  });

  ValidationError validate(String value) {
    return value != null && value.length >= size
        ? null
        : ValidationError.invalidField;
  }
}