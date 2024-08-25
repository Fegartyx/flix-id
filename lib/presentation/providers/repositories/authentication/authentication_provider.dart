import 'package:flix_id/data/repositories/authentication.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../data/Firebase/firebase_authentication.dart';

part 'authentication_provider.g.dart';

@riverpod
Authentication authentication(AuthenticationRef ref) =>
    FirebaseAuthentication();

/**
 * final AutoDisposeProvider<Authentication> authenticationPro = Provider.autoDispose<Authentication>((ref) => FirebaseAuthentication());
 */
