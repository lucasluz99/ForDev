import '../../data/http/http.dart';
import '../../domain/entities/entities.dart';

class LocalSurveyModel {
  final String id;
  final DateTime date;
  final String question;
  final bool didAnswer;

  LocalSurveyModel({this.id, this.question, this.date, this.didAnswer});

  factory LocalSurveyModel.fromJson(Map json) {
    if (!json.keys
        .toSet()
        .containsAll(['id', 'question', 'date', 'didAnswer'])) {
      throw Exception();
    }
    return LocalSurveyModel(
      id: json['id'],
      question: json['question'],
      date: DateTime.parse(json['date']),
      didAnswer: json['didAnswer'] == 'true' ? true : false,
    );
  }

  SurveyEntity toEntity() => SurveyEntity(
      id: id, question: question, dateTime: date, didAnswer: didAnswer);
}
