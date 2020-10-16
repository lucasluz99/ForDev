import '../../../../presentation/presentation.dart';
import '../../usecases/usecases.dart';

GetxSurveysPresenter makeGetxSurveysPresenter() =>
    GetxSurveysPresenter(loadSurveys: makeRemoteLoadSurveys());
