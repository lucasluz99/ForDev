import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../../helpers/errors/errors.dart';
import '../../helpers/i18n/i18n.dart';
import '../../components/components.dart';
import '../pages.dart';
import 'components/components.dart';

class SignUpPage extends StatelessWidget {
  final SignUpPresenter presenter;

  const SignUpPage(this.presenter);

  void _hideKeyboard(BuildContext context) {
    final currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Builder(builder: (context) {
        presenter.isLoadingStream.listen((isLoading) {
          if (isLoading) {
            showLoading(context);
          } else {
            hideLoading(context);
          }
        });

        presenter.navigateToStream.listen((page) {
          if (page?.isNotEmpty == true) {
            Get.offAllNamed(page);
          }
        });

        presenter.mainErrorStream.listen((UiError mainError) {
          if (mainError != null) {
            showErrorMessage(context, mainError.description);
          }
        });

        return GestureDetector(
          onTap: () => _hideKeyboard(context),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                LoginHeader(),
                Headline1(text: 'Login'),
                Padding(
                  padding: const EdgeInsets.all(32),
                  child: Provider(
                    create: (_) => presenter,
                    child: Form(
                      child: Column(
                        children: [
                          NameInput(),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: EmailInput(),
                          ),
                          PasswordInput(),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 32, top: 10),
                            child: PasswordConfirmationInput(),
                          ),
                          SignUpButton(),
                          FlatButton.icon(
                              icon: Icon(Icons.exit_to_app),
                              label: Text(R.strings.addAccount),
                              onPressed: () {})
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      }),
    );
  }
}
