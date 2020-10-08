import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../ui/helpers/errors/errors.dart';
import '../login_presenter.dart';

class PasswordInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final presenter = Provider.of<LoginPresenter>(context);
    return StreamBuilder<UiError>(
        stream: presenter.passwordErrorStream,
        builder: (context, snapshot) {
          return TextFormField(
            onChanged: presenter.validatePassword,
            obscureText: true,
            decoration: InputDecoration(
                errorText: snapshot.hasData ? snapshot.data.description : null,
                icon: Icon(Icons.lock,
                    color: Theme.of(context).primaryColorLight),
                labelText: 'Senha'),
          );
        });
  }
}
