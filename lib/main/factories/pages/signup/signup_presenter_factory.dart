import '../../../../presentation/presenters/presenters.dart';
import '../../../../ui/pages/pages.dart';

import '../../usecases/usecases.dart';
import 'signup_validation_factory.dart';

/*LoginPresenter makeStreamLoginPresenter() {
  return StreamLoginPresenter(
      authentication: makeRemoteAuthenticaiton(),
      validation: makeValidationComposite());
}*/

SignUpPresenter makeGetxSignUpPresenter() {
  return GetxSignUpPresenter(
      addAccount: makeRemoteAddAccount(),
      saveCurrentAccount: makeLocalSaveCurrentAccount(),
      validation: makeSignUpValidationComposite());
}
