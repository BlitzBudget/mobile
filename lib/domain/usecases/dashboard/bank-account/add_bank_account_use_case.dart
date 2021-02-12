import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:mobile_blitzbudget/core/failure/failure.dart';
import 'package:mobile_blitzbudget/domain/entities/bank-account/bank_account.dart';
import 'package:mobile_blitzbudget/domain/repositories/dashboard/bank_account_repository.dart';

import '../../use_case.dart';

class AddBankAccountUseCase extends UseCase {
  AddBankAccountUseCase({@required this.bankAccountRepository});

  final BankAccountRepository bankAccountRepository;

  Future<Either<Failure, void>> add(
      {@required BankAccount addBankAccount}) async {
    return bankAccountRepository.add(addBankAccount);
  }
}
