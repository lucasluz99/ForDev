import 'package:faker/faker.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'package:ForDev/domain/entities/entities.dart';
import 'package:ForDev/domain/usecases/usecases.dart';
import 'package:ForDev/presentation/presentation.dart';


class MockLoadCurrentAccount extends Mock implements LoadCurrentAccount {}

void main() {
  LoadCurrentAccount loadCurrentAccount;
  GetxSplashPresenter sut;

  void mockLoadCurrentAccount({AccountEntity account}) {
    when(loadCurrentAccount.load()).thenAnswer((_) async => account);
  }

  void mockLoadCurrentAccountError() {
    when(loadCurrentAccount.load()).thenThrow(Exception());
  }

  setUp(() {
    loadCurrentAccount = MockLoadCurrentAccount();
    sut = GetxSplashPresenter(loadCurrentAccount: loadCurrentAccount);
    mockLoadCurrentAccount(account: AccountEntity(faker.guid.guid()));
  });
  test('Should call LoadCurrentAccount', () async {
    await sut.checkCurrentAccount(milliseconds: 0);

    verify(loadCurrentAccount.load()).called(1);
  });

  test('Should go to surveys page on success', () async {
    sut.navigateToStream
        .listen((expectAsync1((page) => expect(page, '/surveys'))));

    await sut.checkCurrentAccount(milliseconds: 0);
  });

  test('Should go to login page on null result', () async {
    mockLoadCurrentAccount(account: null);
    sut.navigateToStream
        .listen((expectAsync1((page) => expect(page, '/login'))));

    await sut.checkCurrentAccount();
  });

   test('Should go to login page on null token', () async {
    mockLoadCurrentAccount(account: AccountEntity(null));
    sut.navigateToStream
        .listen((expectAsync1((page) => expect(page, '/login'))));

    await sut.checkCurrentAccount();
  });

  test('Should go to login page on fails', () async {
    mockLoadCurrentAccountError();
    sut.navigateToStream
        .listen((expectAsync1((page) => expect(page, '/login'))));

    await sut.checkCurrentAccount(milliseconds: 0);
  });
}
