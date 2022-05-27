import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_blitzbudget/core/failure/api_failure.dart';
import 'package:mobile_blitzbudget/core/failure/failure.dart';
import 'package:mobile_blitzbudget/core/failure/generic_failure.dart';
import 'package:mobile_blitzbudget/domain/repositories/dashboard/common/default_wallet_repository.dart';
import 'package:mobile_blitzbudget/domain/repositories/dashboard/common/delete_item_repository.dart';
import 'package:mobile_blitzbudget/domain/usecases/dashboard/recurring-transaction/delete_recurring_transaction_use_case.dart';
import 'package:mocktail/mocktail.dart';

class MockDeleteItemRepository extends Mock implements DeleteItemRepository {}

class MockDefaultWalletRepository extends Mock
    implements DefaultWalletRepository {}

void main() {
  late DeleteRecurringTransactionUseCase deleteRecurringTransactionUseCase;
  MockDeleteItemRepository? mockDeleteItemRepository;
  MockDefaultWalletRepository? mockDefaultWalletRepository;

  setUp(() {
    mockDeleteItemRepository = MockDeleteItemRepository();
    mockDefaultWalletRepository = MockDefaultWalletRepository();
    deleteRecurringTransactionUseCase = DeleteRecurringTransactionUseCase(
        deleteItemRepository: mockDeleteItemRepository,
        defaultWalletRepository: mockDefaultWalletRepository);
  });

  group('Delete RecurringTransaction', () {
    const recurringTransactionId =
        'RecurringTransaction#2021-01-06T12:51:31.215Z';
    const walletID = 'Wallet#2020-12-21T20:35:49.295Z';

    test('Success', () async {
      const Either<Failure, void> addRecurringTransactionMonad =
          Right<Failure, void>('');

      const Either<Failure, String> defaultWalletMonad =
          Right<Failure, String>(walletID);

      when(() => mockDefaultWalletRepository!.readDefaultWallet())
          .thenAnswer((_) => Future.value(defaultWalletMonad));
      when(() => mockDeleteItemRepository!
              .delete(walletID: walletID, itemID: recurringTransactionId))
          .thenAnswer((_) => Future.value(addRecurringTransactionMonad));

      final recurringTransactionResponse =
          await deleteRecurringTransactionUseCase.delete(
              itemID: recurringTransactionId);

      expect(recurringTransactionResponse.isRight(), true);
      verify(() => mockDeleteItemRepository!
          .delete(itemID: recurringTransactionId, walletID: walletID));
    });

    test('Failure', () async {
      const Either<Failure, String> defaultWalletMonad =
          Right<Failure, String>(walletID);
      final Either<Failure, void> deleteRecurringTransactionMonad =
          Left<Failure, void>(FetchDataFailure());

      when(() => mockDefaultWalletRepository!.readDefaultWallet())
          .thenAnswer((_) => Future.value(defaultWalletMonad));
      when(() => mockDeleteItemRepository!
              .delete(walletID: walletID, itemID: recurringTransactionId))
          .thenAnswer((_) => Future.value(deleteRecurringTransactionMonad));

      final recurringTransactionResponse =
          await deleteRecurringTransactionUseCase.delete(
              itemID: recurringTransactionId);

      expect(recurringTransactionResponse.isLeft(), true);
      verify(() => mockDeleteItemRepository!
          .delete(itemID: recurringTransactionId, walletID: walletID));
    });

    test('ReadDefaultWallet: Failure', () async {
      final Either<Failure, String> defaultWalletMonad =
          Left<Failure, String>(EmptyResponseFailure());

      when(() => mockDefaultWalletRepository!.readDefaultWallet())
          .thenAnswer((_) => Future.value(defaultWalletMonad));

      final recurringTransactionResponse =
          await deleteRecurringTransactionUseCase.delete(
              itemID: recurringTransactionId);

      final f = recurringTransactionResponse.fold(
          (failure) => failure, (_) => GenericFailure());

      expect(f, EmptyResponseFailure());
      expect(recurringTransactionResponse.isLeft(), true);
      verifyNever(() => mockDeleteItemRepository!
          .delete(itemID: recurringTransactionId, walletID: walletID));
    });
  });
}
