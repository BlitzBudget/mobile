import 'package:equatable/equatable.dart';
import 'package:mobile_blitzbudget/domain/entities/wallet/wallet.dart';

class WalletResponse extends Equatable {
  final List<Wallet> wallets;  

  WalletResponse(
      {this.wallets});

  @override
  List<Object> get props => [
        wallets
      ];
}
