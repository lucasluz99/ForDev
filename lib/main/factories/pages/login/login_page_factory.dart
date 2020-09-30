import 'package:ForDev/data/usecases/usecases.dart';
import 'package:flutter/material.dart';

import '../../../../ui/pages/pages.dart';
import '../../factories.dart';

Widget makeLoginPage() {
  return LoginPage(makeLoginPresenter());
}
