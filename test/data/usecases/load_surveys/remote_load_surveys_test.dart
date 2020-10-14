import 'package:ForDev/data/http/http_error.dart';
import 'package:ForDev/domain/entities/entities.dart';
import 'package:faker/faker.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'package:ForDev/domain/helpers/helpers.dart';
import 'package:ForDev/domain/usecases/usecases.dart';

import 'package:ForDev/data/usecases/usecases.dart';
import 'package:ForDev/data/http/http.dart';

class MockHttpClient extends Mock implements HttpClient<List<Map>> {}

void main() {
  RemoteLoadSurveys sut;
  HttpClient httpClient;
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

  PostExpectation mockRequest() => when(httpClient.request(
        url: anyNamed('url'),
        method: anyNamed('method'),
      ));

  void mockHttpData(List<Map<String, Object>> data) {
    mockRequest().thenAnswer((_) async => data);
  }

  void mockHttpError(HttpError error) {
    mockRequest().thenThrow(error);
  }

  setUp(() {
    httpClient = MockHttpClient();
    url = faker.internet.httpUrl();
    sut = RemoteLoadSurveys(httpClient: httpClient, url: url);
    mockHttpData(list);
  });

  test('Should call HttpClient with correct values', () async {
    await sut.load();

    verify(httpClient.request(url: url, method: 'get'));
  });

  test('Should returns surveys on 200', () async {
    final surveys = await sut.load();

    expect(surveys, surveysList);
  });

   test('Should throw UnexpectedError if HttpClient returns 200 with invalid data', () async {
    mockHttpData([{'invalid':'invalid'}]);

    final future = sut.load();

    expect(future, throwsA(DomainError.unexpected));
  });

  test('Should throw UnexpectedError if HttpClient returns 404', () async {
    mockHttpError(HttpError.notFound);

    final future = sut.load();

    expect(future, throwsA(DomainError.unexpected));
  });

  
}
