import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_blitzbudget/core/failure/api_failure.dart';
import 'package:mobile_blitzbudget/core/failure/failure.dart';
import 'package:mobile_blitzbudget/data/utils/data_utils.dart';
import 'package:mobile_blitzbudget/domain/entities/bank-account/bank_account.dart';
import 'package:mobile_blitzbudget/domain/repositories/dashboard/bank_account_repository.dart';
import 'package:mobile_blitzbudget/domain/usecases/dashboard/bank-account/add_bank_account_use_case.dart';
import 'package:mockito/mockito.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockBankAccountRepository extends Mock implements BankAccountRepository {}

void main() {
  AddBankAccountUseCase addBankAccountUseCase;
  MockBankAccountRepository mockBankAccountRepository;

  final bankAccountModelAsString =
      fixture('models/get/bank-account/bank_account_model.json');
  final bankAccountModelAsJSON =
      jsonDecode(bankAccountModelAsString) as Map<String, dynamic>;
  final bankAccount = BankAccount(
      walletId: bankAccountModelAsJSON['walletId'] as String,
      accountId: bankAccountModelAsJSON['accountId'] as String,
      accountBalance:
          parseDynamicAsDouble(bankAccountModelAsJSON['account_balance']),
      bankAccountName: bankAccountModelAsJSON['bank_account_name'] as String,
      accountType:
          parseDynamicAsAccountType(bankAccountModelAsJSON['account_type']),
      accountSubType: parseDynamicAsAccountSubType(
          bankAccountModelAsJSON['account_sub_type']),
      selectedAccount: bankAccountModelAsJSON['selected_account'] as bool,
      linked: bankAccountModelAsJSON['linked'] as bool);

  setUp(() {
    mockBankAccountRepository = MockBankAccountRepository();
    addBankAccountUseCase = AddBankAccountUseCase(
        bankAccountRepository: mockBankAccountRepository);
  });

  group('Add', () {
    test('Success', () async {

      Either<Failure, void> addBankAccountMonad = Right<Failure, void>('');

      when(mockBankAccountRepository.add(bankAccount))
          .thenAnswer((_) => Future.value(addBankAccountMonad));

      final bankAccountResponse = await addBankAccountUseCase.add(addBankAccount: bankAccount);

      expect(bankAccountResponse.isRight(), true);
      verify(mockBankAccountRepository.add(bankAccount));
    });

    test('Failure', () async {

      Either<Failure, void> addBankAccountMonad = Left<Failure, void>(FetchDataFailure());

      when(mockBankAccountRepository.add(bankAccount))
          .thenAnswer((_) => Future.value(addBankAccountMonad));

      final bankAccountResponse = await addBankAccountUseCase.add(addBankAccount: bankAccount);

      expect(bankAccountResponse.isLeft(), true);
      verify(mockBankAccountRepository.add(bankAccount));
    });
  });
}
