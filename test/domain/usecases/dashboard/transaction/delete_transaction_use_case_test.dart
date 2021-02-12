import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_blitzbudget/core/failure/api_failure.dart';
import 'package:mobile_blitzbudget/core/failure/failure.dart';
import 'package:mobile_blitzbudget/core/failure/generic_failure.dart';
import 'package:mobile_blitzbudget/domain/repositories/dashboard/common/default_wallet_repository.dart';
import 'package:mobile_blitzbudget/domain/repositories/dashboard/common/delete_item_repository.dart';
import 'package:mobile_blitzbudget/domain/usecases/dashboard/transaction/delete_transaction_use_case.dart';
import 'package:mockito/mockito.dart';

class MockDeleteItemRepository extends Mock implements DeleteItemRepository {}

class MockDefaultWalletRepository extends Mock
    implements DefaultWalletRepository {}

void main() {
  DeleteTransactionUseCase deleteTransactionUseCase;
  MockDeleteItemRepository mockDeleteItemRepository;
  MockDefaultWalletRepository mockDefaultWalletRepository;

  setUp(() {
    mockDeleteItemRepository = MockDeleteItemRepository();
    mockDefaultWalletRepository = MockDefaultWalletRepository();
    deleteTransactionUseCase = DeleteTransactionUseCase(
        deleteItemRepository: mockDeleteItemRepository,
        defaultWalletRepository: mockDefaultWalletRepository);
  });

  group('Delete Transaction', () {
    const transactionId = 'Transaction#2021-01-06T12:51:31.215Z';
    const walletId = 'Wallet#2020-12-21T20:35:49.295Z';

    test('Success', () async {
      const Either<Failure, void> addTransactionMonad = Right<Failure, void>('');

      const Either<Failure, String> defaultWalletMonad =
          Right<Failure, String>(walletId);

      when(mockDefaultWalletRepository.readDefaultWallet())
          .thenAnswer((_) => Future.value(defaultWalletMonad));
      when(mockDeleteItemRepository.delete(
              walletId: walletId, itemId: transactionId))
          .thenAnswer((_) => Future.value(addTransactionMonad));

      final transactionResponse =
          await deleteTransactionUseCase.delete(itemId: transactionId);

      expect(transactionResponse.isRight(), true);
      verify(mockDeleteItemRepository.delete(
          itemId: transactionId, walletId: walletId));
    });

    test('Failure', () async {
      const Either<Failure, String> defaultWalletMonad =
          Right<Failure, String>(walletId);
      final Either<Failure, void> deleteTransactionMonad =
          Left<Failure, void>(FetchDataFailure());

      when(mockDefaultWalletRepository.readDefaultWallet())
          .thenAnswer((_) => Future.value(defaultWalletMonad));
      when(mockDeleteItemRepository.delete(
              walletId: walletId, itemId: transactionId))
          .thenAnswer((_) => Future.value(deleteTransactionMonad));

      final transactionResponse =
          await deleteTransactionUseCase.delete(itemId: transactionId);

      expect(transactionResponse.isLeft(), true);
      verify(mockDeleteItemRepository.delete(
          itemId: transactionId, walletId: walletId));
    });

    test('ReadDefaultWallet: Failure', () async {
      final Either<Failure, String> defaultWalletMonad =
          Left<Failure, String>(EmptyResponseFailure());

      when(mockDefaultWalletRepository.readDefaultWallet())
          .thenAnswer((_) => Future.value(defaultWalletMonad));

      final transactionResponse =
          await deleteTransactionUseCase.delete(itemId: transactionId);

      final f = transactionResponse.fold(
          (failure) => failure, (_) => GenericFailure());

      expect(f, EmptyResponseFailure());
      expect(transactionResponse.isLeft(), true);
      verifyNever(mockDeleteItemRepository.delete(
          itemId: transactionId, walletId: walletId));
    });
  });
}
