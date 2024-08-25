import 'package:flix_id/data/repositories/authentication.dart';
import 'package:flix_id/data/repositories/user_repository.dart';
import 'package:flix_id/domain/entities/result/result.dart';
import 'package:flix_id/domain/entities/user/user.dart';
import 'package:flix_id/domain/usecases/usecase.dart';
import 'package:flix_id/domain/usecases/users/login/login_params.dart';

class Login implements UseCase<Result<User>, LoginParams> {
  final Authentication authentication;
  final UserRepository userRepository;

  Login({required this.authentication, required this.userRepository});

  @override
  Future<Result<User>> call(LoginParams params) async {
    final idResult = await authentication.login(
        email: params.email, password: params.password);

    if (idResult is Success) {
      final userResult =
          await userRepository.getUser(uid: idResult.resultValue!);

      return switch (userResult) {
        Success(value: final user) => Result.success(user),
        Failed(message: final msg) => Result.failed(msg),
      };
    } else {
      return Result.failed(idResult.errorMessage!);
    }
  }
}
