import 'package:ForDev/data/cache/cache.dart';
import 'package:ForDev/data/http/http_error.dart';
import 'package:ForDev/data/models/models.dart';
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
    final response = await fetchCacheStorage.fetch('surveys');
    return response
        .map<SurveyEntity>((json) => LocalSurveyModel.fromJson(json).toEntity())
        .toList();
  }
}

abstract class FetchCacheStorage {
  Future<dynamic> fetch(String key);
}

class MockFetchCacheStorage extends Mock implements FetchCacheStorage {}

void main() {
  LocalLoadSurveys sut;
  FetchCacheStorage fetchCacheStorage;

  List<Map<String, Object>> mockValidData() => [
        {
          'id': faker.guid.guid(),
          'date': '2020-07-20T00:00:00Z',
          'question': faker.randomGenerator.string(50),
          'didAnswer': 'false'
        },
        {
          'id': faker.guid.guid(),
          'date': '2020-07-20T00:00:00Z',
          'question': faker.randomGenerator.string(50),
          'didAnswer': 'true'
        },
      ];

  final list = mockValidData();

  void mockFetchCacheStorage() =>
      when(fetchCacheStorage.fetch(any)).thenAnswer((_) async => list);

  final surveysList = [
    SurveyEntity(
      id: list[0]['id'],
      question: list[0]['question'],
      dateTime: DateTime.utc(2020, 7, 20),
      didAnswer: false,
    ),
    SurveyEntity(
      id: list[1]['id'],
      question: list[1]['question'],
      dateTime: DateTime.utc(2020, 7, 20),
      didAnswer: true,
    )
  ];

  setUp(() {
    fetchCacheStorage = MockFetchCacheStorage();
    sut = LocalLoadSurveys(fetchCacheStorage: fetchCacheStorage);
    mockFetchCacheStorage();
  });

  test('Should call FetchCacheStorage with correct key', () async {
     await sut.load();

    verify(fetchCacheStorage.fetch('surveys')).called(1);
  });

  test('Should return a list of SurveyEntity on success', () async {
    final surveys = await sut.load();
    expect(surveys, surveysList);
  });
}
