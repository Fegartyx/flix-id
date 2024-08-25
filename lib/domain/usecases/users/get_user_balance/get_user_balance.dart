import 'package:flix_id/data/repositories/user_repository.dart';
import 'package:flix_id/domain/usecases/usecase.dart';
import 'package:flix_id/domain/usecases/users/get_user_balance/get_user_balance_param.dart';

import '../../../entities/result/result.dart';

class GetUserBalance implements UseCase<Result<int>, GetUserBalanceParam> {
  final UserRepository _userRepository;

  GetUserBalance({required UserRepository userRepository})
      : _userRepository = userRepository;
  @override
  Future<Result<int>> call(GetUserBalanceParam params) async =>
      _userRepository.getUserBalance(uid: params.userId);
}
