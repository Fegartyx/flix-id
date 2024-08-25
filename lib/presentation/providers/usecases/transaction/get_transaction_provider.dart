import 'package:flix_id/domain/usecases/transaction/get_transaction/get_transaction.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../repositories/transaction_repository/transaction_repository_provider.dart';

part 'get_transaction_provider.g.dart';

@riverpod
GetTransaction getTransaction(GetTransactionRef ref) {
  return GetTransaction(
      transactionRepository: ref.watch(transactionRepositoryProvider));
}
