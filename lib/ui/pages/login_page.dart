import 'package:flutter/material.dart';

import '../components/components.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            LoginHeader(),
            Headline1(text:'Login'),
            Padding(
              padding: const EdgeInsets.all(32),
              child: Form(
                child: Column(
                  children: [
                    TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                          icon: Icon(
                            Icons.email,
                            color: Theme.of(context).primaryColorLight,
                          ),
                          labelText: 'Email'),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 32, top: 10),
                      child: TextFormField(
                        obscureText: true,
                        decoration: InputDecoration(
                            icon: Icon(Icons.lock,
                                color: Theme.of(context).primaryColorLight),
                            labelText: 'Senha'),
                      ),
                    ),
                    RaisedButton(
                      child: Text('Entrar'.toUpperCase()),
                      onPressed: () {},
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
