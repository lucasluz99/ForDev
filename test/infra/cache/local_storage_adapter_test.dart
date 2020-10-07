import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'package:ForDev/infra/cache/cache.dart';

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

  group('SaveSecure', () {
    test('Should call saveSecure with correct values', () async {
      await sut.saveSecure(key: key, value: value);

      verify(secureStorage.write(key: key, value: value));
    });

    test('Should throw if saveSecure throws', () async {
      when(secureStorage.write(key: anyNamed('key'), value: anyNamed('value')))
          .thenThrow(Exception());
      final future = sut.saveSecure(key: key, value: value);

      expect(future, throwsA(TypeMatcher<Exception>()));
    });
  });

  group('fetchSecure', () {
    test('Should call fetchSecure with correct value', () async {
      await sut.fetchSecure(key);

      verify(secureStorage.read(key: key));
    });

    test('Should return correct value on success', () async {
      when(secureStorage.read(key: anyNamed('key')))
          .thenAnswer((_) async => value);
      final fetchedValue = await sut.fetchSecure(key);

      expect(fetchedValue, value);
    });

    test('Should throw if fetchSecure throws', () async {
      when(secureStorage.read(key: anyNamed('key'))).thenThrow(Exception());
      final future = sut.fetchSecure(key);

      expect(future, throwsA(TypeMatcher<Exception>()));
    });
  });
}
