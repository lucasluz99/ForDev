import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import '../../domain/usecases/usecases.dart';
import '../../ui/pages/pages.dart';


class GetxSplashPresenter implements SplashPresenter {
  LoadCurrentAccount loadCurrentAccount;

  GetxSplashPresenter({@required this.loadCurrentAccount});

  var _navigateTo = RxString();

  Stream<String> get navigateToStream => _navigateTo.stream;

  Future<void> checkCurrentAccount({int milliseconds = 1700}) async {
    await Future.delayed(Duration(milliseconds: milliseconds));
    try {
      final account = await loadCurrentAccount.load();
      _navigateTo.value = account?.token == null ? '/login' : '/surveys';
    } catch (e) {
      _navigateTo.value = '/login';
    }
  }
}