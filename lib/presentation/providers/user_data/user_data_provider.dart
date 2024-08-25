import 'dart:io';

import 'package:flix_id/domain/entities/result/result.dart';
import 'package:flix_id/domain/usecases/users/get_logged_in_user/get_logged_in_user.dart';
import 'package:flix_id/domain/usecases/users/logout/logout.dart';
import 'package:flix_id/domain/usecases/users/top_up/top_up.dart';
import 'package:flix_id/domain/usecases/users/upload_profile_picture/upload_profile_picture.dart';
import 'package:flix_id/presentation/providers/movie/now_playing_provider.dart';
import 'package:flix_id/presentation/providers/movie/upcoming_provider.dart';
import 'package:flix_id/presentation/providers/transaction_data/transaction_data_provider.dart';
import 'package:flix_id/presentation/providers/usecases/users/logout_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../domain/entities/user/user.dart';
import '../../../domain/usecases/users/login/login.dart';
import '../../../domain/usecases/users/login/login_params.dart';
import '../../../domain/usecases/users/register/register.dart';
import '../../../domain/usecases/users/register/register_param.dart';
import '../../../domain/usecases/users/top_up/top_up_param.dart';
import '../../../domain/usecases/users/upload_profile_picture/upload_profile_picture_param.dart';
import '../usecases/users/get_logged_in_user_provider.dart';
import '../usecases/users/login_provider.dart';
import '../usecases/users/register_provider.dart';
import '../usecases/users/top_up_provider.dart';
import '../usecases/users/upload_profile_picture_provider.dart';

part 'user_data_provider.g.dart';

@Riverpod(keepAlive: true)
class UserData extends _$UserData {
  @override
  Future<User?> build() async {
    print('build first first');
    GetLoggedInUser getLoggedInUser = ref.read(getLoggedInUserProvider);
    var userResult = await getLoggedInUser(null);

    print('userResult : $userResult');
    switch (userResult) {
      case Success(value: final user):
        _getMovies();
        return user;
      case Failed(message: _):
        return null;
    }
  }

  Future<void> login({required String email, required String password}) async {
    state = const AsyncLoading();

    Login login = ref.read(loginProvider);
    final result = await login(LoginParams(email: email, password: password));
    switch (result) {
      case Success(value: final user):
        _getMovies();
        state = AsyncData(user);
      case Failed(message: final message):
        state = AsyncError(FlutterError(message), StackTrace.current);
        state = const AsyncData(null);
    }
  }

  Future<void> register(
      {required String email,
      required String password,
      required String name,
      String? imageUrl}) async {
    state = const AsyncLoading();

    Register register = ref.read(registerProvider);
    final result = await register(RegisterParam(
        email: email, password: password, name: name, photoUrl: imageUrl));
    switch (result) {
      case Success(value: final user):
        _getMovies();
        state = AsyncData(user);
      case Failed(message: final message):
        state = AsyncError(FlutterError(message), StackTrace.current);
        state = const AsyncData(null);
    }
  }

  Future<void> refreshUserData() async {
    GetLoggedInUser getLoggedInUser = ref.read(getLoggedInUserProvider);

    final result = await getLoggedInUser(null);

    if (result is Success<User>) {
      state = AsyncData(result.value);
    }
  }

  Future<void> logout() async {
    LogOut logout = ref.read(logoutProvider);
    final result = await logout(null);

    switch (result) {
      case Success(value: final _):
        state = const AsyncData(null);
      case Failed(message: final message):
        state = AsyncError(FlutterError(message), StackTrace.current);
        state = AsyncData(state.valueOrNull);
    }
  }

  Future<void> topUp(int amount) async {
    TopUp topUp = ref.read(topUpProvider);

    String? userId = state.valueOrNull?.uid;

    if (userId != null) {
      final result = await topUp(TopUpParam(userId: userId, amount: amount));

      if (result.isSuccess) {
        refreshUserData();
        ref.read(transactionDataProvider.notifier).refreshTransactionData();
      }
    }
  }

  Future<void> uploadProfilePicture(
      {required User user, required File imageFile}) async {
    UploadProfilePicture uploadProfilePicture =
        ref.read(uploadProfilePictureProvider);

    final result = await uploadProfilePicture(
        UploadProfilePictureParam(user: user, imageFile: imageFile));

    if (result case Success(value: final user)) {
      state = AsyncData(user);
    }
  }

  void _getMovies() {
    ref.read(nowPlayingProvider.notifier).getMovies();
    ref.read(upcomingProvider.notifier).getMovies();
  }
}
