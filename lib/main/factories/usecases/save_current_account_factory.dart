import '../../../data/usecases/usecases.dart';
import '../factories.dart';


LocalSaveCurrentAccount makeLocalSaveCurrentAccount() {
  return LocalSaveCurrentAccount(saveSecureCacheStorage: makeLocalStorageAdapter() );
}
