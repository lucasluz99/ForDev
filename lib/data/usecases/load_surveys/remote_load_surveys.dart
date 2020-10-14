import 'package:meta/meta.dart';

import '../../../domain/helpers/helpers.dart';
import '../../http/http.dart';

class RemoteLoadSurveys {
  final HttpClient httpClient;
  final String url;

  Future<void> load(){
    try{
      httpClient.request(url: url, method: 'get');
    }catch(e){
    
    }
    
  }

  RemoteLoadSurveys({@required this.httpClient, @required this.url});
}
