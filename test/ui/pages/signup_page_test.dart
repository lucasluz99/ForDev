import 'dart:async';
import 'package:ForDev/ui/helpers/helpers.dart';
import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mockito/mockito.dart';

import 'package:ForDev/ui/pages/pages.dart';

class MockSignUpPresenter extends Mock implements SignUpPresenter {}

void main() {
  SignUpPresenter presenter;
  StreamController<UiError> nameController;
  StreamController<UiError> emailController;
  StreamController<UiError> passwordController;
  StreamController<UiError> passwordConfirmationController;
  StreamController<UiError> mainErrorController;
  StreamController<String> navigateToController;
  StreamController<bool> isFormValidController;
  StreamController<bool> isLoadingController;

  void initStreams() {
    nameController = StreamController<UiError>();
    passwordController = StreamController<UiError>();
    passwordConfirmationController = StreamController<UiError>();
    emailController = StreamController<UiError>();
    mainErrorController = StreamController<UiError>();
    navigateToController = StreamController<String>();
    isFormValidController = StreamController<bool>();
    isLoadingController = StreamController<bool>();
  }

  void mockStreams() {
    when(presenter.nameErrorStream).thenAnswer((_) => nameController.stream);
    when(presenter.emailErrorStream).thenAnswer((_) => emailController.stream);
    when(presenter.passwordErrorStream)
        .thenAnswer((_) => passwordController.stream);
    when(presenter.passwordConfirmationErrorStream)
        .thenAnswer((_) => passwordConfirmationController.stream);
    when(presenter.isFormValidStream)
        .thenAnswer((_) => isFormValidController.stream);
    when(presenter.isLoadingStream)
        .thenAnswer((_) => isLoadingController.stream);
    when(presenter.mainErrorStream)
        .thenAnswer((_) => mainErrorController.stream);
    when(presenter.navigateToStream)
        .thenAnswer((_) => navigateToController.stream);
  }

  void closeStreams() {
    nameController.close();
    emailController.close();
    passwordController.close();
    passwordConfirmationController.close();
    isFormValidController.close();
    isLoadingController.close();
    mainErrorController.close();
    navigateToController.close();
  }

  tearDown(closeStreams);

  Future<void> loadPage(WidgetTester tester) async {
    presenter = MockSignUpPresenter();
    initStreams();
    mockStreams();
    final signUpPage = GetMaterialApp(
      initialRoute: '/signup',
      getPages: [
        GetPage(name: '/signup', page: () => SignUpPage(presenter)),
        GetPage(
            name: '/any_route',
            page: () => Scaffold(
                  body: Text('fake page'),
                ))
      ],
    );

    await tester.pumpWidget(signUpPage);
  }

  testWidgets('Should load with correct initial state',
      (WidgetTester tester) async {
    await loadPage(tester);

    final nameTextChildren = find.descendant(
        of: find.bySemanticsLabel('Nome'), matching: find.byType(Text));
    expect(nameTextChildren, findsOneWidget,
        reason:
            "when TextFormField has only one text child,means it has no errors,since one of the childs is always the label text");

    final emailTextChildren = find.descendant(
        of: find.bySemanticsLabel('Email'), matching: find.byType(Text));
    expect(emailTextChildren, findsOneWidget,
        reason:
            "when TextFormField has only one text child,means it has no errors,since one of the childs is always the label text");

    final passwordTextChildren = find.descendant(
        of: find.bySemanticsLabel('Senha'), matching: find.byType(Text));
    expect(passwordTextChildren, findsOneWidget,
        reason:
            "when TextFormField has only one text child,means it has no errors,since one of the childs is always the label text");

    final passwordConfirmationTextChildren = find.descendant(
        of: find.bySemanticsLabel('Confirmar senha'),
        matching: find.byType(Text));
    expect(passwordConfirmationTextChildren, findsOneWidget,
        reason:
            "when TextFormField has only one text child,means it has no errors,since one of the childs is always the label text");

    final button = tester.widget<RaisedButton>(find.byType(RaisedButton));
    expect(button.onPressed, null);
    expect(find.byType(CircularProgressIndicator), findsNothing);
  });

  testWidgets('Should call validate with correct values',
      (WidgetTester tester) async {
    await loadPage(tester);

    final name = faker.person.name();
    await tester.enterText(find.bySemanticsLabel('Nome'), name);
    verify(presenter.validateName(name));

    final email = faker.internet.email();
    await tester.enterText(find.bySemanticsLabel('Email'), email);
    verify(presenter.validateEmail(email));
    final password = faker.internet.password();
    await tester.enterText(find.bySemanticsLabel('Senha'), password);
    verify(presenter.validatePassword(password));

    await tester.enterText(find.bySemanticsLabel('Confirmar senha'), password);
    verify(presenter.validatePasswordConfirmation(password));
  });

  testWidgets('Should present email error', (WidgetTester tester) async {
    await loadPage(tester);

    emailController.add(UiError.invalidField);

    await tester.pump();

    expect(find.text('Campo inválido'), findsOneWidget);

    emailController.add(UiError.requiredField);

    await tester.pump();

    expect(find.text('Campo obrigatório'), findsOneWidget);

    emailController.add(null);

    await tester.pump();

    final emailTextChildren = find.descendant(
        of: find.bySemanticsLabel('Email'), matching: find.byType(Text));

    expect(emailTextChildren, findsOneWidget);
  });

  testWidgets('Should present name error', (WidgetTester tester) async {
    await loadPage(tester);

    nameController.add(UiError.invalidField);

    await tester.pump();

    expect(find.text('Campo inválido'), findsOneWidget);

    nameController.add(UiError.requiredField);

    await tester.pump();

    expect(find.text('Campo obrigatório'), findsOneWidget);

    nameController.add(null);

    await tester.pump();

    final nameTextChildren = find.descendant(
        of: find.bySemanticsLabel('Nome'), matching: find.byType(Text));

    expect(nameTextChildren, findsOneWidget);
  });

  testWidgets('Should present password error', (WidgetTester tester) async {
    await loadPage(tester);

    passwordController.add(UiError.invalidField);

    await tester.pump();

    expect(find.text('Campo inválido'), findsOneWidget);

    passwordController.add(UiError.requiredField);

    await tester.pump();

    expect(find.text('Campo obrigatório'), findsOneWidget);

    passwordController.add(null);

    await tester.pump();

    final passwordTextChildren = find.descendant(
        of: find.bySemanticsLabel('Senha'), matching: find.byType(Text));

    expect(passwordTextChildren, findsOneWidget);
  });

  testWidgets('Should present password confirmation error',
      (WidgetTester tester) async {
    await loadPage(tester);

    passwordConfirmationController.add(UiError.invalidField);

    await tester.pump();

    expect(find.text('Campo inválido'), findsOneWidget);

    passwordConfirmationController.add(UiError.requiredField);

    await tester.pump();

    expect(find.text('Campo obrigatório'), findsOneWidget);

    passwordConfirmationController.add(null);

    await tester.pump();

    final passwordTextChildren = find.descendant(
        of: find.bySemanticsLabel('Confirmar senha'),
        matching: find.byType(Text));

    expect(passwordTextChildren, findsOneWidget);
  });

  testWidgets('Should enable button with fields are valid',
      (WidgetTester tester) async {
    await loadPage(tester);

    isFormValidController.add(true);

    await tester.pump();

    final button = tester.widget<RaisedButton>(find.byType(RaisedButton));
    expect(button.onPressed, isNotNull);
  });

  testWidgets('Should disable button with fields are invalid',
      (WidgetTester tester) async {
    await loadPage(tester);

    isFormValidController.add(false);

    await tester.pump();

    final button = tester.widget<RaisedButton>(find.byType(RaisedButton));
    expect(button.onPressed, isNull);
  });

  testWidgets('Should call signUp method on form submit',
      (WidgetTester tester) async {
    await loadPage(tester);

    isFormValidController.add(true);
    await tester.pump();
    final button = find.byType(RaisedButton);

    await tester.ensureVisible(button);

    await tester.tap(button);

    await tester.pump();

    verify(presenter.signUp()).called(1);
  });

  testWidgets('Should present progress indicator on loading',
      (WidgetTester tester) async {
    await loadPage(tester);

    isLoadingController.add(true);

    await tester.pump();

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('Should hide loading', (WidgetTester tester) async {
    await loadPage(tester);

    isLoadingController.add(true);

    await tester.pump();

    isLoadingController.add(false);

    await tester.pump();

    expect(find.byType(CircularProgressIndicator), findsNothing);
  });

  testWidgets('Should present error message if signUp fails',
      (WidgetTester tester) async {
    await loadPage(tester);

    mainErrorController.add(UiError.emailInUse);

    await tester.pump();

    expect(find.text('O email já está em uso'), findsOneWidget);
  });

  testWidgets('Should present error message if signUp throws',
      (WidgetTester tester) async {
    await loadPage(tester);

    mainErrorController.add(UiError.unexpected);

    await tester.pump();

    expect(find.text('Ocorreu um erro inesperado'), findsOneWidget);
  });

  testWidgets('Should navigate to another page', (WidgetTester tester) async {
    await loadPage(tester);

    navigateToController.add('/any_route');

    await tester.pumpAndSettle();

    expect(Get.currentRoute, '/any_route');
    expect(find.text('fake page'), findsOneWidget);
  });

  testWidgets('Should not navigate to another page',
      (WidgetTester tester) async {
    await loadPage(tester);

    navigateToController.add('');

    await tester.pump();

    expect(Get.currentRoute, '/signup');

    navigateToController.add(null);

    await tester.pump();

    expect(Get.currentRoute, '/signup');
  });

  testWidgets('Should go to SignIn page when button has pressed',
      (WidgetTester tester) async {
    await loadPage(tester);

    final button = find.text('Fazer login');

    await tester.ensureVisible(button);

    await tester.tap(button);

    await tester.pump();

    verify(presenter.goToLogin()).called(1);
  });
}
