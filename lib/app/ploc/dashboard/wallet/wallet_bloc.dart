import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:mobile_blitzbudget/core/failure/api_failure.dart';
import 'package:mobile_blitzbudget/core/failure/failure.dart';
import 'package:mobile_blitzbudget/domain/entities/wallet/wallet.dart';

import '../../../../domain/usecases/dashboard/wallet/add_wallet_use_case.dart'
    as add_wallet_use_case;
import '../../../../domain/usecases/dashboard/wallet/delete_wallet_use_case.dart'
    as delete_wallet_use_case;
import '../../../../domain/usecases/dashboard/wallet/fetch_wallet_use_case.dart'
    as fetch_wallet_use_case;
import '../../../../domain/usecases/dashboard/wallet/update_wallet_use_case.dart'
    as update_wallet_use_case;
import 'wallet_constants.dart' as constants;

part 'wallet_event.dart';
part 'wallet_state.dart';

class WalletBloc extends Bloc<WalletEvent, WalletState> {
  WalletBloc(
      {required this.fetchWalletUseCase,
      required this.updateWalletUseCase,
      required this.addWalletUseCase,
      required this.deleteWalletUseCase})
      : super(Empty());

  final fetch_wallet_use_case.FetchWalletUseCase fetchWalletUseCase;
  final update_wallet_use_case.UpdateWalletUseCase updateWalletUseCase;
  final add_wallet_use_case.AddWalletUseCase addWalletUseCase;
  final delete_wallet_use_case.DeleteWalletUseCase deleteWalletUseCase;

  @override
  Stream<WalletState> mapEventToState(
    WalletEvent event,
  ) async* {
    yield Loading();

    if (event is Fetch) {
      final fetchResponse = await fetchWalletUseCase.fetch();
      fetchResponse.fold(_convertToMessage, _successResponse);
    } else if (event is Add) {
      final addResponse = await addWalletUseCase.add(currency: event.currency);
      addResponse.fold(_convertToMessage, _successResponse);
    } else if (event is Update) {
      final updateWallet = Wallet(
          walletId: event.walletId,
          userId: event.userId,
          walletBalance: event.walletBalance,
          walletName: event.walletName,
          currency: event.currency,
          totalAssetBalance: event.totalAssetBalance,
          totalDebtBalance: event.totalDebtBalance);
      final updateResponse =
          await updateWalletUseCase.update(updateWallet: updateWallet);
      updateResponse.fold(_convertToMessage, _successResponse);
    } else if (event is Delete) {
      final deleteResponse =
          await deleteWalletUseCase.delete(itemId: event.walletId!);
      deleteResponse.fold(_convertToMessage, _successResponse);
    } else if (event is UpdateWalletName) {
      final updateResponse = await updateWalletUseCase.updateWalletName(
          name: event.walletName, walletId: event.walletId);
      updateResponse.fold(_convertToMessage, _successResponse);
    } else if (event is UpdateCurrency) {
      final updateResponse = await updateWalletUseCase.updateCurrency(
          currency: event.currency, walletId: event.walletId);
      updateResponse.fold(_convertToMessage, _successResponse);
    }
  }

  WalletState _successResponse(void r) {
    return Success();
  }

  WalletState _convertToMessage(Failure failure) {
    debugPrint('Converting login failure to message ${failure.toString()} ');
    if (failure is FetchDataFailure) {
      return RedirectToLogin();
    }

    return const Error(message: constants.GENERIC_ERROR_EXCEPTION);
  }
}
