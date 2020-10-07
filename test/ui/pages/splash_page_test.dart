import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mockito/mockito.dart';

class SplashPage extends StatelessWidget {
  final SplashPresenter presenter;

  SplashPage({this.presenter});
  @override
  Widget build(BuildContext context) {
    presenter.loadCurrentAccount();
    return Scaffold(
        appBar: AppBar(
          title: Text('4Dev'),
        ),
        body: Builder(builder: (context) {
          presenter.navigateToStream.listen((page) {
            if (page?.isNotEmpty == true) {
              Get.offAllNamed(page);
            }
          });
          return Center(
            child: CircularProgressIndicator(),
          );
        }));
  }
}

abstract class SplashPresenter {
  Stream<String> get navigateToStream;
  Future<void> loadCurrentAccount();
}

class MockSplashPresenter extends Mock implements SplashPresenter {}

void main() {
  SplashPresenter presenter;
  StreamController<String> navigateToController;

  Future<void> loadPage(WidgetTester tester) async {
    presenter = MockSplashPresenter();
    navigateToController = StreamController<String>();
    when(presenter.navigateToStream)
        .thenAnswer((_) => navigateToController.stream);
    await tester.pumpWidget(GetMaterialApp(initialRoute: '/', getPages: [
      GetPage(name: '/', page: () => SplashPage(presenter: presenter)),
      GetPage(
          name: '/any_route',
          page: () => Scaffold(
                body: Text('fake page'),
              ))
    ]));
  }

  tearDown((() {
    navigateToController.close();
  }));

  testWidgets('Should call loadCurrentAccount on page load',
      (WidgetTester tester) async {
    await loadPage(tester);

    verify(presenter.loadCurrentAccount()).called(1);
  });

  testWidgets('Should navigate to other page', (WidgetTester tester) async {
    await loadPage(tester);

    navigateToController.add('/any_route');

    await tester.pumpAndSettle();

    expect(Get.currentRoute, '/any_route');
    expect(find.text('fake page'), findsOneWidget);
  });

  testWidgets('Should not navigate to other page', (WidgetTester tester) async {
    await loadPage(tester);

    navigateToController.add('');

    await tester.pump();

    expect(Get.currentRoute, '/');

    navigateToController.add(null);

    await tester.pump();

    expect(Get.currentRoute, '/');
  });
}
