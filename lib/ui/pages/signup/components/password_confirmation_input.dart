import 'package:ForDev/ui/helpers/errors/errors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../signup_presenter.dart';

class PasswordConfirmationInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final presenter = Provider.of<SignUpPresenter>(context);
    return StreamBuilder<UiError>(
        stream: presenter.passwordConfirmationErrorStream,
        builder: (context, snapshot) {
          return TextFormField(
            obscureText: true,
            onChanged: presenter.validatePasswordConfirmation,
            decoration: InputDecoration(
                errorText: snapshot.hasData ? snapshot.data.description : null,
                icon: Icon(
                  Icons.email,
                  color: Theme.of(context).primaryColorLight,
                ),
                labelText: 'Confirmar senha'),
          );
        });
  }
}
