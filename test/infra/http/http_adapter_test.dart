import 'package:ForDev/data/http/http.dart';
import 'package:faker/faker.dart';
import 'package:http/http.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'package:ForDev/infra/http/http.dart';

class MockClient extends Mock implements Client {}

void main() {
  MockClient client;
  HttpAdapter sut;
  String url;

  setUp(() {
    client = MockClient();
    sut = HttpAdapter(client);
    url = faker.internet.httpUrl();
  });

  group('shared', () {
    test('Should throw ServerError with invalid method is provided', () async {
      final future =
          sut.request(url: url, method: 'invalid_method', body: {'any': 'any'});

      expect(future, throwsA(HttpError.serverError));
    });
  });

  group('post', () {
    PostExpectation mockRequest() => when(
        client.post(any, headers: anyNamed('headers'), body: anyNamed('body')));

    void mockResponse(int statusCode, {String body = '{"any":"any"}'}) {
      mockRequest().thenAnswer((_) async => Response(body, statusCode));
    }

    void mockError() {
      mockRequest().thenThrow(Exception());
    }

    setUp(() {
      mockResponse(200);
    });
    test('Should call post with corret values', () async {
      await sut.request(url: url, method: 'post', body: {'any': 'any'});

      verify(client.post(url,
          headers: {
            'content-type': 'application/json',
            'accept': 'application/json'
          },
          body: '{"any":"any"}'));
    });

    test('Should call post without body', () async {
      await sut.request(url: url, method: 'post');

      verify(client.post(any, headers: anyNamed('headers')));
    });

    test('Should return data if post returns 200', () async {
      final result = await sut.request(url: url, method: 'post');

      expect(result, {'any': 'any'});
    });

    test('Should return null if post returns 200 with no data', () async {
      mockResponse(200, body: '');

      final result = await sut.request(url: url, method: 'post');

      expect(result, null);
    });

    test('Should return null if post returns 204 with no data', () async {
      mockResponse(204, body: '');
      await sut.request(url: url, method: 'post');

      final result = await sut.request(url: url, method: 'post');

      expect(result, null);
    });

    test('Should return null if post returns 204 with data', () async {
      mockResponse(204);
      await sut.request(url: url, method: 'post');

      final result = await sut.request(url: url, method: 'post');

      expect(result, null);
    });

    test('Should return BadRequestError if post returns 400', () async {
      mockResponse(400, body: '');

      final future = sut.request(url: url, method: 'post');

      expect(future, throwsA(HttpError.badRequest));
    });
    test('Should return BadRequestError if post returns 400', () async {
      mockResponse(400);

      final future = sut.request(url: url, method: 'post');

      expect(future, throwsA(HttpError.badRequest));
    });

    test('Should return UnauthorizedError if post returns 401', () async {
      mockResponse(401);

      final future = sut.request(url: url, method: 'post');

      expect(future, throwsA(HttpError.unauthorized));
    });

    test('Should return ForbiddenError if post returns 403', () async {
      mockResponse(403);

      final future = sut.request(url: url, method: 'post');

      expect(future, throwsA(HttpError.forbidden));
    });

    test('Should return NotFoundError if post returns 404', () async {
      mockResponse(404);

      final future = sut.request(url: url, method: 'post');

      expect(future, throwsA(HttpError.notFound));
    });
    test('Should return ServerError if post returns 500', () async {
      mockResponse(500);

      final future = sut.request(url: url, method: 'post');

      expect(future, throwsA(HttpError.serverError));
    });

    test('Should return ServerError if post throws', () async {
      mockError();

      final future = sut.request(url: url, method: 'post');

      expect(future, throwsA(HttpError.serverError));
    });
  });

  group('get', () {
    PostExpectation mockRequest() =>
        when(client.get(any, headers: anyNamed('headers')));

    void mockResponse(int statusCode, {String body = '{"any":"any"}'}) {
      mockRequest().thenAnswer((_) async => Response(body, statusCode));
    }

    void mockError() {
      mockRequest().thenThrow(Exception());
    }

    setUp(() {
      mockResponse(200);
    });
    test('Should call get with corret values', () async {
      await sut.request(url: url, method: 'get');

      verify(client.get(
        url,
        headers: {
          'content-type': 'application/json',
          'accept': 'application/json'
        },
      ));
    });

    test('Should return data if get returns 200', () async {
      final result = await sut.request(url: url, method: 'get');

      expect(result, {'any': 'any'});
    });

    test('Should return null if get returns 200 with no data', () async {
      mockResponse(200, body: '');

      final result = await sut.request(url: url, method: 'get');

      expect(result, null);
    });

    test('Should return null if get returns 204 with no data', () async {
      mockResponse(204, body: '');

      final result = await sut.request(url: url, method: 'get');

      expect(result, null);
    });

    test('Should return null if get returns 204 with data', () async {
      mockResponse(204);

      final result = await sut.request(url: url, method: 'get');

      expect(result, null);
    });

    test('Should return BadRequestError if get returns 400', () async {
      mockResponse(400, body: '');

      final future = sut.request(url: url, method: 'get');

      expect(future, throwsA(HttpError.badRequest));
    });
    test('Should return BadRequestError if get returns 400', () async {
      mockResponse(400);

      final future = sut.request(url: url, method: 'get');

      expect(future, throwsA(HttpError.badRequest));
    });

    test('Should return UnauthorizedError if get returns 401', () async {
      mockResponse(401);

      final future = sut.request(url: url, method: 'get');

      expect(future, throwsA(HttpError.unauthorized));
    });
  
    test('Should return ForbiddenError if get returns 403', () async {
      mockResponse(403);

      final future = sut.request(url: url, method: 'get');

      expect(future, throwsA(HttpError.forbidden));
    });
  
    test('Should return NotFoundError if get returns 404', () async {
      mockResponse(404);

      final future = sut.request(url: url, method: 'get');

      expect(future, throwsA(HttpError.notFound));
    });
  
     test('Should return ServerError if get returns 500', () async {
      mockResponse(500);

      final future = sut.request(url: url, method: 'get');

      expect(future, throwsA(HttpError.serverError));
    });
  
     test('Should return ServerError if get throws', () async {
      mockError();

      final future = sut.request(url: url, method: 'get');

      expect(future, throwsA(HttpError.serverError));
    });
  });
}
