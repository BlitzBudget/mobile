import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:mobile_blitzbudget/core/failure/api_failure.dart';
import 'package:mobile_blitzbudget/core/failure/failure.dart';

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
      : super(Empty()) {
    on<Fetch>(_onFetch);
    on<Add>(_onAdd);
    on<Delete>(_onDelete);
    on<UpdateWalletName>(_onUpdateWalletName);
    on<UpdateCurrency>(_onUpdateCurrency);
  }

  final fetch_wallet_use_case.FetchWalletUseCase fetchWalletUseCase;
  final update_wallet_use_case.UpdateWalletUseCase updateWalletUseCase;
  final add_wallet_use_case.AddWalletUseCase addWalletUseCase;
  final delete_wallet_use_case.DeleteWalletUseCase deleteWalletUseCase;

  FutureOr<void> _onFetch(Fetch event, Emitter<WalletState> emit) async {
    emit(Loading());
    final fetchResponse = await fetchWalletUseCase.fetch();
    emit(fetchResponse.fold(_convertToMessage, _successResponse));
  }

  FutureOr<void> _onAdd(Add event, Emitter<WalletState> emit) async {
    emit(Loading());
    final addResponse = await addWalletUseCase.add(currency: event.currency);
    emit(addResponse.fold(_convertToMessage, _successResponse));
  }

  FutureOr<void> _onDelete(Delete event, Emitter<WalletState> emit) async {
    emit(Loading());
    final deleteResponse =
        await deleteWalletUseCase.delete(itemId: event.walletId!);
    emit(deleteResponse.fold(_convertToMessage, _successResponse));
  }

  FutureOr<void> _onUpdateWalletName(
      UpdateWalletName event, Emitter<WalletState> emit) async {
    emit(Loading());
    final updateResponse = await updateWalletUseCase.updateWalletName(
        name: event.walletName, walletId: event.walletId);
    emit(updateResponse.fold(_convertToMessage, _successResponse));
  }

  FutureOr<void> _onUpdateCurrency(
      UpdateCurrency event, Emitter<WalletState> emit) async {
    emit(Loading());
    final updateResponse = await updateWalletUseCase.updateCurrency(
        currency: event.currency, walletId: event.walletId);
    emit(updateResponse.fold(_convertToMessage, _successResponse));
  }

  WalletState _successResponse(void r) {
    return Success();
  }

  WalletState _convertToMessage(Failure failure) {
    debugPrint('Converting wallet failure to message ${failure.toString()} ');
    if (failure is FetchDataFailure) {
      return RedirectToLogin();
    }

    return const Error(message: constants.GENERIC_ERROR_EXCEPTION);
  }
}
