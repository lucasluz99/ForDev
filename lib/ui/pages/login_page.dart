import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              child: Image(image: AssetImage('lib/ui/assets/logo.png')),
            ),
            Text('Login'.toUpperCase()),
            Form(
              child: Column(
                children: [
                  TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                        icon: Icon(Icons.email), labelText: 'Email'),
                  ),
                  TextFormField(
                    obscureText: true,
                    decoration: InputDecoration(
                        icon: Icon(Icons.lock), labelText: 'Senha'),
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
            )
          ],
        ),
      ),
    );
  }
}
