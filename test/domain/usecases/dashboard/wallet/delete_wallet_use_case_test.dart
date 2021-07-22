import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_blitzbudget/core/failure/api_failure.dart';
import 'package:mobile_blitzbudget/core/failure/failure.dart';
import 'package:mobile_blitzbudget/core/failure/generic_failure.dart';
import 'package:mobile_blitzbudget/domain/entities/user.dart';
import 'package:mobile_blitzbudget/domain/repositories/authentication/user_attributes_repository.dart';
import 'package:mobile_blitzbudget/domain/repositories/dashboard/wallet_repository.dart';
import 'package:mobile_blitzbudget/domain/usecases/dashboard/wallet/delete_wallet_use_case.dart';
import 'package:mocktail/mocktail.dart';

class MockWalletRepository extends Mock implements WalletRepository {}

class MockUserAttributesRepository extends Mock
    implements UserAttributesRepository {}

void main() {
  late DeleteWalletUseCase deleteWalletUseCase;
  MockWalletRepository? mockWalletRepository;
  MockUserAttributesRepository? mockUserAttributesRepository;

  setUp(() {
    mockWalletRepository = MockWalletRepository();
    mockUserAttributesRepository = MockUserAttributesRepository();
    deleteWalletUseCase = DeleteWalletUseCase(
        walletRepository: mockWalletRepository,
        userAttributesRepository: mockUserAttributesRepository);
  });

  group('Delete Wallet', () {
    const walletId = 'Wallet#2021-01-06T12:51:31.215Z';
    const userId = 'User#2020-12-21T20:35:49.295Z';
    const user = User(userId: userId);
    const Either<Failure, User> userMonad = Right<Failure, User>(user);

    test('Success', () async {
      const Either<Failure, void> addWalletMonad = Right<Failure, void>('');

      when(() => mockUserAttributesRepository!.readUserAttributes())
          .thenAnswer((_) => Future.value(userMonad));
      when(() =>
              mockWalletRepository!.delete(userId: userId, walletId: walletId))
          .thenAnswer((_) => Future.value(addWalletMonad));

      final walletResponse = await deleteWalletUseCase.delete(itemId: walletId);

      expect(walletResponse.isRight(), true);
      verify(() =>
          mockWalletRepository!.delete(walletId: walletId, userId: userId));
    });

    test('Failure', () async {
      final Either<Failure, void> deleteWalletMonad =
          Left<Failure, void>(FetchDataFailure());

      when(() => mockUserAttributesRepository!.readUserAttributes())
          .thenAnswer((_) => Future.value(userMonad));
      when(() =>
              mockWalletRepository!.delete(userId: userId, walletId: walletId))
          .thenAnswer((_) => Future.value(deleteWalletMonad));

      final walletResponse = await deleteWalletUseCase.delete(itemId: walletId);

      expect(walletResponse.isLeft(), true);
      verify(() =>
          mockWalletRepository!.delete(walletId: walletId, userId: userId));
    });

    test('ReadDefaultWallet: Failure', () async {
      final Either<Failure, User> userFailure =
          Left<Failure, User>(FetchDataFailure());
      when(() => mockUserAttributesRepository!.readUserAttributes())
          .thenAnswer((_) => Future.value(userFailure));

      final walletResponse = await deleteWalletUseCase.delete(itemId: walletId);

      final f =
          walletResponse.fold((failure) => failure, (_) => GenericFailure());

      expect(f, EmptyResponseFailure());
      expect(walletResponse.isLeft(), true);
      verifyNever(() =>
          mockWalletRepository!.delete(walletId: walletId, userId: userId));
    });
  });
}
