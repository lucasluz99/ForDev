import '../../helpers/errors/errors.dart';

abstract class SurveysPresenter {
  Stream<bool> get isLoadingStream;
  Future<void> loadData();
}
