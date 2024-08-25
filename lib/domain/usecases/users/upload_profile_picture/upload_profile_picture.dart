import 'package:flix_id/data/repositories/user_repository.dart';
import 'package:flix_id/domain/entities/user/user.dart';
import 'package:flix_id/domain/usecases/usecase.dart';
import 'package:flix_id/domain/usecases/users/upload_profile_picture/upload_profile_picture_param.dart';

import '../../../entities/result/result.dart';

class UploadProfilePicture
    implements UseCase<Result<User>, UploadProfilePictureParam> {
  final UserRepository _userRepository;

  UploadProfilePicture({required UserRepository userRepository})
      : _userRepository = userRepository;
  @override
  Future<Result<User>> call(UploadProfilePictureParam params) async =>
      _userRepository.uploadProfilePicture(
        imageFile: params.imageFile,
        user: params.user,
      );
}
