import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:mobile_blitzbudget/domain/entities/wallet/wallet.dart';
import '../../../../domain/usecases/dashboard/wallet/add_wallet_use_case.dart'
    as add_wallet_use_case;
import '../../../../domain/usecases/dashboard/wallet/delete_wallet_use_case.dart'
    as delete_wallet_use_case;
import '../../../../domain/usecases/dashboard/wallet/fetch_wallet_use_case.dart'
    as fetch_wallet_use_case;
import '../../../../domain/usecases/dashboard/wallet/update_wallet_use_case.dart'
    as update_wallet_use_case;

part 'wallet_event.dart';
part 'wallet_state.dart';

class WalletBloc extends Bloc<WalletEvent, WalletState> {
  WalletBloc(this.fetchWalletUseCase, this.updateWalletUseCase,
      this.addWalletUseCase, this.deleteWalletUseCase)
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
      await fetchWalletUseCase.fetch();
    } else if (event is Add) {
      await addWalletUseCase.add(currency: event.currency);
    } else if (event is Update) {
      final updateWallet = Wallet(
          walletId: event.walletId,
          userId: event.userId,
          walletBalance: event.walletBalance,
          walletName: event.walletName,
          currency: event.currency,
          totalAssetBalance: event.totalAssetBalance,
          totalDebtBalance: event.totalDebtBalance);
      await updateWalletUseCase.update(updateWallet: updateWallet);
    } else if (event is Delete) {
      await deleteWalletUseCase.delete(itemId: event.walletId!);
    } else if (event is UpdateWalletName) {
      await updateWalletUseCase.updateWalletName(
          name: event.walletName, walletId: event.walletId);
    } else if (event is UpdateCurrency) {
      await updateWalletUseCase.updateCurrency(
          currency: event.currency, walletId: event.walletId);
    }
  }
}
