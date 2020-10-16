import 'package:meta/meta.dart';

import '../../data/cache/cache.dart';
import '../../data/http/http.dart';

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
    try {
      final token = await fetchSecureCacheStorage.fetchSecure('token');

      final authorizedHeaders = headers ?? {}
        ..addAll({'x-access-token': token});

      return decoratee.request(
          url: url, method: method, body: body, headers: authorizedHeaders);
    } on HttpError {
      rethrow;
    } catch (error) {
      throw HttpError.forbidden;
    }
  }
}