import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../entities/entities.dart';

abstract class AddAccount {
  Future<AccountEntity> add(AddAccountParams params);
}

class AddAccountParams extends Equatable {
  final String email;
  final String name;
  final String password;
  final String confirmPassword;

  List get props => [email, name, password, confirmPassword];

  AddAccountParams({
    @required this.email,
    @required this.name,
    @required this.password,
    @required this.confirmPassword,
  });
}
