import 'package:flix_id/data/repositories/transaction_repository.dart';
import 'package:flix_id/data/repositories/user_repository.dart';
import 'package:flix_id/domain/entities/transaction/transaction.dart';
import 'package:flix_id/domain/usecases/transaction/create_transaction/create_transaction.dart';
import 'package:flix_id/domain/usecases/usecase.dart';
import 'package:flix_id/domain/usecases/users/top_up/top_up_param.dart';

import '../../../entities/result/result.dart';
import '../../transaction/create_transaction/create_transaction_param.dart';

class TopUp implements UseCase<Result<void>, TopUpParam> {
  final TransactionRepository _transactionRepository;

  TopUp({required TransactionRepository transactionRepository})
      : _transactionRepository = transactionRepository;
  @override
  Future<Result<void>> call(TopUpParam params) async {
    CreateTransaction createTransaction =
        CreateTransaction(transactionRepository: _transactionRepository);
    int transactionTime = DateTime.now().millisecondsSinceEpoch;

    final createTransactionResult =
        await createTransaction(CreateTransactionParam(
      transaction: Transaction(
          id: "flxtp-$transactionTime-${params.userId}",
          uid: params.userId,
          title: "Top Up",
          adminFee: 0,
          total: -params.amount,
          transactionTime: transactionTime),
    ));

    return switch (createTransactionResult) {
      Success(value: _) => Result.success(null),
      Failed(message: _) => Result.failed("failed to top up"),
    };
  }
}
