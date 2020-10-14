import 'package:meta/meta.dart';

import '../../../domain/entities/entities.dart';
import '../../models/models.dart';
import '../../http/http.dart';

class RemoteLoadSurveys {
  final HttpClient<List<Map>> httpClient;
  final String url;

  Future<List<SurveyEntity>> load() async {
    final response = await httpClient.request(url: url, method: 'get');
    return response
        .map((survey) => RemoteSurveyModel.fromJson(survey).toEntity())
        .toList();
  }

  RemoteLoadSurveys({@required this.httpClient, @required this.url});
}
