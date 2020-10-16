import 'package:ForDev/data/cache/cache.dart';
import 'package:faker/faker.dart';
import 'package:meta/meta.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';
import 'package:ForDev/data/http/http_client.dart';

class AuthorizeHttpClientDecorator implements HttpClient {
  final FetchSecureCacheStorage fetchSecureCacheStorage;
  final HttpClient decoratee;

  AuthorizeHttpClientDecorator({
    @required this.decoratee,
    @required this.fetchSecureCacheStorage,
  });

  Future<dynamic> request({
    @required String url,
    @required String method,
    Map headers,
    Map body,
  }) async {
    final token = await fetchSecureCacheStorage.fetchSecure('token');

    final authorizedHeaders = headers ?? {}
      ..addAll({'x-access-token': token});

   return decoratee.request(
        url: url, method: method, body: body, headers: authorizedHeaders);
  }
}

class MockHttpClient extends Mock implements HttpClient {}

class MockFetchSecureCacheStorage extends Mock
    implements FetchSecureCacheStorage {}

void main() {
  AuthorizeHttpClientDecorator sut;
  HttpClient httpClient;
  FetchSecureCacheStorage fetchSecureCacheStorage;
  String url;
  String method;
  String token;
  Map body;
  String httpResponse;

  PostExpectation mockFetchSecureCall() =>
      when(fetchSecureCacheStorage.fetchSecure(any));

  void mockFetchSecureCacheStorage() {
    mockFetchSecureCall().thenAnswer((_) async => token);
  }

  PostExpectation mockHttpClientCall() => when(httpClient.request(
      url: anyNamed('url'),
      method: anyNamed('method'),
      body: anyNamed('body'),
      headers: anyNamed('headers')));

  void mockHttpClient() {
    mockHttpClientCall().thenAnswer((_) async => httpResponse);
  }

  setUp(() {
    httpClient = MockHttpClient();
    fetchSecureCacheStorage = MockFetchSecureCacheStorage();
    sut = AuthorizeHttpClientDecorator(
      decoratee: httpClient,
      fetchSecureCacheStorage: fetchSecureCacheStorage,
    );
    url = faker.internet.httpUrl();
    method = 'get';
    body = {'any': 'any'};
    token = faker.guid.guid();
    httpResponse = faker.randomGenerator.string(50);
    mockFetchSecureCacheStorage();
    mockHttpClient();
  });
  test('Should call FetchSecureCacheStorage with correct value', () async {
    await sut.request(url: url, method: method, body: body);

    verify(fetchSecureCacheStorage.fetchSecure('token')).called(1);
  });

  test('Should call decoratee with access token on header', () async {
    await sut.request(url: url, method: method, body: body);

    verify(httpClient.request(
        url: url,
        method: method,
        body: body,
        headers: {'x-access-token': token})).called(1);

    await sut
        .request(url: url, method: method, body: body, headers: {'any': 'any'});

    verify(httpClient.request(
        url: url,
        method: method,
        body: body,
        headers: {'x-access-token': token, 'any': 'any'})).called(1);
  });

  test('Should return same result as decoratee', () async {
    final response = await sut.request(url: url, method: method, body: body);

    expect(response, httpResponse);
  });
}
