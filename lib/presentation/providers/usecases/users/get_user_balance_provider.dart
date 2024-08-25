import 'package:flix_id/domain/usecases/users/get_user_balance/get_user_balance.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../repositories/user_repository/user_repository_provider.dart';

part 'get_user_balance_provider.g.dart';

@riverpod
GetUserBalance getUserBalance(GetUserBalanceRef ref) {
  return GetUserBalance(
    userRepository: ref.watch(userRepositoryProvider),
  );
}
