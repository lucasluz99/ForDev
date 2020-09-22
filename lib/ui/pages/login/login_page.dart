import 'package:flutter/material.dart';

import '../../components/components.dart';

import '../pages.dart';

class LoginPage extends StatelessWidget {
  final LoginPresenter presenter;

  LoginPage(this.presenter);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            LoginHeader(),
            Headline1(text: 'Login'),
            Padding(
              padding: const EdgeInsets.all(32),
              child: Form(
                child: Column(
                  children: [
                    StreamBuilder<String>(
                        stream: presenter.emailErrorStream,
                        builder: (context, snapshot) {
                          return TextFormField(
                            onChanged: presenter.validateEmail,
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                                errorText: snapshot.data?.isEmpty == true
                                    ? null
                                    : snapshot.data,
                                icon: Icon(
                                  Icons.email,
                                  color: Theme.of(context).primaryColorLight,
                                ),
                                labelText: 'Email'),
                          );
                        }),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 32, top: 10),
                      child: StreamBuilder<String>(
                          stream: presenter.passwordErrorStream,
                          builder: (context, snapshot) {
                            return TextFormField(
                              onChanged: presenter.validatePassword,
                              obscureText: true,
                              decoration: InputDecoration(
                                  errorText: snapshot.data?.isEmpty == true
                                      ? null
                                      : snapshot.data,
                                  icon: Icon(Icons.lock,
                                      color:
                                          Theme.of(context).primaryColorLight),
                                  labelText: 'Senha'),
                            );
                          }),
                    ),
                    RaisedButton(
                      child: Text('Entrar'.toUpperCase()),
                      onPressed: null,
                    ),
                    FlatButton.icon(
                      icon: Icon(Icons.person),
                      label: Text('Criar conta'),
                      onPressed: () {},
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
