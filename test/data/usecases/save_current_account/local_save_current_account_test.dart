import 'package:faker/faker.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'package:ForDev/domain/helpers/helpers.dart';
import 'package:ForDev/domain/entities/entities.dart';

import 'package:ForDev/data/cache/cache.dart';
import 'package:ForDev/data/usecases/usecases.dart';

class MockSaveSecureCacheStorage extends Mock
    implements SaveSecureCacheStorage {}

void main() {
  SaveSecureCacheStorage saveSecureCacheStorage;
  LocalSaveCurrentAccount sut;
  AccountEntity account;

  setUp(() {
    saveSecureCacheStorage = MockSaveSecureCacheStorage();
    sut =
        LocalSaveCurrentAccount(saveSecureCacheStorage: saveSecureCacheStorage);
    account = AccountEntity(faker.guid.guid());
  });
  test('Should call SaveSecureCacheStorage with correct values', () async {
    await sut.save(account);

    verify(
        saveSecureCacheStorage.saveSecure(key: 'token', value: account.token));
  });

  test('Should throw UnexpectedError if SaveSecureCacheStorage throws',
      () async {
    when(saveSecureCacheStorage.saveSecure(
        key: anyNamed('key'), value: anyNamed('value'))).thenThrow(DomainError.unexpected);
    final future = sut.save(account);

    expect(future, throwsA(DomainError.unexpected));
  });
}
