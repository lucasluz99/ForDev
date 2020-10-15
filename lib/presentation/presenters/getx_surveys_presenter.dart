import 'package:meta/meta.dart';
import 'package:get/get.dart';

import '../../domain/usecases/usecases.dart';
import '../../ui/pages/pages.dart';

class GetxSurveysPresenter extends GetxController implements SurveysPresenter {
  final LoadSurveys loadSurveys;

  
  var _isLoading = true.obs;
  var _loadSurveys = Rx<List<SurveyViewModel>>();

  GetxSurveysPresenter({@required this.loadSurveys});

  Stream<bool> get isLoadingStream => _isLoading.stream;

  Stream<List<SurveyViewModel>> get loadSurveysStream => _loadSurveys.stream;

  Future<void> loadData() async {
     await loadSurveys.load();
  }
}
