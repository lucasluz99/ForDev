import 'package:faker/faker.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'package:ForDev/data/usecases/load_surveys/load_surveys.dart';
import 'package:ForDev/data/cache/cache.dart';

import 'package:ForDev/domain/helpers/helpers.dart';
import 'package:ForDev/domain/entities/entities.dart';

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

  void mockFetchCacheStorage(List list) =>
      when(fetchCacheStorage.fetch(any)).thenAnswer((_) async => list);

  void mockFetchCacheError() =>
      when(fetchCacheStorage.fetch(any)).thenThrow(Exception());

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
    mockFetchCacheStorage(list);
  });

  test('Should call FetchCacheStorage with correct key', () async {
    await sut.load();

    verify(fetchCacheStorage.fetch('surveys')).called(1);
  });

  test('Should return a list of SurveyEntity on success', () async {
    final surveys = await sut.load();
    expect(surveys, surveysList);
  });

  test('Should throw UnexpectedError if cache returns an empty list', () async {
    mockFetchCacheStorage([]);
    final future = sut.load();
    expect(future, throwsA(DomainError.unexpected));
  });

  test('Should throw UnexpectedError if cache returns null', () async {
    mockFetchCacheStorage(null);
    final future = sut.load();
    expect(future, throwsA(DomainError.unexpected));
  });

  test('Should throw UnexpectedError if cache returns invalid data', () async {
    mockFetchCacheStorage([
      {
        'id': faker.guid.guid(),
        'date': 'invalid date',
        'question': faker.randomGenerator.string(50),
        'didAnswer': 'false'
      },
    ]);
    final future = sut.load();
    expect(future, throwsA(DomainError.unexpected));
  });

  test('Should throw UnexpectedError if cache returns incomplete data',
      () async {
    mockFetchCacheStorage([
      {'date': '2020-07-20T00:00:00Z', 'didAnswer': 'false'},
    ]);
    final future = sut.load();
    expect(future, throwsA(DomainError.unexpected));
  });

  test('Should throw UnexpectedError if cache fails', () async {
    mockFetchCacheError();
    final future = sut.load();
    expect(future, throwsA(DomainError.unexpected));
  });
}
