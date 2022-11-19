import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_blitzbudget/app/ploc/dashboard/wallet/wallet_bloc.dart';
import 'package:mobile_blitzbudget/app/ploc/dashboard/wallet/wallet_constants.dart'
    as constants;
import 'package:mobile_blitzbudget/core/failure/api_failure.dart';
import 'package:mobile_blitzbudget/core/failure/failure.dart';
import 'package:mobile_blitzbudget/domain/entities/wallet/wallet.dart';
import 'package:mobile_blitzbudget/domain/usecases/dashboard/wallet/add_wallet_use_case.dart'
    as add_wallet_usecase;
import 'package:mobile_blitzbudget/domain/usecases/dashboard/wallet/delete_wallet_use_case.dart'
    as delete_wallet_usecase;
import 'package:mobile_blitzbudget/domain/usecases/dashboard/wallet/fetch_wallet_use_case.dart'
    as fetch_wallet_usecase;
import 'package:mobile_blitzbudget/domain/usecases/dashboard/wallet/update_wallet_use_case.dart'
    as update_wallet_usecase;
import 'package:mocktail/mocktail.dart';

class MockAddWalletUsecase extends Mock
    implements add_wallet_usecase.AddWalletUseCase {}

class MockDeleteWalletUseCase extends Mock
    implements delete_wallet_usecase.DeleteWalletUseCase {}

class MockUpdateWalletUseCase extends Mock
    implements update_wallet_usecase.UpdateWalletUseCase {}

class MockFetchWalletUseCase extends Mock
    implements fetch_wallet_usecase.FetchWalletUseCase {}

