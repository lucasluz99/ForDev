import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../ui/helpers/errors/errors.dart';
import '../login_presenter.dart';

class EmailInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final presenter = Provider.of<LoginPresenter>(context);
    return StreamBuilder<UiError>(
        stream: presenter.emailErrorStream,
        builder: (context, snapshot) {
          return TextFormField(
            onChanged: presenter.validateEmail,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
                errorText: snapshot.hasData ? snapshot.data.description : null,
                icon: Icon(
                  Icons.email,
                  color: Theme.of(context).primaryColorLight,
                ),
                labelText: 'Email'),
          );
        });
  }
}
