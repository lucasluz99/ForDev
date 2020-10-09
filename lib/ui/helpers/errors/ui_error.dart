enum UiError {
  requiredField,
  invalidField,
  unexpected,
  invalidCredentials,
  emailInUse,
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
      case UiError.emailInUse:
        return 'O email já está em uso';
      default:
        return 'Ocorreu um erro inesperado';
    }
  }
}
