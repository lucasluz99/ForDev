import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../login_presenter.dart';

class EmailInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final presenter = Provider.of<LoginPresenter>(context);
    return StreamBuilder<String>(
        stream: presenter.emailErrorStream,
        builder: (context, snapshot) {
          return TextFormField(
            onChanged: presenter.validateEmail,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
                errorText:
                    snapshot.data?.isEmpty == true ? null : snapshot.data,
                icon: Icon(
                  Icons.email,
                  color: Theme.of(context).primaryColorLight,
                ),
                labelText: 'Email'),
          );
        });
  }
}
