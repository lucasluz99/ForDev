import '../../../../presentation/presenters/stream_login_presenter.dart';
import '../../../../ui/pages/pages.dart';

import '../../usecases/usecases.dart';
import 'login_validation_factory.dart';

LoginPresenter makeLoginPresenter() {
  return StreamLoginPresenter(
      authentication: makeRemoteAuthenticaiton(),
      validation: makeValidationComposite());
}
