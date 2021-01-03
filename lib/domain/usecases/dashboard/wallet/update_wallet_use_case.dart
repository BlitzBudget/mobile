import 'package:dartz/dartz.dart';
import 'package:mobile_blitzbudget/core/failure/failure.dart';
import 'package:mobile_blitzbudget/domain/entities/wallet/wallet.dart';
import 'package:mobile_blitzbudget/domain/repositories/authentication/user_attributes_repository.dart';
import 'package:mobile_blitzbudget/domain/repositories/dashboard/common/default_wallet_repository.dart';
import 'package:mobile_blitzbudget/domain/repositories/dashboard/common/ends_with_date_repository.dart';
import 'package:mobile_blitzbudget/domain/repositories/dashboard/common/starts_with_date_repository.dart';
import 'package:mobile_blitzbudget/domain/repositories/dashboard/wallet_repository.dart';

class UpdateWalletUseCase {
  WalletRepository walletRepository;
  StartsWithDateRepository startsWithDateRepository;
  EndsWithDateRepository endsWithDateRepository;
  DefaultWalletRepository defaultWalletRepository;
  UserAttributesRepository userAttributesRepository;

  Future<Either<Failure, void>> update(Wallet updateWallet) async {
    return await walletRepository.update(updateWallet);
  }
}
