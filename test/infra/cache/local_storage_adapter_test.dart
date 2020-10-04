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
}
