import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_blitzbudget/core/failure/api_failure.dart';
import 'package:mobile_blitzbudget/core/failure/failure.dart';
import 'package:mobile_blitzbudget/core/failure/generic_failure.dart';
import 'package:mobile_blitzbudget/domain/repositories/dashboard/common/default_wallet_repository.dart';
import 'package:mobile_blitzbudget/domain/repositories/dashboard/common/delete_item_repository.dart';
import 'package:mobile_blitzbudget/domain/usecases/dashboard/budget/delete_budget_use_case.dart';
import 'package:mocktail/mocktail.dart';

class MockDeleteItemRepository extends Mock implements DeleteItemRepository {}

class MockDefaultWalletRepository extends Mock
    implements DefaultWalletRepository {}

void main() {
  late DeleteBudgetUseCase deleteBudgetUseCase;
  MockDeleteItemRepository? mockDeleteItemRepository;
  MockDefaultWalletRepository? mockDefaultWalletRepository;

  setUp(() {
    mockDeleteItemRepository = MockDeleteItemRepository();
    mockDefaultWalletRepository = MockDefaultWalletRepository();
    deleteBudgetUseCase = DeleteBudgetUseCase(
        deleteItemRepository: mockDeleteItemRepository,
        defaultWalletRepository: mockDefaultWalletRepository);
  });

  group('Delete', () {
    const budgetId = 'Budget#2021-01-06T12:51:31.215Z';
    const walletID = 'Wallet#2020-12-21T20:35:49.295Z';

    test('Success', () async {
      const Either<Failure, void> addBudgetMonad = Right<Failure, void>('');

      const Either<Failure, String> defaultWalletMonad =
          Right<Failure, String>(walletID);

      when(() => mockDefaultWalletRepository!.readDefaultWallet())
          .thenAnswer((_) => Future.value(defaultWalletMonad));
      when(() => mockDeleteItemRepository!.delete(
          walletID: walletID,
          itemID: budgetId)).thenAnswer((_) => Future.value(addBudgetMonad));

      final budgetResponse = await deleteBudgetUseCase.delete(itemID: budgetId);

      expect(budgetResponse.isRight(), true);
      verify(() => mockDeleteItemRepository!
          .delete(itemID: budgetId, walletID: walletID));
    });

    test('Failure', () async {
      const Either<Failure, String> defaultWalletMonad =
          Right<Failure, String>(walletID);
      final Either<Failure, void> deleteBudgetMonad =
          Left<Failure, void>(FetchDataFailure());

      when(() => mockDefaultWalletRepository!.readDefaultWallet())
          .thenAnswer((_) => Future.value(defaultWalletMonad));
      when(() => mockDeleteItemRepository!.delete(
          walletID: walletID,
          itemID: budgetId)).thenAnswer((_) => Future.value(deleteBudgetMonad));

      final budgetResponse = await deleteBudgetUseCase.delete(itemID: budgetId);

      expect(budgetResponse.isLeft(), true);
      verify(() => mockDeleteItemRepository!
          .delete(itemID: budgetId, walletID: walletID));
    });

    test('ReadDefaultWallet: Failure', () async {
      final Either<Failure, String> defaultWalletMonad =
          Left<Failure, String>(EmptyResponseFailure());

      when(() => mockDefaultWalletRepository!.readDefaultWallet())
          .thenAnswer((_) => Future.value(defaultWalletMonad));

      final budgetResponse = await deleteBudgetUseCase.delete(itemID: budgetId);

      final f =
          budgetResponse.fold((failure) => failure, (_) => GenericFailure());

      expect(f, EmptyResponseFailure());
      expect(budgetResponse.isLeft(), true);
      verifyNever(() => mockDeleteItemRepository!
          .delete(itemID: budgetId, walletID: walletID));
    });
  });
}
