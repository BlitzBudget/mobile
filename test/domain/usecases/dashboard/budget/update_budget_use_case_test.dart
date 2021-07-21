import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_blitzbudget/core/failure/api_failure.dart';
import 'package:mobile_blitzbudget/core/failure/failure.dart';
import 'package:mobile_blitzbudget/core/failure/generic_failure.dart';
import 'package:mobile_blitzbudget/data/utils/data_utils.dart';
import 'package:mobile_blitzbudget/domain/entities/budget/budget.dart';
import 'package:mobile_blitzbudget/domain/repositories/dashboard/budget_repository.dart';
import 'package:mobile_blitzbudget/domain/repositories/dashboard/common/default_wallet_repository.dart';
import 'package:mobile_blitzbudget/domain/usecases/dashboard/budget/update_budget_use_case.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockBudgetRepository extends Mock implements BudgetRepository {}

class MockDefaultWalletRepository extends Mock
    implements DefaultWalletRepository {}

void main() {
  late UpdateBudgetUseCase updateBudgetUseCase;
  MockBudgetRepository? mockBudgetRepository;
  MockDefaultWalletRepository? mockDefaultWalletRepository;

  final budgetModelAsString = fixture('models/get/budget/budget_model.json');
  final budgetModelAsJSON = jsonDecode(budgetModelAsString);
  final budget = Budget(
      walletId: budgetModelAsJSON['walletId'],
      budgetId: budgetModelAsJSON['budgetId'],
      planned: parseDynamicAsDouble(budgetModelAsJSON['planned']),
      categoryId: budgetModelAsJSON['category'],
      categoryType:
          parseDynamicAsCategoryType(budgetModelAsJSON['category_type']),
      dateMeantFor: budgetModelAsJSON['date_meant_for']);

  setUp(() {
    mockBudgetRepository = MockBudgetRepository();
    mockDefaultWalletRepository = MockDefaultWalletRepository();
    updateBudgetUseCase = UpdateBudgetUseCase(
        budgetRepository: mockBudgetRepository,
        defaultWalletRepository: mockDefaultWalletRepository);
  });

  group('Update', () {
    test('Success', () async {
      const Either<Failure, void> updateBudgetMonad = Right<Failure, void>('');

      when(() => mockBudgetRepository!.update(budget))
          .thenAnswer((_) => Future.value(updateBudgetMonad));

      final budgetResponse =
          await updateBudgetUseCase.update(updateBudget: budget);

      expect(budgetResponse.isRight(), true);
      verify(() => mockBudgetRepository!.update(budget));
    });

    test('Failure', () async {
      final Either<Failure, void> updateBudgetMonad =
          Left<Failure, void>(FetchDataFailure());

      when(() => mockBudgetRepository!.update(budget))
          .thenAnswer((_) => Future.value(updateBudgetMonad));

      final budgetResponse =
          await updateBudgetUseCase.update(updateBudget: budget);

      expect(budgetResponse.isLeft(), true);
      verify(() => mockBudgetRepository!.update(budget));
    });
  });

  group('UpdatePlanned', () {
    final budgetModel = Budget(
        walletId: budgetModelAsJSON['walletId'],
        budgetId: budgetModelAsJSON['accountId'],
        planned: parseDynamicAsDouble(budgetModelAsJSON['planned']));

    test('Success', () async {
      const Either<Failure, void> updateBudgetMonad = Right<Failure, void>('');
      final Either<Failure, String?> dateStringMonad =
          Right<Failure, String?>(budgetModel.walletId);

      when(() => mockDefaultWalletRepository!.readDefaultWallet()).thenAnswer(
          (_) => Future.value(
              dateStringMonad as Future<Either<Failure, String>>?));
      when(() => mockBudgetRepository!.update(budgetModel))
          .thenAnswer((_) => Future.value(updateBudgetMonad));

      final budgetResponse = await updateBudgetUseCase.updatePlanned(
          budgetId: budgetModel.budgetId, planned: budgetModel.planned);

      expect(budgetResponse.isRight(), true);
      verify(() => mockBudgetRepository!.update(budgetModel));
    });

    test('Failure Response: Failure', () async {
      final Either<Failure, void> updateBudgetMonad =
          Left<Failure, void>(FetchDataFailure());
      final Either<Failure, String?> dateStringMonad =
          Right<Failure, String?>(budgetModel.walletId);

      when(() => mockDefaultWalletRepository!.readDefaultWallet()).thenAnswer(
          (_) => Future.value(
              dateStringMonad as Future<Either<Failure, String>>?));
      when(() => mockBudgetRepository!.update(budgetModel))
          .thenAnswer((_) => Future.value(updateBudgetMonad));

      final budgetResponse = await updateBudgetUseCase.updatePlanned(
          budgetId: budgetModel.budgetId, planned: budgetModel.planned);
      final f =
          budgetResponse.fold((failure) => failure, (_) => GenericFailure());

      expect(f, equals(FetchDataFailure()));
      expect(budgetResponse.isLeft(), true);
      verify(() => mockBudgetRepository!.update(budgetModel));
    });

    test('Read Wallet Id Failure: Failure', () async {
      final Either<Failure, void> updateBudgetMonad =
          Left<Failure, void>(FetchDataFailure());
      final Either<Failure, String> dateStringMonad =
          Left<Failure, String>(FetchDataFailure());

      when(() => mockDefaultWalletRepository!.readDefaultWallet())
          .thenAnswer((_) => Future.value(dateStringMonad));
      when(() => mockBudgetRepository!.update(budgetModel))
          .thenAnswer((_) => Future.value(updateBudgetMonad));

      final budgetResponse = await updateBudgetUseCase.updatePlanned(
          budgetId: budgetModel.budgetId, planned: budgetModel.planned);
      final f =
          budgetResponse.fold((failure) => failure, (_) => GenericFailure());

      expect(f, equals(EmptyResponseFailure()));
      expect(budgetResponse.isLeft(), true);
      verifyNever(() => mockBudgetRepository!.update(budgetModel));
    });
  });

  group('UpdateDateMeantFor', () {
    final budgetModel = Budget(
        walletId: budgetModelAsJSON['walletId'],
        budgetId: budgetModelAsJSON['accountId'],
        dateMeantFor: budgetModelAsJSON['date_meant_for']);

    test('Success', () async {
      const Either<Failure, void> updateBudgetMonad = Right<Failure, void>('');
      final Either<Failure, String?> dateStringMonad =
          Right<Failure, String?>(budgetModel.walletId);

      when(() => mockDefaultWalletRepository!.readDefaultWallet()).thenAnswer(
          (_) => Future.value(
              dateStringMonad as Future<Either<Failure, String>>?));
      when(() => mockBudgetRepository!.update(budgetModel))
          .thenAnswer((_) => Future.value(updateBudgetMonad));

      final budgetResponse = await updateBudgetUseCase.updateDateMeantFor(
          budgetId: budgetModel.budgetId,
          dateMeantFor: budgetModel.dateMeantFor);

      expect(budgetResponse.isRight(), true);
      verify(() => mockBudgetRepository!.update(budgetModel));
    });

    test('Failure Response: Failure', () async {
      final Either<Failure, void> updateBudgetMonad =
          Left<Failure, void>(FetchDataFailure());
      final Either<Failure, String?> dateStringMonad =
          Right<Failure, String?>(budgetModel.walletId);

      when(() => mockDefaultWalletRepository!.readDefaultWallet()).thenAnswer(
          (_) => Future.value(
              dateStringMonad as Future<Either<Failure, String>>?));
      when(() => mockBudgetRepository!.update(budgetModel))
          .thenAnswer((_) => Future.value(updateBudgetMonad));

      final budgetResponse = await updateBudgetUseCase.updateDateMeantFor(
          budgetId: budgetModel.budgetId,
          dateMeantFor: budgetModel.dateMeantFor);
      final f =
          budgetResponse.fold((failure) => failure, (_) => GenericFailure());

      expect(f, equals(FetchDataFailure()));
      expect(budgetResponse.isLeft(), true);
      verify(() => mockBudgetRepository!.update(budgetModel));
    });

    test('Read Wallet Id Failure: Failure', () async {
      final Either<Failure, void> updateBudgetMonad =
          Left<Failure, void>(FetchDataFailure());
      final Either<Failure, String> dateStringMonad =
          Left<Failure, String>(FetchDataFailure());

      when(() => mockDefaultWalletRepository!.readDefaultWallet())
          .thenAnswer((_) => Future.value(dateStringMonad));
      when(() => mockBudgetRepository!.update(budgetModel))
          .thenAnswer((_) => Future.value(updateBudgetMonad));

      final budgetResponse = await updateBudgetUseCase.updateDateMeantFor(
          budgetId: budgetModel.budgetId,
          dateMeantFor: budgetModel.dateMeantFor);
      final f =
          budgetResponse.fold((failure) => failure, (_) => GenericFailure());

      expect(f, equals(EmptyResponseFailure()));
      expect(budgetResponse.isLeft(), true);
      verifyNever(() => mockBudgetRepository!.update(budgetModel));
    });
  });

  group('UpdateCategoryId', () {
    final budgetModel = Budget(
      walletId: budgetModelAsJSON['walletId'],
      budgetId: budgetModelAsJSON['accountId'],
      categoryId: budgetModelAsJSON['category'],
    );

    test('Success', () async {
      const Either<Failure, void> updateBudgetMonad = Right<Failure, void>('');
      final Either<Failure, String?> dateStringMonad =
          Right<Failure, String?>(budgetModel.walletId);

      when(() => mockDefaultWalletRepository!.readDefaultWallet()).thenAnswer(
          (_) => Future.value(
              dateStringMonad as Future<Either<Failure, String>>?));
      when(() => mockBudgetRepository!.update(budgetModel))
          .thenAnswer((_) => Future.value(updateBudgetMonad));

      final budgetResponse = await updateBudgetUseCase.updateCategoryId(
          budgetId: budgetModel.budgetId, categoryId: budgetModel.categoryId);

      expect(budgetResponse.isRight(), true);
      verify(() => mockBudgetRepository!.update(budgetModel));
    });

    test('Failure Response: Failure', () async {
      final Either<Failure, void> updateBudgetMonad =
          Left<Failure, void>(FetchDataFailure());
      final Either<Failure, String?> dateStringMonad =
          Right<Failure, String?>(budgetModel.walletId);

      when(() => mockDefaultWalletRepository!.readDefaultWallet()).thenAnswer(
          (_) => Future.value(
              dateStringMonad as Future<Either<Failure, String>>?));
      when(() => mockBudgetRepository!.update(budgetModel))
          .thenAnswer((_) => Future.value(updateBudgetMonad));

      final budgetResponse = await updateBudgetUseCase.updateCategoryId(
          budgetId: budgetModel.budgetId, categoryId: budgetModel.categoryId);
      final f =
          budgetResponse.fold((failure) => failure, (_) => GenericFailure());

      expect(f, equals(FetchDataFailure()));
      expect(budgetResponse.isLeft(), true);
      verify(() => mockBudgetRepository!.update(budgetModel));
    });

    test('Read Wallet Id Failure: Failure', () async {
      final Either<Failure, void> updateBudgetMonad =
          Left<Failure, void>(FetchDataFailure());
      final Either<Failure, String> dateStringMonad =
          Left<Failure, String>(FetchDataFailure());

      when(() => mockDefaultWalletRepository!.readDefaultWallet())
          .thenAnswer((_) => Future.value(dateStringMonad));
      when(() => mockBudgetRepository!.update(budgetModel))
          .thenAnswer((_) => Future.value(updateBudgetMonad));

      final budgetResponse = await updateBudgetUseCase.updateCategoryId(
          budgetId: budgetModel.budgetId, categoryId: budgetModel.categoryId);
      final f =
          budgetResponse.fold((failure) => failure, (_) => GenericFailure());

      expect(f, equals(EmptyResponseFailure()));
      expect(budgetResponse.isLeft(), true);
      verifyNever(() => mockBudgetRepository!.update(budgetModel));
    });
  });
}
