import '../../../data/usecases/usecases.dart';

import '../factories.dart';


RemoteLoadSurveys makeRemoteLoadSurveys() {
  return RemoteLoadSurveys(httpClient: makeHttpAdapter(), url: 'surveys');
}
