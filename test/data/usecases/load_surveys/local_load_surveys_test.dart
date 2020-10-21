import 'package:ForDev/data/cache/cache.dart';
import 'package:ForDev/data/http/http_error.dart';
import 'package:ForDev/domain/entities/entities.dart';
import 'package:faker/faker.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'package:ForDev/domain/helpers/helpers.dart';
import 'package:ForDev/domain/usecases/usecases.dart';

import 'package:ForDev/data/usecases/usecases.dart';
import 'package:ForDev/data/http/http.dart';

class LocalLoadSurveys implements LoadSurveys {
  final FetchCacheStorage fetchCacheStorage;

  LocalLoadSurveys({this.fetchCacheStorage});

  Future<List<SurveyEntity>> load() async {
    await fetchCacheStorage.fetch('surveys');
  }

}

abstract class FetchCacheStorage {
  Future<void> fetch(String key);
}

class MockFetchCacheStorage extends Mock implements FetchCacheStorage{}

void main() {
  LocalLoadSurveys sut;
  FetchCacheStorage fetchCacheStorage;
  String url;

  List<Map<String, Object>> mockValidData() => [
        {
          'id': faker.guid.guid(),
          'date': faker.date.dateTime().toIso8601String(),
          'question': faker.randomGenerator.string(50),
          'didAnswer': faker.randomGenerator.boolean()
        },
        {
          'id': faker.guid.guid(),
          'date': faker.date.dateTime().toIso8601String(),
          'question': faker.randomGenerator.string(50),
          'didAnswer': faker.randomGenerator.boolean()
        },
      ];

  final list = mockValidData();

  final surveysList = [
    SurveyEntity(
      id: list[0]['id'],
      question: list[0]['question'],
      dateTime: DateTime.parse(list[0]['date']),
      didAnswer: list[0]['didAnswer'],
    ),
    SurveyEntity(
      id: list[1]['id'],
      question: list[1]['question'],
      dateTime: DateTime.parse(list[1]['date']),
      didAnswer: list[1]['didAnswer'],
    )
  ];

  setUp(() {
    fetchCacheStorage = MockFetchCacheStorage();
    url = faker.internet.httpUrl();
    sut = LocalLoadSurveys(fetchCacheStorage: fetchCacheStorage);
   
  });

  test('Should call FetchCacheStorage with correct key', () async {
    await sut.load();

    verify(fetchCacheStorage.fetch('surveys')).called(1);
  });

  
}
