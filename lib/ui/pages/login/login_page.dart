import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../components/components.dart';
import './components/components.dart';
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
            showLoading(context);
          } else {
            hideLoading(context);
          }
        });

        widget.presenter.mainErrorStream.listen((mainError) {
          if (mainError != null) {
            showErrorMessage(context, mainError);
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
                child: Provider(
                  create: (_) => widget.presenter,
                  child: Form(
                    child: Column(
                      children: [
                        EmailInput(),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 32, top: 10),
                          child: PasswordInput(),
                        ),
                        LoginButton(),
                        FlatButton.icon(
                            icon: Icon(Icons.person),
                            label: Text('Criar conta'),
                            onPressed: () {})
                      ],
                    ),
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

