import '../../domain/entities/entities.dart';

class AccountModel{
  final String accessToken;

  AccountModel(this.accessToken);

 factory AccountModel.fromJson(Map json){
   return AccountModel(json['accessToken']);
 }

 AccountEntity toEntity() => AccountEntity(accessToken); 
}