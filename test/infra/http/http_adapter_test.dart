import 'dart:convert';

import 'package:ForDev/data/http/http_client.dart';
import 'package:faker/faker.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

class HttpAdapter implements HttpClient {
  final Client client;

  HttpAdapter(this.client);
  Future<Map> request(
      {@required String url, @required String method, Map body}) async {
    final headers = {
      'content-type': 'application/json',
      'accept': 'application/json'
    };
    final String jsonBody = body == null ? null : jsonEncode(body);
    final response = await client.post(url, headers: headers, body: jsonBody);
    if (response.statusCode == 200) {
      return response.body.isEmpty ? null : jsonDecode(response.body);
    }else {
      return null;
    }
    
  }
}

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
