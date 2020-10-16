import 'package:ForDev/data/cache/cache.dart';
import 'package:faker/faker.dart';
import 'package:meta/meta.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';
import 'package:ForDev/data/http/http_client.dart';

class AuthorizeHttpClientDecorator implements HttpClient {
  final FetchSecureCacheStorage fetchSecureCacheStorage;
  final HttpClient httpClient;

  AuthorizeHttpClientDecorator({
    @required this.httpClient,
    @required this.fetchSecureCacheStorage,
  });

  Future<dynamic> request({
    @required String url,
    @required String method,
    Map headers,
    Map body,
  }) async {
    await fetchSecureCacheStorage.fetchSecure('token');
  }
}

class MockHttpClient extends Mock implements HttpClient {}

class MockFetchSecureCacheStorage extends Mock
    implements FetchSecureCacheStorage {}

void main() {
  AuthorizeHttpClientDecorator sut;
  HttpClient httpClient;
  FetchSecureCacheStorage fetchSecureCacheStorage;

  setUp(() {
    httpClient = MockHttpClient();
    fetchSecureCacheStorage = MockFetchSecureCacheStorage();
    sut = AuthorizeHttpClientDecorator(
      httpClient: httpClient,
      fetchSecureCacheStorage: fetchSecureCacheStorage,
    );
  });
  test('Should call FetchSecureCacheStorage with correct value', () async {
    await sut.request(url: faker.internet.httpUrl(), method: 'get');

    verify(fetchSecureCacheStorage.fetchSecure('token')).called(1);
  });
}
