import 'package:meta/meta.dart';

import '../../../domain/helpers/helpers.dart';
import '../../../domain/entities/entities.dart';
import '../../models/models.dart';
import '../../http/http.dart';

class RemoteLoadSurveys {
  final HttpClient<List<Map>> httpClient;
  final String url;

  Future<List<SurveyEntity>> load() async {
    try {
      final response = await httpClient.request(url: url, method: 'get');
      return response
          .map((survey) => RemoteSurveyModel.fromJson(survey).toEntity())
          .toList();
    } on HttpError catch (error) {
     return  throw error == HttpError.forbidden ? DomainError.accessDenied :  DomainError.unexpected;
    }
  }

  RemoteLoadSurveys({@required this.httpClient, @required this.url});
}
