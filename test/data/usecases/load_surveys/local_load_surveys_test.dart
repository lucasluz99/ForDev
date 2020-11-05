import 'package:faker/faker.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'package:ForDev/data/usecases/load_surveys/load_surveys.dart';
import 'package:ForDev/data/cache/cache.dart';

import 'package:ForDev/domain/helpers/helpers.dart';
import 'package:ForDev/domain/entities/entities.dart';

class MockCacheStorage extends Mock implements CacheStorage {}

void main() {
  group('load', () {
    LocalLoadSurveys sut;
    CacheStorage cacheStorage;

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

    void mockCacheStorage(List list) =>
        when(cacheStorage.fetch(any)).thenAnswer((_) async => list);

    void mockCacheError() =>
        when(cacheStorage.fetch(any)).thenThrow(Exception());

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
      cacheStorage = MockCacheStorage();
      sut = LocalLoadSurveys(cacheStorage: cacheStorage);
      mockCacheStorage(list);
    });

    test('Should call FetchCacheStorage with correct key', () async {
      await sut.load();

      verify(cacheStorage.fetch('surveys')).called(1);
    });

    test('Should return a list of SurveyEntity on success', () async {
      final surveys = await sut.load();
      expect(surveys, surveysList);
    });

    test('Should throw UnexpectedError if cache returns an empty list',
        () async {
      mockCacheStorage([]);
      final future = sut.load();
      expect(future, throwsA(DomainError.unexpected));
    });

    test('Should throw UnexpectedError if cache returns null', () async {
      mockCacheStorage(null);
      final future = sut.load();
      expect(future, throwsA(DomainError.unexpected));
    });

    test('Should throw UnexpectedError if cache returns invalid data',
        () async {
      mockCacheStorage([
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
      mockCacheStorage([
        {'date': '2020-07-20T00:00:00Z', 'didAnswer': 'false'},
      ]);
      final future = sut.load();
      expect(future, throwsA(DomainError.unexpected));
    });

    test('Should throw UnexpectedError if cache fails', () async {
      mockCacheError();
      final future = sut.load();
      expect(future, throwsA(DomainError.unexpected));
    });
  });

  group('validate', () {
    LocalLoadSurveys sut;
    CacheStorage cacheStorage;

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

    void mockCacheStorage(List list) =>
        when(cacheStorage.fetch(any)).thenAnswer((_) async => list);

    void mockCacheError() =>
        when(cacheStorage.fetch(any)).thenThrow(Exception());

    setUp(() {
      cacheStorage = MockCacheStorage();
      sut = LocalLoadSurveys(cacheStorage: cacheStorage);
      mockCacheStorage(list);
    });

    test('Should call CacheStorage with correct key', () async {
      await sut.validate();

      verify(cacheStorage.fetch('surveys')).called(1);
    });

    test('Should delete cache if it is invalid', () async {
      mockCacheStorage([
        {
          'id': faker.guid.guid(),
          'date': 'invalid date',
          'question': faker.randomGenerator.string(50),
          'didAnswer': 'false'
        },
      ]);

      await sut.validate();

      verify(cacheStorage.delete('surveys')).called(1);
    });

    test('Should delete cache if it is invalid', () async {
      mockCacheError();

      await sut.validate();

      verify(cacheStorage.delete('surveys')).called(1);
    });
  });

  group('save', () {
    LocalLoadSurveys sut;
    CacheStorage cacheStorage;
    List<SurveyEntity> surveys;

    void mockCacheError() =>
        when(cacheStorage.save(key:anyNamed('key'),value: anyNamed('value'))).thenThrow(Exception());
  
    List<SurveyEntity> mockSurveys() => [
          SurveyEntity(
            id: faker.guid.guid(),
            question: faker.randomGenerator.string(10),
            dateTime: DateTime.utc(2020, 2, 2),
            didAnswer: true,
          ),
          SurveyEntity(
            id: faker.guid.guid(),
            question: faker.randomGenerator.string(10),
            dateTime: DateTime.utc(2019, 12, 20),
            didAnswer: false,
          ),
        ];

    setUp(() {
      cacheStorage = MockCacheStorage();
      sut = LocalLoadSurveys(cacheStorage: cacheStorage);
      surveys = mockSurveys();
    });

    test('Should call CacheStorage with correct values', () async {
     final list = [
          {
            'id': surveys[0].id,
            'date': '2020-02-02T00:00:00.000Z',
            'question': surveys[0].question,
            'didAnswer': 'true',
          },
          {
            'id': surveys[1].id,
            'date': '2019-12-20T00:00:00.000Z',
            'question': surveys[1].question,
            'didAnswer': 'false'
          },
        ];
      await sut.save(surveys);

      verify(cacheStorage.save(key: 'surveys', value: list)).called(1);
    });

    test('Should throws UnexpectedError if save throws', () async {
      mockCacheError();
      final future = sut.save(surveys);

      expect(future,throwsA(DomainError.unexpected));
    });
  });



}
