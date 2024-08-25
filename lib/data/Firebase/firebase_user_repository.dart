import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flix_id/data/repositories/user_repository.dart';
import 'package:flix_id/domain/entities/result/result.dart';
import 'package:flix_id/domain/entities/user/user.dart';
import 'package:path/path.dart';

class FirebaseUserRepository implements UserRepository {
  final FirebaseFirestore _firebaseFirestore;

  FirebaseUserRepository({FirebaseFirestore? firebaseFirestore})
      : _firebaseFirestore = firebaseFirestore ?? FirebaseFirestore.instance;

  final users = FirebaseFirestore.instance
      .collection('users')
      .withConverter<User>(
        fromFirestore: (snapshot, options) => User.fromJson(snapshot.data()!),
        toFirestore: (value, options) => value.toJson(),
      );
  @override
  Future<Result<User>> createUser(
      {required String uid,
      required String email,
      required String name,
      String? photoUrl,
      int balance = 0}) async {
    /// Get the collection of users
    // CollectionReference<Map<String, dynamic>> users =
    //     _firebaseFirestore.collection('users');

    /// Set the data of the user
    User userData = User(
      uid: uid,
      email: email,
      name: name,
      photoUrl: photoUrl,
      balance: balance,
    );

    await users.doc(uid).set(userData);
    // DocumentSnapshot<Map<String, dynamic>> doc = await users.doc(uid).get();
    DocumentSnapshot<User> doc = await users.doc(uid).get();

    if (doc.exists) {
      return Result.success(doc.data()!);
    } else {
      return const Result.failed('User not found');
    }
  }

  @override
  Future<Result<User>> getUser({required String uid}) async {
    /// Get the collection of the users and access to inside where UID
    // DocumentReference<Map<String, dynamic>> docRef =
    //     _firebaseFirestore.doc('users/$uid');
    //
    // DocumentSnapshot<Map<String, dynamic>> doc = await docRef.get();

    final doc = await users.doc(uid).get();

    if (doc.exists) {
      return Result.success(doc.data()!);
    } else {
      return const Result.failed('User not found');
    }
  }

  @override
  Future<Result<int>> getUserBalance({required String uid}) async {
    DocumentReference<Map<String, dynamic>> docRef =
        _firebaseFirestore.doc('users/$uid');

    DocumentSnapshot<Map<String, dynamic>> result = await docRef.get();

    if (result.exists) {
      return Result.success(result.data()!['balance']);
    } else {
      return const Result.failed('User not found');
    }
  }

  @override
  Future<Result<User>> updateUser({required User user}) async {
    try {
      DocumentReference<Map<String, dynamic>> docRef =
          _firebaseFirestore.doc('users/${user.uid}');
      await docRef.update(user.toJson());
      DocumentSnapshot<Map<String, dynamic>> doc = await docRef.get();

      if (doc.exists) {
        User updatedUser = User.fromJson(doc.data()!);
        if (updatedUser == user) {
          return Result.success(updatedUser);
        } else {
          return const Result.failed('Update failed');
        }
      } else {
        return const Result.failed('User not found');
      }
    } on FirebaseException catch (e) {
      return Result.failed(e.message ?? 'An error occurred');
    }
  }

  @override
  Future<Result<User>> updateUserBalance(
      {required String uid, required int balance}) async {
    DocumentReference<Map<String, dynamic>> docRef =
        _firebaseFirestore.doc('users/$uid');
    DocumentSnapshot<Map<String, dynamic>> result = await docRef.get();

    if (result.exists) {
      await docRef.update({'balance': balance});
      DocumentSnapshot<Map<String, dynamic>> updatedResult = await docRef.get();
      if (updatedResult.exists) {
        User updatedUser = User.fromJson(updatedResult.data()!);
        if (updatedUser.balance == balance) {
          return Result.success(updatedUser);
        } else {
          return const Result.failed('Update failed');
        }
      } else {
        return const Result.failed('User not found');
      }
    } else {
      return const Result.failed('User not found');
    }
  }

  @override
  Future<Result<User>> uploadProfilePicture(
      {required User user, required File imageFile}) async {
    String filename = basename(imageFile.path);
    Reference ref = FirebaseStorage.instance.ref().child(filename);

    try {
      await ref.putFile(imageFile);
      String downloadUrl = await ref.getDownloadURL();

      final updateResult =
          await updateUser(user: user.copyWith(photoUrl: downloadUrl));

      if (updateResult.isSuccess) {
        return Result.success(updateResult.resultValue!);
      } else {
        return Result.failed(updateResult.errorMessage!);
      }
    } catch (e) {
      return const Result.failed('Failed to Update Profile Picture');
    }
  }
}
