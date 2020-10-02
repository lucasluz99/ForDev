import 'package:faker/faker.dart';
import 'package:flutter/foundation.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'package:ForDev/domain/entities/entities.dart';
import 'package:ForDev/domain/usecases/save_current_account.dart';

class LocalSaveCurrentAccount implements SaveCurrentAccount {
  final SaveSecureCacheStorage saveSecureCacheStorage;

  LocalSaveCurrentAccount({this.saveSecureCacheStorage});

  Future<void> save(AccountEntity account) async {
    await saveSecureCacheStorage.saveSecure(key: 'token', value: account.token);
  }
}

abstract class SaveSecureCacheStorage {
  Future<void> saveSecure({@required String key,@required String value});
}

class MockSaveSecureCacheStorage extends Mock implements SaveSecureCacheStorage {}
void main() {
  test('Should call SaveCacheStorage with correct values', () async {
    final saveSecureCacheStorage = MockSaveSecureCacheStorage();
    final sut = LocalSaveCurrentAccount(saveSecureCacheStorage:saveSecureCacheStorage);

    final account = AccountEntity(faker.guid.guid());

    await sut.save(account);

    verify(saveSecureCacheStorage.saveSecure(key: 'token',value:account.token));
  });
}
