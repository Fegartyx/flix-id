import 'package:flix_id/domain/entities/result/result.dart';
import 'package:flix_id/domain/entities/transaction/transaction.dart';
import 'package:flix_id/domain/usecases/transaction/get_transaction/get_transaction_param.dart';
import 'package:flix_id/domain/usecases/usecase.dart';

import '../../../../data/repositories/transaction_repository.dart';

class GetTransaction
    implements UseCase<Result<List<Transaction>>, GetTransactionParam> {
  final TransactionRepository _transactionRepository;

  GetTransaction({required TransactionRepository transactionRepository})
      : _transactionRepository = transactionRepository;
  @override
  Future<Result<List<Transaction>>> call(GetTransactionParam params) async {
    final result =
        await _transactionRepository.getUserTransactions(uid: params.uid);

    return switch (result) {
      Success(value: final transaction) => Result.success(transaction),
      Failed(:final message) => Result.failed(message),
    };
  }
}
