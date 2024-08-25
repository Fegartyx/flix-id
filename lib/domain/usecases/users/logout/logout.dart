import 'package:flix_id/data/repositories/authentication.dart';
import 'package:flix_id/domain/usecases/usecase.dart';

import '../../../entities/result/result.dart';

class LogOut implements UseCase<Result<void>, void> {
  final Authentication _authentication;

  LogOut({required Authentication authentication})
      : _authentication = authentication;
  @override
  Future<Result<void>> call(void params) {
    return _authentication.logout();
  }
}
