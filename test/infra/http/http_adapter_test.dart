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
    return jsonDecode(response.body);
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
    test('Shoud call post with corret values', () async {
      when(client.post(any,
              headers: anyNamed('headers'), body: anyNamed('body')))
          .thenAnswer((_) async => Response('{"any":"any"}', 200));

      await sut.request(url: url, method: 'post', body: {'any': 'any'});

      verify(client.post(url,
          headers: {
            'content-type': 'application/json',
            'accept': 'application/json'
          },
          body: '{"any":"any"}'));
    });

    test('Shoud call post without body', () async {
      when(client.post(any, headers: anyNamed('headers')))
          .thenAnswer((_) async => Response('{"any":"any"}', 200));

      await sut.request(url: url, method: 'post');

      verify(client.post(any, headers: anyNamed('headers')));
    });

    test('Shoud return data if post returns 200', () async {
      when(client.post(any, headers: anyNamed('headers')))
          .thenAnswer((_) async => Response('{"any":"any"}', 200));
      await sut.request(url: url, method: 'post');

      final result = await sut.request(url: url, method: 'post');

      expect(result, {'any': 'any'});
    });
  });
}
