import 'package:ForDev/domain/entities/entities.dart';
import 'package:ForDev/ui/pages/pages.dart';
import 'package:faker/faker.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'package:ForDev/presentation/presentation.dart';
import 'package:ForDev/domain/usecases/usecases.dart';

class MockLoadSurveys extends Mock implements LoadSurveys {}

void main() {
  SurveysPresenter sut;
  LoadSurveys loadSurveys;

  List<SurveyEntity> mockValidData() => [
        SurveyEntity(
            id: '1',
            question: 'oi 1',
            dateTime: DateTime(2020, 2, 20),
            didAnswer: true),
        SurveyEntity(
            id: '2',
            question: 'oi 2',
            dateTime: DateTime(2020, 2, 21),
            didAnswer: false),
      ];

  void mockLoadSurveysData(List<SurveyEntity> data) {
    return when(loadSurveys.load()).thenAnswer((_) async => data);
  }

  setUp(() {
    loadSurveys = MockLoadSurveys();
    sut = GetxSurveysPresenter(loadSurveys: loadSurveys);
    mockLoadSurveysData(mockValidData());
  });
  test('Shoud call LoadSurveys on loadData method', () async {
    await sut.loadData();

    verify(loadSurveys.load()).called(1);
  });

  test('Shoud emit correct events on success', () async {
    expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
    sut.surveysStream.listen(expectAsync1((surveys) => expect(surveys, [
          SurveyViewModel(
              id: surveys[0].id,
              question: surveys[0].question,
              date: '20 Fev 2020',
              didAnswer: surveys[0].didAnswer),
          SurveyViewModel(
              id: surveys[1].id,
              question: surveys[1].question,
              date: '21 Fev 2021',
              didAnswer: surveys[1].didAnswer),
        ])));
    await sut.loadData();
  });
}
