import 'dart:async';

import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:ForDev/ui/pages/pages.dart';
import 'package:mockito/mockito.dart';

class MockLoginPresenter extends Mock implements LoginPresenter {}
void main() {
  LoginPresenter presenter;
  StreamController<String>  emailController;
  StreamController<String>  passwordController;
  Future<void> loadPage(WidgetTester tester) async {
    presenter = MockLoginPresenter();
    passwordController = StreamController<String>();
    emailController = StreamController<String>();
    when(presenter.emailErrorStream).thenAnswer((_) => emailController.stream );
    when(presenter.passwordErrorStream).thenAnswer((_) => passwordController.stream);
    final loginPage = MaterialApp(home: LoginPage(presenter));

    await tester.pumpWidget(loginPage);
  }

  tearDown((){
    emailController.close();
    passwordController.close();
  });

  testWidgets('Should load with correct initial state',
      (WidgetTester tester) async {
    await loadPage(tester);

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

    final button = tester.widget<RaisedButton>(find.byType(RaisedButton));
    expect(button.onPressed, null);
  });

  testWidgets('Should call validate with correct values',
      (WidgetTester tester) async {
    await loadPage(tester);
    final email = faker.internet.email();
    final password = faker.internet.password();

    await tester.enterText(find.bySemanticsLabel('Email'), email);
    await tester.enterText(find.bySemanticsLabel('Senha'), password);

    verify(presenter.validateEmail(email));
    verify(presenter.validatePassword(password));
  });

  testWidgets('Should present error if email is invalid',
      (WidgetTester tester) async {
    await loadPage(tester);

    emailController.add('any error');

    await tester.pump();

    expect(find.text('any error'),findsOneWidget);
  });

    testWidgets('Should present no error if email is valid',
      (WidgetTester tester) async {
    await loadPage(tester);

    emailController.add(null);

    await tester.pump();

    final emailTextChildren = find.descendant(
        of: find.bySemanticsLabel('Email'), matching: find.byType(Text));
    expect(emailTextChildren, findsOneWidget);


  });

  testWidgets('Should present no error if email is valid',
      (WidgetTester tester) async { 
    await loadPage(tester);

    emailController.add('');

    await tester.pump();

    final emailTextChildren = find.descendant(
        of: find.bySemanticsLabel('Email'), matching: find.byType(Text));
    expect(emailTextChildren, findsOneWidget);

    
  });

  testWidgets('Should present error if password is invalid',
      (WidgetTester tester) async {
    await loadPage(tester);

    passwordController.add('any error');

    await tester.pump();

    expect(find.text('any error'),findsOneWidget);
  });


testWidgets('Should present no error if password is valid',
      (WidgetTester tester) async {
    await loadPage(tester);

    passwordController.add(null);

    await tester.pump();

    final emailTextChildren = find.descendant(
        of: find.bySemanticsLabel('Senha'), matching: find.byType(Text));
    expect(emailTextChildren, findsOneWidget);


  });

  testWidgets('Should present error if password is valid',
      (WidgetTester tester) async { 
    await loadPage(tester);

    emailController.add('');

    await tester.pump();

    final emailTextChildren = find.descendant(
        of: find.bySemanticsLabel('Senha'), matching: find.byType(Text));
    expect(emailTextChildren, findsOneWidget);

    
  });
}
