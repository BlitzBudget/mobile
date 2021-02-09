import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_blitzbudget/core/failure/api_failure.dart';
import 'package:mobile_blitzbudget/core/failure/failure.dart';
import 'package:mobile_blitzbudget/core/failure/generic_failure.dart';
import 'package:mobile_blitzbudget/domain/repositories/dashboard/common/default_wallet_repository.dart';
import 'package:mobile_blitzbudget/domain/repositories/dashboard/common/delete_item_repository.dart';
import 'package:mobile_blitzbudget/domain/usecases/dashboard/goal/delete_goal_use_case.dart';
import 'package:mockito/mockito.dart';

class MockDeleteItemRepository extends Mock implements DeleteItemRepository {}

class MockDefaultWalletRepository extends Mock
    implements DefaultWalletRepository {}

void main() {
  DeleteGoalUseCase deleteGoalUseCase;
  MockDeleteItemRepository mockDeleteItemRepository;
  MockDefaultWalletRepository mockDefaultWalletRepository;

  setUp(() {
    mockDeleteItemRepository = MockDeleteItemRepository();
    mockDefaultWalletRepository = MockDefaultWalletRepository();
    deleteGoalUseCase = DeleteGoalUseCase(
        deleteItemRepository: mockDeleteItemRepository,
        defaultWalletRepository: mockDefaultWalletRepository);
  });

  group('Delete Goal', () {
    final goalId = 'Goal#2021-01-06T12:51:31.215Z';
    final walletId = 'Wallet#2020-12-21T20:35:49.295Z';

    test('Success', () async {
      Either<Failure, void> addGoalMonad = Right<Failure, void>('');

      Either<Failure, String> defaultWalletMonad =
          Right<Failure, String>(walletId);

      when(mockDefaultWalletRepository.readDefaultWallet())
          .thenAnswer((_) => Future.value(defaultWalletMonad));
      when(mockDeleteItemRepository.delete(
              walletId: walletId, itemId: goalId))
          .thenAnswer((_) => Future.value(addGoalMonad));

      final goalResponse =
          await deleteGoalUseCase.delete(itemId: goalId);

      expect(goalResponse.isRight(), true);
      verify(mockDeleteItemRepository.delete(
          itemId: goalId, walletId: walletId));
    });

    test('Failure', () async {
      Either<Failure, String> defaultWalletMonad =
          Right<Failure, String>(walletId);
      Either<Failure, void> deleteGoalMonad =
          Left<Failure, void>(FetchDataFailure());

      when(mockDefaultWalletRepository.readDefaultWallet())
          .thenAnswer((_) => Future.value(defaultWalletMonad));
      when(mockDeleteItemRepository.delete(
              walletId: walletId, itemId: goalId))
          .thenAnswer((_) => Future.value(deleteGoalMonad));

      final goalResponse =
          await deleteGoalUseCase.delete(itemId: goalId);

      expect(goalResponse.isLeft(), true);
      verify(mockDeleteItemRepository.delete(
          itemId: goalId, walletId: walletId));
    });

    test('ReadDefaultWallet: Failure', () async {
      Either<Failure, String> defaultWalletMonad =
          Left<Failure, String>(EmptyResponseFailure());

      when(mockDefaultWalletRepository.readDefaultWallet())
          .thenAnswer((_) => Future.value(defaultWalletMonad));

      final goalResponse =
          await deleteGoalUseCase.delete(itemId: goalId);

      final f = goalResponse.fold((failure) => failure, (_) => GenericFailure());
      
      expect(f, EmptyResponseFailure());
      expect(goalResponse.isLeft(), true);
      verifyNever(mockDeleteItemRepository.delete(
          itemId: goalId, walletId: walletId));
    });
  });
}
