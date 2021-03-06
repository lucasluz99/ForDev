import 'package:ForDev/domain/helpers/domain_error.dart';
import 'package:ForDev/ui/helpers/errors/errors.dart';
import 'package:intl/intl.dart';
import 'package:meta/meta.dart';
import 'package:get/get.dart';

import '../../domain/usecases/usecases.dart';
import '../../ui/pages/pages.dart';

class GetxSurveysPresenter extends GetxController implements SurveysPresenter {
  final LoadSurveys loadSurveys;

  var _isLoading = true.obs;
  var _surveys = Rx<List<SurveyViewModel>>();

  GetxSurveysPresenter({@required this.loadSurveys});

  Stream<bool> get isLoadingStream => _isLoading.stream;

  Stream<List<SurveyViewModel>> get surveysStream => _surveys.stream;

  Future<void> loadData() async {
    try {
      _isLoading.value = true;
      final surveys = await loadSurveys.load();
      _surveys.value = surveys
          .map((survey) => SurveyViewModel(
              id: survey.id,
              question: survey.question,
              date: DateFormat('dd MMM yyyy').format(survey.dateTime),
              didAnswer: survey.didAnswer))
          .toList();
    } on DomainError {
      _surveys.subject.addError(UiError.unexpected.description);
    } finally {
      _isLoading.value = false;
    }
  }
}
