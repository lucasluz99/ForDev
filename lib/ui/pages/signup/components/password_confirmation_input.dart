import 'package:flutter/material.dart';

class PasswordConfirmationInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: true,
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
          icon: Icon(
            Icons.email,
            color: Theme.of(context).primaryColorLight,
          ),
          labelText: 'Confirmar senha'),
    );
  }
}
