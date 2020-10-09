import 'package:ForDev/data/usecases/usecases.dart';
import 'package:ForDev/domain/helpers/domain_error.dart';
import 'package:meta/meta.dart';

import '../../../domain/entities/entities.dart';
import '../../../domain/usecases/usecases.dart';

import '../../http/http.dart';

class RemoteAddAccount {
  final HttpClient httpClient;
  final String url;

  RemoteAddAccount({@required this.httpClient, @required this.url});

  Future<void> add(AddAccountParams params) async {
    final body = RemoteAddAccountParams.fromDomain(params).toJson();
    try {
      await httpClient.request(url: url, method: 'post', body: body);
    } on HttpError{
      throw DomainError.unexpected;
    }
  }
}

class RemoteAddAccountParams {
  final String email;
  final String name;
  final String password;
  final String passwordConfirmation;

  RemoteAddAccountParams({
    @required this.email,
    @required this.name,
    @required this.password,
    @required this.passwordConfirmation,
  });

  factory RemoteAddAccountParams.fromDomain(AddAccountParams params) {
    return RemoteAddAccountParams(
      email: params.email,
      name: params.name,
      password: params.password,
      passwordConfirmation: params.password,
    );
  }

  Map<String, String> toJson() {
    return {
      'email': email,
      'name': name,
      'password': password,
      'passwordConfirmation': passwordConfirmation,
    };
  }
}
