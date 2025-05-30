import 'package:flix_id/domain/usecases/transaction/create_transaction/create_transaction_param.dart';
import 'package:flix_id/domain/usecases/usecase.dart';

import '../../../../data/repositories/transaction_repository.dart';
import '../../../entities/result/result.dart';

class CreateTransaction
    implements UseCase<Result<void>, CreateTransactionParam> {
  final TransactionRepository _transactionRepository;

  CreateTransaction({required TransactionRepository transactionRepository})
      : _transactionRepository = transactionRepository;
  @override
  Future<Result<void>> call(CreateTransactionParam params) async {
    int transactionTime = DateTime.now().millisecondsSinceEpoch;
    final result = await _transactionRepository.createTransaction(
        transaction: params.transaction.copyWith(
      transactionTime: transactionTime,
      id: (params.transaction.id == null)
          ? "flx-$transactionTime-${params.transaction.uid}"
          : params.transaction.id,
    ));

    return switch (result) {
      Success(value: _) => Result.success(null),
      Failed(:final message) => Result.failed(message),
    };
  }
}
