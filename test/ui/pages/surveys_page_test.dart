import 'dart:async';

import 'package:ForDev/ui/helpers/helpers.dart';
import 'package:faker/faker.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';

import 'package:ForDev/domain/usecases/usecases.dart';
import 'package:ForDev/ui/pages/pages.dart';

class MockSurveysPresenter extends Mock implements SurveysPresenter {}

void main() {
  final presenter = MockSurveysPresenter();
  StreamController<bool> isLoadingController;
  StreamController<List<SurveyViewModel>> surveysController;

  List<SurveyViewModel> makeSurveys() => [
        SurveyViewModel(
            id: faker.guid.guid(),
            question: 'Question 1',
            date: '20 nov 2020',
            didAnswer: true),
        SurveyViewModel(
            id: faker.guid.guid(),
            question: 'Question 2',
            date: '21 nov 2020',
            didAnswer: false),
      ];

  void initStreams() {
    isLoadingController = StreamController<bool>();
    surveysController = StreamController<List<SurveyViewModel>>();
  }

  void closeStreams() {
    isLoadingController.close();
    surveysController.close();
  }

  void mockStreams() {
    when(presenter.isLoadingStream)
        .thenAnswer((_) => isLoadingController.stream);
    when(presenter.surveysStream).thenAnswer((_) => surveysController.stream);
  }

  tearDown(() {
    closeStreams();
  });

  Future<void> loadPage(WidgetTester tester) async {
    // presenter = MockSurveysPresenter();
    initStreams();
    mockStreams();
    final surveysPage = GetMaterialApp(
      initialRoute: '/surveys',
      getPages: [
        GetPage(name: '/surveys', page: () => SurveysPage(presenter)),
        GetPage(
            name: '/any_route',
            page: () => Scaffold(
                  body: Text('fake page'),
                ))
      ],
    );

    await tester.pumpWidget(surveysPage);
  }

  testWidgets('Should call LoadSurveys on page load',
      (WidgetTester tester) async {
    await loadPage(tester);

    verify(presenter.loadData()).called(1);
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

  testWidgets('Should present error if loadSurveysStream fails',
      (WidgetTester tester) async {
    await loadPage(tester);

    surveysController.addError(UiError.unexpected.description);

    await tester.pump();

    expect(find.text('Ocorreu um erro inesperado'), findsOneWidget);
    expect(find.text('Recarregar'), findsOneWidget);
    expect(find.text('Question 1'), findsNothing);
  });

  testWidgets('Should present list on loadSurveysStream success',
      (WidgetTester tester) async {
    await loadPage(tester);
    surveysController.add(makeSurveys());

    await tester.pump();

    expect(find.text('Ocorreu um erro inesperado'), findsNothing);
    expect(find.text('Recarregar'), findsNothing);
    expect(find.text('Question 1'), findsWidgets);
    expect(find.text('Question 2'), findsWidgets);
    expect(find.text('20 nov 2020'), findsWidgets);
    expect(find.text('21 nov 2020'), findsWidgets);
  });

  testWidgets('Should call LoadSurveys on reload button click',
      (WidgetTester tester) async {
    await loadPage(tester);

    surveysController.addError(UiError.unexpected.description);

    await tester.pump();

    await tester.tap(find.text('Recarregar'));

    verify(presenter.loadData()).called(2);
  });
}
