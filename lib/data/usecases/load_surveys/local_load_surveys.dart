import '../../../domain/entities/entities.dart';
import '../../../domain/helpers/helpers.dart';
import '../../../domain/usecases/usecases.dart';

import '../../cache/cache.dart';
import '../../models/models.dart';

class LocalLoadSurveys implements LoadSurveys {
  final CacheStorage cacheStorage;

  LocalLoadSurveys({this.cacheStorage});

  Future<List<SurveyEntity>> load() async {
    try {
      final response = await cacheStorage.fetch('surveys');
      if (response == null || response.isEmpty) {
        throw Exception();
      }
      return response
          .map<SurveyEntity>(
              (json) => LocalSurveyModel.fromJson(json).toEntity())
          .toList();
    } catch (error) {
      throw DomainError.unexpected;
    }
  }

  Future<void> validate() async {
    final response = await cacheStorage.fetch('surveys');
    try {
      response
          .map<SurveyEntity>(
              (json) => LocalSurveyModel.fromJson(json).toEntity())
          .toList();
    }catch(error){
      await cacheStorage.delete('surveys');
    }
  }
}
