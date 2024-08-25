import 'package:flix_id/domain/usecases/users/logout/logout.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../repositories/authentication/authentication_provider.dart';

part 'logout_provider.g.dart';

@riverpod
LogOut logout(LogoutRef ref) {
  return LogOut(authentication: ref.watch(authenticationProvider));
}
