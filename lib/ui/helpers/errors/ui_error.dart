enum UiError {
  requiredField,
  invalidField,
  unexpected,
  invalidCredentials,
}

extension DomainErrorExtension on UiError {
  String get description {
    switch (this) {
      case UiError.invalidCredentials:
        return 'Credenciais inválidas';
      case UiError.requiredField:
        return 'Campo obrigatório';
      case UiError.invalidField:
        return 'Campo inválido';
      default:
        return 'Ocorreu um erro inesperado';
    }
  }
}
