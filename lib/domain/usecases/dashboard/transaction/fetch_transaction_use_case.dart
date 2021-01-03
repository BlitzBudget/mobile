import 'package:dartz/dartz.dart';
import 'package:mobile_blitzbudget/core/failure/failure.dart';
import 'package:mobile_blitzbudget/core/utils/utils.dart';
import 'package:mobile_blitzbudget/domain/entities/response/transaction_response.dart';
import 'package:mobile_blitzbudget/domain/repositories/authentication/user_attributes_repository.dart';
import 'package:mobile_blitzbudget/domain/repositories/dashboard/common/default_wallet_repository.dart';
import 'package:mobile_blitzbudget/domain/repositories/dashboard/common/ends_with_date_repository.dart';
import 'package:mobile_blitzbudget/domain/repositories/dashboard/common/starts_with_date_repository.dart';
import 'package:mobile_blitzbudget/domain/repositories/dashboard/transaction/transaction_repository.dart';

class FetchTransactionUseCase {
  TransactionRepository transactionRepository;
  StartsWithDateRepository startsWithDateRepository;
  EndsWithDateRepository endsWithDateRepository;
  DefaultWalletRepository defaultWalletRepository;
  UserAttributesRepository userAttributesRepository;

  Future<Either<Failure, TransactionResponse>> getTransaction() async {
    var startsWithDate = await startsWithDateRepository.readStartsWithDate();
    var endsWithDate = await endsWithDateRepository.readEndsWithDate();
    var defaultWallet = await defaultWalletRepository.readDefaultWallet();
    String userId;

    /// Get User id only when the default wallet is empty
    if (isEmpty(defaultWallet)) {
      var user = await userAttributesRepository.readUserAttributes();
      userId = user.userId;
    }

    return await transactionRepository.get(
        startsWithDate, endsWithDate, defaultWallet, userId);

    // TODO if default wallet is empty then store them
  }
}
