import 'package:flix_id/data/Firebase/firebase_user_repository.dart';
import 'package:flix_id/data/repositories/transaction_repository.dart';
import 'package:flix_id/domain/entities/result/result.dart';
import 'package:flix_id/domain/entities/transaction/transaction.dart';

import 'package:cloud_firestore/cloud_firestore.dart' as firestore;

class FirebaseTransactionRepository implements TransactionRepository {
  final firestore.FirebaseFirestore _firestore;

  FirebaseTransactionRepository(
      {firestore.FirebaseFirestore? firebaseFirestore})
      : _firestore = firebaseFirestore ?? firestore.FirebaseFirestore.instance;

  final transactions = firestore.FirebaseFirestore.instance
      .collection('transactions')
      .withConverter<Transaction>(
        fromFirestore: (snapshot, options) =>
            Transaction.fromJson(snapshot.data()!),
        toFirestore: (value, options) => value.toJson(),
      );
  @override
  Future<Result<Transaction>> createTransaction(
      {required Transaction transaction}) async {
    try {
      final balanceResult =
          await FirebaseUserRepository().getUserBalance(uid: transaction.uid);

      if (balanceResult.isSuccess) {
        int previousBalance = balanceResult.resultValue!;

        if (previousBalance - transaction.total >= 0) {
          await transactions.doc(transaction.id).set(transaction);
          final result = await transactions.doc(transaction.id).get();

          if (result.exists) {
            await FirebaseUserRepository().updateUserBalance(
                uid: transaction.uid,
                balance: previousBalance - transaction.total);
            return Result.success(result.data()!);
          } else {
            return const Result.failed("Failed To Create Transaction Data");
          }
        } else {
          return const Result.failed("Insufficient Balance");
        }
      } else {
        return const Result.failed("Failed To Create Transaction Data");
      }
    } catch (e) {
      return const Result.failed("Failed To Create Transaction Data");
    }
  }

  @override
  Future<Result<List<Transaction>>> getUserTransactions(
      {required String uid}) async {
    try {
      final result = await transactions.where('uid', isEqualTo: uid).get();

      if (result.docs.isNotEmpty) {
        List<Transaction> transactions =
            result.docs.map((e) => e.data()).toList();
        return Result.success(transactions);
      } else {
        return const Result.success([]);
      }
    } catch (e) {
      return Result.failed('Failed To Get User Transactions Data');
    }
  }
}
