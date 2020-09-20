import 'package:faker/faker.dart';
import 'package:http/http.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'package:ForDev/infra/http/http_adapter.dart';



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

  group('post', () {
    PostExpectation mockRequest() => when(
        client.post(any, headers: anyNamed('headers'), body: anyNamed('body')));

    void mockResponse(int statusCode, {String body = '{"any":"any"}'}) {
      mockRequest().thenAnswer((_) async => Response(body, statusCode));
    }

    setUp(() {
      mockResponse(200);
    });
    test('Shoud call post with corret values', () async {
      await sut.request(url: url, method: 'post', body: {'any': 'any'});

      verify(client.post(url,
          headers: {
            'content-type': 'application/json',
            'accept': 'application/json'
          },
          body: '{"any":"any"}'));
    });

    test('Shoud call post without body', () async {
      await sut.request(url: url, method: 'post');

      verify(client.post(any, headers: anyNamed('headers')));
    });

    test('Shoud return data if post returns 200', () async {
      await sut.request(url: url, method: 'post');

      final result = await sut.request(url: url, method: 'post');

      expect(result, {'any': 'any'});
    });

    test('Shoud return null if post returns 200 with no data', () async {
      mockResponse(200, body: '');
      await sut.request(url: url, method: 'post');

      final result = await sut.request(url: url, method: 'post');

      expect(result, null);
    });

    test('Shoud return null if post returns 204 with no data', () async {
      mockResponse(204, body: '');
      await sut.request(url: url, method: 'post');

      final result = await sut.request(url: url, method: 'post');

      expect(result, null);
    });

    test('Shoud return null if post returns 204 with data', () async {
      mockResponse(204);
      await sut.request(url: url, method: 'post');

      final result = await sut.request(url: url, method: 'post');

      expect(result, null);
    });
  });
}
