
import 'package:ForDev/ui/pages/pages.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'package:ForDev/presentation/presentation.dart';
import 'package:ForDev/domain/usecases/usecases.dart';

class MockLoadSurveys extends Mock implements LoadSurveys {}

void main() {
  SurveysPresenter sut;
  LoadSurveys loadSurveys;

  setUp(() {
    loadSurveys = MockLoadSurveys();
    sut = GetxSurveysPresenter(loadSurveys: loadSurveys);
  });
  test('Shoud call LoadSurveys on loadData method', () async {
    await sut.loadData();

    verify(loadSurveys.load()).called(1);
  });
}
