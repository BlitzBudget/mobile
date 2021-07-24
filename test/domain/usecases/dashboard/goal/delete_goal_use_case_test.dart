import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_blitzbudget/core/failure/api_failure.dart';
import 'package:mobile_blitzbudget/core/failure/failure.dart';
import 'package:mobile_blitzbudget/core/failure/generic_failure.dart';
import 'package:mobile_blitzbudget/domain/repositories/dashboard/common/default_wallet_repository.dart';
import 'package:mobile_blitzbudget/domain/repositories/dashboard/common/delete_item_repository.dart';
import 'package:mobile_blitzbudget/domain/usecases/dashboard/goal/delete_goal_use_case.dart';
import 'package:mocktail/mocktail.dart';

class MockDeleteItemRepository extends Mock implements DeleteItemRepository {}

class MockDefaultWalletRepository extends Mock
    implements DefaultWalletRepository {}

void main() {
  late DeleteGoalUseCase deleteGoalUseCase;
  MockDeleteItemRepository? mockDeleteItemRepository;
  MockDefaultWalletRepository? mockDefaultWalletRepository;

  setUp(() {
    mockDeleteItemRepository = MockDeleteItemRepository();
    mockDefaultWalletRepository = MockDefaultWalletRepository();
    deleteGoalUseCase = DeleteGoalUseCase(
        deleteItemRepository: mockDeleteItemRepository,
        defaultWalletRepository: mockDefaultWalletRepository);
  });

  group('Delete Goal', () {
    const goalId = 'Goal#2021-01-06T12:51:31.215Z';
    const walletID = 'Wallet#2020-12-21T20:35:49.295Z';

    test('Success', () async {
      const Either<Failure, void> addGoalMonad = Right<Failure, void>('');

      const Either<Failure, String> defaultWalletMonad =
          Right<Failure, String>(walletID);

      when(() => mockDefaultWalletRepository!.readDefaultWallet())
          .thenAnswer((_) => Future.value(defaultWalletMonad));
      when(() => mockDeleteItemRepository!.delete(
          walletID: walletID,
          itemID: goalId)).thenAnswer((_) => Future.value(addGoalMonad));

      final goalResponse = await deleteGoalUseCase.delete(itemID: goalId);

      expect(goalResponse.isRight(), true);
      verify(() =>
          mockDeleteItemRepository!.delete(itemID: goalId, walletID: walletID));
    });

    test('Failure', () async {
      const Either<Failure, String> defaultWalletMonad =
          Right<Failure, String>(walletID);
      final Either<Failure, void> deleteGoalMonad =
          Left<Failure, void>(FetchDataFailure());

      when(() => mockDefaultWalletRepository!.readDefaultWallet())
          .thenAnswer((_) => Future.value(defaultWalletMonad));
      when(() => mockDeleteItemRepository!.delete(
          walletID: walletID,
          itemID: goalId)).thenAnswer((_) => Future.value(deleteGoalMonad));

      final goalResponse = await deleteGoalUseCase.delete(itemID: goalId);

      expect(goalResponse.isLeft(), true);
      verify(() =>
          mockDeleteItemRepository!.delete(itemID: goalId, walletID: walletID));
    });

    test('ReadDefaultWallet: Failure', () async {
      final Either<Failure, String> defaultWalletMonad =
          Left<Failure, String>(EmptyResponseFailure());

      when(() => mockDefaultWalletRepository!.readDefaultWallet())
          .thenAnswer((_) => Future.value(defaultWalletMonad));

      final goalResponse = await deleteGoalUseCase.delete(itemID: goalId);

      final f =
          goalResponse.fold((failure) => failure, (_) => GenericFailure());

      expect(f, EmptyResponseFailure());
      expect(goalResponse.isLeft(), true);
      verifyNever(() =>
          mockDeleteItemRepository!.delete(itemID: goalId, walletID: walletID));
    });
  });
}
