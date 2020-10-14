import '../../domain/entities/entities.dart';

import '../http/http.dart';

class RemoteSurveyModel {
  final String id;
  final String question;
  final DateTime dateTime;
  final bool didAnswer;

  RemoteSurveyModel({this.id, this.question, this.dateTime, this.didAnswer});

  factory RemoteSurveyModel.fromJson(Map json) {
    if (!json.keys.toSet().containsAll(['id','question','date','didAnswer'])) {
      throw HttpError.invalidData;
    }
    return RemoteSurveyModel(
      id: json['id'],
      question: json['question'],
      dateTime: DateTime.parse(json['date']),
      didAnswer: json['didAnswer'],
    );
  }

  SurveyEntity toEntity() => SurveyEntity(
        id: id,
        question: question,
        dateTime: dateTime,
        didAnswer: didAnswer,
      );
}
