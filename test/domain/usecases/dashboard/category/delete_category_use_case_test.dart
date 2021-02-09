import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_blitzbudget/core/failure/api_failure.dart';
import 'package:mobile_blitzbudget/core/failure/failure.dart';
import 'package:mobile_blitzbudget/core/failure/generic_failure.dart';
import 'package:mobile_blitzbudget/domain/repositories/dashboard/category_repository.dart';
import 'package:mobile_blitzbudget/domain/repositories/dashboard/common/default_wallet_repository.dart';
import 'package:mobile_blitzbudget/domain/usecases/dashboard/category/delete_category_use_case.dart';
import 'package:mockito/mockito.dart';

class MockCategoryRepository extends Mock implements CategoryRepository {}

class MockDefaultWalletRepository extends Mock
    implements DefaultWalletRepository {}

void main() {
  DeleteCategoryUseCase deleteCategoryUseCase;
  MockCategoryRepository mockCategoryRepository;
  MockDefaultWalletRepository mockDefaultWalletRepository;

  setUp(() {
    mockCategoryRepository = MockCategoryRepository();
    mockDefaultWalletRepository = MockDefaultWalletRepository();
    deleteCategoryUseCase = DeleteCategoryUseCase(
        categoryRepository: mockCategoryRepository,
        defaultWalletRepository: mockDefaultWalletRepository);
  });

  group('Delete', () {
    final categoryId = 'Category#2021-01-06T12:51:31.215Z';
    final walletId = 'Wallet#2020-12-21T20:35:49.295Z';

    test('Success', () async {
      Either<Failure, void> addCategoryMonad = Right<Failure, void>('');

      Either<Failure, String> defaultWalletMonad =
          Right<Failure, String>(walletId);

      when(mockDefaultWalletRepository.readDefaultWallet())
          .thenAnswer((_) => Future.value(defaultWalletMonad));
      when(mockCategoryRepository.delete(
              walletId: walletId, category: categoryId))
          .thenAnswer((_) => Future.value(addCategoryMonad));

      final categoryResponse =
          await deleteCategoryUseCase.delete(itemId: categoryId);

      expect(categoryResponse.isRight(), true);
      verify(mockCategoryRepository.delete(
          category: categoryId, walletId: walletId));
    });

    test('Failure', () async {
      Either<Failure, String> defaultWalletMonad =
          Right<Failure, String>(walletId);
      Either<Failure, void> deleteCategoryMonad =
          Left<Failure, void>(FetchDataFailure());

      when(mockDefaultWalletRepository.readDefaultWallet())
          .thenAnswer((_) => Future.value(defaultWalletMonad));
      when(mockCategoryRepository.delete(
              walletId: walletId, category: categoryId))
          .thenAnswer((_) => Future.value(deleteCategoryMonad));

      final categoryResponse =
          await deleteCategoryUseCase.delete(itemId: categoryId);

      expect(categoryResponse.isLeft(), true);
      verify(mockCategoryRepository.delete(
          category: categoryId, walletId: walletId));
    });

    test('ReadDefaultWallet: Failure', () async {
      Either<Failure, String> defaultWalletMonad =
          Left<Failure, String>(EmptyResponseFailure());

      when(mockDefaultWalletRepository.readDefaultWallet())
          .thenAnswer((_) => Future.value(defaultWalletMonad));

      final categoryResponse =
          await deleteCategoryUseCase.delete(itemId: categoryId);

      final f =categoryResponse.fold((failure) => failure, (_) => GenericFailure());
      
      expect(f, EmptyResponseFailure());
      expect(categoryResponse.isLeft(), true);
      verifyNever(mockCategoryRepository.delete(
          category: categoryId, walletId: walletId));
    });
  });
}
