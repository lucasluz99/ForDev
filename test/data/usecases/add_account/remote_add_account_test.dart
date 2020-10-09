import 'package:faker/faker.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'package:ForDev/data/usecases/usecases.dart';
import 'package:ForDev/data/http/http.dart';
import 'package:ForDev/data/http/http_error.dart';

import 'package:ForDev/domain/helpers/helpers.dart';
import 'package:ForDev/domain/usecases/usecases.dart';



class MockHttpClient extends Mock implements HttpClient {}

void main() {
  RemoteAddAccount sut;
  AddAccountParams params;
  HttpClient httpClient;
  String url;
  String password;

  PostExpectation mockRequest() => when(httpClient.request(
      url: anyNamed('url'),
      method: anyNamed('method'),
      body: anyNamed('body')));

  void mockHttpError(HttpError error) {
    mockRequest().thenThrow(error);
  }

  setUp(() {
    httpClient = MockHttpClient();
    password = faker.internet.password();
    params = AddAccountParams(
        email: faker.internet.email(),
        name: faker.person.name(),
        password: password,
        passwordConfirmation: password);
    url = faker.internet.httpUrl();
    sut = RemoteAddAccount(httpClient: httpClient, url: url);
  });

  test('Should call HttpClient with correct values', () async {
    await sut.add(params);

    verify(httpClient.request(url: url, method: 'post', body: {
      'email': params.email,
      'name': params.name,
      'password': params.password,
      'passwordConfirmation': params.passwordConfirmation,
    }));

    test('Should throw UnexpectedError if HttpClient returns 400', () async {
      mockHttpError(HttpError.badRequest);

      final future = sut.add(params);

      expect(future, throwsA(DomainError.unexpected));
    });
  });
}
