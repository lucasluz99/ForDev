import '../../../../presentation/presenters/presenters.dart';
import '../../../../ui/pages/pages.dart';

import '../../usecases/usecases.dart';
import 'login_validation_factory.dart';

LoginPresenter makeStreamLoginPresenter() {
  return StreamLoginPresenter(
      authentication: makeRemoteAuthenticaiton(),
      validation: makeValidationComposite());
}

LoginPresenter makeGetxLoginPresenter() {
  return GetxLoginPresenter(
      authentication: makeRemoteAuthenticaiton(),
      validation: makeValidationComposite());
}
