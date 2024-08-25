import 'package:flix_id/data/Firebase/firebase_transaction_repository.dart';
import 'package:flix_id/data/repositories/transaction_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'transaction_repository_provider.g.dart';

@riverpod
TransactionRepository transactionRepository(TransactionRepositoryRef ref) {
  return FirebaseTransactionRepository();
}
