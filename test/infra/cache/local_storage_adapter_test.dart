import 'package:ForDev/data/cache/save_secure_cache_storage.dart';
import 'package:ForDev/domain/helpers/helpers.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

class LocalStorageAdapter implements SaveSecureCacheStorage {
  final FlutterSecureStorage secureStorage;

  LocalStorageAdapter({@required this.secureStorage});

  Future<void> saveSecure(
      {@required String key, @required String value}) async {
    await secureStorage.write(key: key, value: value);
  }
}

class MockFlutterSecureStorage extends Mock implements FlutterSecureStorage {}

void main() {
  FlutterSecureStorage secureStorage = MockFlutterSecureStorage();
  LocalStorageAdapter sut = LocalStorageAdapter(secureStorage: secureStorage);
  String key = 'token';
  String value = 'value';

  setUp(() {
    secureStorage = MockFlutterSecureStorage();
    sut = LocalStorageAdapter(secureStorage: secureStorage);
    key = 'token';
    value = 'value';
  });
  test('Should call saveSecure with correct values', () async {
    await sut.saveSecure(key: key, value: value);

    verify(secureStorage.write(key: key, value: value));
  });

  
}
