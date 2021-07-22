import 'package:equatable/equatable.dart';
import 'package:mobile_blitzbudget/domain/entities/wallet/wallet.dart';

class WalletResponse extends Equatable {
  const WalletResponse({this.wallets});

  final List<Wallet>? wallets;

  @override
  List<Object?> get props => [wallets];
}
