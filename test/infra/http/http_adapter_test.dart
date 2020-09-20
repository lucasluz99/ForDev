import 'dart:convert';

import 'package:faker/faker.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

class HttpAdapter {
  final Client client;

  HttpAdapter(this.client);
  Future<void> request({@required String url, @required String method,Map body}) async {
    final headers = {
      'content-type': 'application/json',
      'accept': 'application/json'
    };
    await client.post(url, headers: headers,body: jsonEncode(body));
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
      await sut.request(url: url, method: 'post',body: {'any':'any'});

      verify(client.post(url, headers: {
        'content-type': 'application/json',
        'accept': 'application/json'
      },
      body: '{"any":"any"}'
      ));
    });
  });
}
