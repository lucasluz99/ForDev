import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mockito/mockito.dart';

class SplashPage extends StatelessWidget {
  final SplashPresenter presenter;

  const SplashPage({@required this.presenter});
  @override
  Widget build(BuildContext context) {
    presenter.loadCurrentAccount();
    return Scaffold(
        appBar: AppBar(
          title: Text('4Dev'),
        ),
        body: Center(
          child: CircularProgressIndicator(),
        ));
  }
}

abstract class SplashPresenter {
  Future<void> loadCurrentAccount();
}

class MockSplashPresenter extends Mock implements SplashPresenter {}

void main() {
  SplashPresenter presenter;
  Future<void> loadPage(WidgetTester tester) async {
    presenter = MockSplashPresenter();
    await tester.pumpWidget(GetMaterialApp(initialRoute: '/', getPages: [
      GetPage(name: '/', page: () => SplashPage(presenter: presenter))
    ]));
  }

  testWidgets('Should call loadCurrentAccount on page load',
      (WidgetTester tester) async {
    await loadPage(tester);

    verify(presenter.loadCurrentAccount()).called(1);
  });
}
