import 'package:ForDev/data/usecases/save_current_account/local_save_current_account.dart';
import 'package:ForDev/domain/usecases/usecases.dart';
import 'package:ForDev/ui/pages/splash/splash.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

class GetxSplashPresenter implements SplashPresenter {
  LoadCurrentAccount loadCurrentAccount;

  GetxSplashPresenter({@required this.loadCurrentAccount});

  var _navigateTo = RxString();

  Stream<String> get navigateToStream => _navigateTo.stream;

  Future<void> checkCurrentAccount() async {
    await loadCurrentAccount.load();
  }
}

class MockLoadCurrentAccount extends Mock implements LoadCurrentAccount {}

void main() {
  LoadCurrentAccount loadCurrentAccount;
  GetxSplashPresenter sut;

  setUp(() {
    loadCurrentAccount = MockLoadCurrentAccount();
    sut = GetxSplashPresenter(loadCurrentAccount: loadCurrentAccount);
  });
  test('Should call LoadCurrentAccount', () async {
    await sut.checkCurrentAccount();

    verify(loadCurrentAccount.load()).called(1);
  });
}
