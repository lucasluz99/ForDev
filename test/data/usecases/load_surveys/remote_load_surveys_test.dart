import 'package:ForDev/data/http/http_error.dart';
import 'package:faker/faker.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'package:ForDev/domain/helpers/helpers.dart';
import 'package:ForDev/domain/usecases/usecases.dart';

import 'package:ForDev/data/usecases/usecases.dart';
import 'package:ForDev/data/http/http.dart';

class MockHttpClient extends Mock implements HttpClient {}

void main() {
  RemoteLoadSurveys sut;
  HttpClient httpClient;
  String url;
  Map mockValidData() =>
      {'accessToken': faker.guid.guid(), 'name': faker.person.name};

  PostExpectation mockRequest() => when(httpClient.request(
      url: anyNamed('url'),
      method: anyNamed('method'),
      body: anyNamed('body')));


  void mockHttpError(HttpError error) {
    mockRequest().thenThrow(error);
  }

  setUp(() {
    httpClient = MockHttpClient();
    url = faker.internet.httpUrl();
    sut = RemoteLoadSurveys(httpClient: httpClient, url: url);

  });

  test('Should call HttpClient with correct values', () async {
    await sut.load();

    verify(httpClient.request(url: url, method: 'get'));
  });

  test('Should throw UnexpectedError if HttpClient returns 400', () async {
    mockHttpError(HttpError.badRequest);

    final future = sut.load();

    expect(future, throwsA(DomainError.unexpected));
  });
}
