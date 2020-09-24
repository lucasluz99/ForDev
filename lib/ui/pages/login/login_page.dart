import 'package:flutter/material.dart';

import '../../components/components.dart';

import '../pages.dart';

class LoginPage extends StatefulWidget {
  final LoginPresenter presenter;

  LoginPage(this.presenter);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  void dispose() {
    super.dispose();
    widget.presenter.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Builder(builder: (context) {
        widget.presenter.isLoadingStream.listen((isLoading) {
          if (isLoading) {
            showDialog(
                context: context,
                barrierDismissible: false,
                builder: (context) => SimpleDialog(
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircularProgressIndicator(),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              'Aguarde...',
                              textAlign: TextAlign.center,
                            )
                          ],
                        )
                      ],
                    ));
          } else {
            if (Navigator.canPop(context)) {
              Navigator.of(context).pop();
            }
          }
        });

        widget.presenter.mainErrorStream.listen((mainError) {
          if (mainError != null) {
            Scaffold.of(context).showSnackBar(SnackBar(
              backgroundColor: Colors.red[900],
              content: Text(
                mainError,
                textAlign: TextAlign.center,
              ),
            ));
          }
        });
        return SingleChildScrollView(
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
                          stream: widget.presenter.emailErrorStream,
                          builder: (context, snapshot) {
                            return TextFormField(
                              onChanged: widget.presenter.validateEmail,
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
                            stream: widget.presenter.passwordErrorStream,
                            builder: (context, snapshot) {
                              return TextFormField(
                                onChanged: widget.presenter.validatePassword,
                                obscureText: true,
                                decoration: InputDecoration(
                                    errorText: snapshot.data?.isEmpty == true
                                        ? null
                                        : snapshot.data,
                                    icon: Icon(Icons.lock,
                                        color: Theme.of(context)
                                            .primaryColorLight),
                                    labelText: 'Senha'),
                              );
                            }),
                      ),
                      StreamBuilder<bool>(
                          stream: widget.presenter.isFormValidStream,
                          builder: (context, snapshot) {
                            return RaisedButton(
                              child: Text('Entrar'.toUpperCase()),
                              onPressed:
                                  snapshot.data == true ? widget.presenter.auth : null,
                            );
                          }),
                      FlatButton.icon(
                          icon: Icon(Icons.person),
                          label: Text('Criar conta'),
                          onPressed: () {})
                    ],
                  ),
                ),
              )
            ],
          ),
        );
      }),
    );
  }
}
