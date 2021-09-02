part of 'wallet_bloc.dart';

abstract class WalletState extends Equatable {
  const WalletState();

  @override
  List<Object> get props => [];
}

class Loading extends WalletState {}

class Empty extends WalletState {}

class Error extends WalletState {
  const Error({required this.message});

  final String message;

  @override
  List<Object> get props => [message];
}