void main() {
  const WALLET_ID = 'walletID';
  const USER_ID = 'userID';
  const WALLET_NAME = 'walletName';
  const CURRENCY = 'Euro';

  late MockAddWalletUsecase mockAddWalletUsecase;
  late MockDeleteWalletUseCase mockDeleteWalletUseCase;
  late MockUpdateWalletUseCase mockUpdateWalletUseCase;
  late MockFetchWalletUseCase mockFetchWalletUseCase;
  const positiveMonadResponse = Right<Failure, void>('');
  const addWallet = Wallet(
      userId: USER_ID,
      currency: CURRENCY,
      walletId: WALLET_ID,
      walletName: WALLET_NAME,
      totalDebtBalance: 1,
      walletBalance: 1,
      totalAssetBalance: 1);

  setUp(() {
    mockAddWalletUsecase = MockAddWalletUsecase();
    mockDeleteWalletUseCase = MockDeleteWalletUseCase();
    mockUpdateWalletUseCase = MockUpdateWalletUseCase();
    mockFetchWalletUseCase = MockFetchWalletUseCase();
  });

  group('Success: WalletBloc', () {
    blocTest<WalletBloc, WalletState>(
      'Emits [Success] states for add wallet success',
      build: () {
        when(() =>
                mockAddWalletUsecase.add(currency: CURRENCY, name: WALLET_NAME))
            .thenAnswer((_) => Future.value(positiveMonadResponse));
        return WalletBloc(
            addWalletUseCase: mockAddWalletUsecase,
            deleteWalletUseCase: mockDeleteWalletUseCase,
            updateWalletUseCase: mockUpdateWalletUseCase,
            fetchWalletUseCase: mockFetchWalletUseCase);
      },
      act: (bloc) =>
          bloc.add(const Add(currency: CURRENCY, walletName: WALLET_NAME)),
      expect: () => [Loading(), Success()],
    );

    blocTest<WalletBloc, WalletState>(
      'Emits [Success] states for fetch wallet success',
      build: () {
        final wallets = [addWallet];
        final fetchWalletResponse = Right<Failure, List<Wallet>>(wallets);
        when(() => mockFetchWalletUseCase.fetch())
            .thenAnswer((_) => Future.value(fetchWalletResponse));
        return WalletBloc(
            addWalletUseCase: mockAddWalletUsecase,
            deleteWalletUseCase: mockDeleteWalletUseCase,
            updateWalletUseCase: mockUpdateWalletUseCase,
            fetchWalletUseCase: mockFetchWalletUseCase);
      },
      act: (bloc) => bloc.add(const Fetch()),
      expect: () => [Loading(), Success()],
    );

    blocTest<WalletBloc, WalletState>(
      'Emits [Success] states for update category id success',
      build: () {
        when(() => mockUpdateWalletUseCase.updateCurrency(
                currency: CURRENCY, walletId: WALLET_ID))
            .thenAnswer((_) => Future.value(positiveMonadResponse));
        return WalletBloc(
            addWalletUseCase: mockAddWalletUsecase,
            deleteWalletUseCase: mockDeleteWalletUseCase,
            updateWalletUseCase: mockUpdateWalletUseCase,
            fetchWalletUseCase: mockFetchWalletUseCase);
      },
      act: (bloc) => bloc
          .add(const UpdateCurrency(walletId: WALLET_ID, currency: CURRENCY)),
      expect: () => [Loading(), Success()],
    );

    blocTest<WalletBloc, WalletState>(
      'Emits [Success] states for delete wallet success',
      build: () {
        when(() => mockDeleteWalletUseCase.delete(itemId: WALLET_ID))
            .thenAnswer((_) => Future.value(positiveMonadResponse));
        return WalletBloc(
            addWalletUseCase: mockAddWalletUsecase,
            deleteWalletUseCase: mockDeleteWalletUseCase,
            updateWalletUseCase: mockUpdateWalletUseCase,
            fetchWalletUseCase: mockFetchWalletUseCase);
      },
      act: (bloc) => bloc.add(const Delete(walletId: WALLET_ID)),
      expect: () => [Loading(), Success()],
    );
  });

  group('Error Generic API Failure: WalletBloc', () {
    blocTest<WalletBloc, WalletState>(
      'Emits [Error] states for add wallet success',
      build: () {
        final fetchWalletResponse =
            Left<Failure, List<Wallet>>(GenericAPIFailure());
        when(() =>
                mockAddWalletUsecase.add(currency: CURRENCY, name: WALLET_NAME))
            .thenAnswer((_) => Future.value(fetchWalletResponse));
        return WalletBloc(
            addWalletUseCase: mockAddWalletUsecase,
            deleteWalletUseCase: mockDeleteWalletUseCase,
            updateWalletUseCase: mockUpdateWalletUseCase,
            fetchWalletUseCase: mockFetchWalletUseCase);
      },
      act: (bloc) => bloc.add(const Add(
        currency: CURRENCY,
        walletName: WALLET_NAME,
      )),
      expect: () =>
          [Loading(), const Error(message: constants.GENERIC_ERROR_EXCEPTION)],
    );

    blocTest<WalletBloc, WalletState>(
      'Emits [Error] states for fetch wallet generic error',
      build: () {
        final fetchWalletResponse =
            Left<Failure, List<Wallet>>(GenericAPIFailure());
        when(() => mockFetchWalletUseCase.fetch())
            .thenAnswer((_) => Future.value(fetchWalletResponse));
        return WalletBloc(
            addWalletUseCase: mockAddWalletUsecase,
            deleteWalletUseCase: mockDeleteWalletUseCase,
            updateWalletUseCase: mockUpdateWalletUseCase,
            fetchWalletUseCase: mockFetchWalletUseCase);
      },
      act: (bloc) => bloc.add(const Fetch()),
      expect: () =>
          [Loading(), const Error(message: constants.GENERIC_ERROR_EXCEPTION)],
    );

    blocTest<WalletBloc, WalletState>(
      'Emits [Error] states for update category id success',
      build: () {
        final failureMonadResponse = Left<Failure, void>(GenericAPIFailure());
        when(() => mockUpdateWalletUseCase.updateCurrency(
                currency: CURRENCY, walletId: WALLET_ID))
            .thenAnswer((_) => Future.value(failureMonadResponse));
        return WalletBloc(
            addWalletUseCase: mockAddWalletUsecase,
            deleteWalletUseCase: mockDeleteWalletUseCase,
            updateWalletUseCase: mockUpdateWalletUseCase,
            fetchWalletUseCase: mockFetchWalletUseCase);
      },
      act: (bloc) => bloc
          .add(const UpdateCurrency(walletId: WALLET_ID, currency: CURRENCY)),
      expect: () =>
          [Loading(), const Error(message: constants.GENERIC_ERROR_EXCEPTION)],
    );

    blocTest<WalletBloc, WalletState>(
      'Emits [Error] states for delete wallet success',
      build: () {
        final failureMonadResponse = Left<Failure, void>(GenericAPIFailure());
        when(() => mockDeleteWalletUseCase.delete(itemId: WALLET_ID))
            .thenAnswer((_) => Future.value(failureMonadResponse));
        return WalletBloc(
            addWalletUseCase: mockAddWalletUsecase,
            deleteWalletUseCase: mockDeleteWalletUseCase,
            updateWalletUseCase: mockUpdateWalletUseCase,
            fetchWalletUseCase: mockFetchWalletUseCase);
      },
      act: (bloc) => bloc.add(const Delete(walletId: WALLET_ID)),
      expect: () =>
          [Loading(), const Error(message: constants.GENERIC_ERROR_EXCEPTION)],
    );
  });

  group('Error Fetch Data Failure: WalletBloc', () {
    blocTest<WalletBloc, WalletState>(
      'Emits [Error] states for add wallet success',
      build: () {
        final failureMonadResponse = Left<Failure, void>(FetchDataFailure());
        when(() =>
                mockAddWalletUsecase.add(currency: CURRENCY, name: WALLET_NAME))
            .thenAnswer((_) => Future.value(failureMonadResponse));
        return WalletBloc(
            addWalletUseCase: mockAddWalletUsecase,
            deleteWalletUseCase: mockDeleteWalletUseCase,
            updateWalletUseCase: mockUpdateWalletUseCase,
            fetchWalletUseCase: mockFetchWalletUseCase);
      },
      act: (bloc) => bloc.add(const Add(
        currency: CURRENCY,
        walletName: WALLET_NAME,
      )),
      expect: () => [Loading(), RedirectToLogin()],
    );

    blocTest<WalletBloc, WalletState>(
      'Emits [Error] states for fetch wallet generic error',
      build: () {
        final fetchWalletResponse =
            Left<Failure, List<Wallet>>(FetchDataFailure());
        when(() => mockFetchWalletUseCase.fetch())
            .thenAnswer((_) => Future.value(fetchWalletResponse));
        return WalletBloc(
            addWalletUseCase: mockAddWalletUsecase,
            deleteWalletUseCase: mockDeleteWalletUseCase,
            updateWalletUseCase: mockUpdateWalletUseCase,
            fetchWalletUseCase: mockFetchWalletUseCase);
      },
      act: (bloc) => bloc.add(const Fetch()),
      expect: () => [Loading(), RedirectToLogin()],
    );

    blocTest<WalletBloc, WalletState>(
      'Emits [Error] states for update category id success',
      build: () {
        final failureMonadResponse = Left<Failure, void>(FetchDataFailure());
        when(() => mockUpdateWalletUseCase.updateCurrency(
                currency: CURRENCY, walletId: WALLET_ID))
            .thenAnswer((_) => Future.value(failureMonadResponse));
        return WalletBloc(
            addWalletUseCase: mockAddWalletUsecase,
            deleteWalletUseCase: mockDeleteWalletUseCase,
            updateWalletUseCase: mockUpdateWalletUseCase,
            fetchWalletUseCase: mockFetchWalletUseCase);
      },
      act: (bloc) => bloc
          .add(const UpdateCurrency(walletId: WALLET_ID, currency: CURRENCY)),
      expect: () => [Loading(), RedirectToLogin()],
    );

    blocTest<WalletBloc, WalletState>(
      'Emits [Error] states for delete wallet success',
      build: () {
        final failureMonadResponse = Left<Failure, void>(FetchDataFailure());
        when(() => mockDeleteWalletUseCase.delete(itemId: WALLET_ID))
            .thenAnswer((_) => Future.value(failureMonadResponse));
        return WalletBloc(
            addWalletUseCase: mockAddWalletUsecase,
            deleteWalletUseCase: mockDeleteWalletUseCase,
            updateWalletUseCase: mockUpdateWalletUseCase,
            fetchWalletUseCase: mockFetchWalletUseCase);
      },
      act: (bloc) => bloc.add(const Delete(walletId: WALLET_ID)),
      expect: () => [Loading(), RedirectToLogin()],
    );
  });
}
