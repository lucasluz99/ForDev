import 'dart:async';

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

  void initStreams() {
    isLoadingController = StreamController<bool>();
  }

  void closeStreams() {
    isLoadingController.close();
  }

  void mockStreams() {
    when(presenter.isLoadingStream)
        .thenAnswer((_) => isLoadingController.stream);
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
}
