import 'package:equatable/equatable.dart';
import 'package:mobile_blitzbudget/domain/entities/wallet/wallet.dart';

import '../user.dart';

class UserResponse extends Equatable {
  final String refreshToken;
  final String authenticationToken;
  final String accessToken;
  final User user;
  final Wallet wallet;

  UserResponse(
      {this.refreshToken,
      this.authenticationToken,
      this.accessToken,
      this.user,
      this.wallet});

  @override
  List<Object> get props =>
      [refreshToken, authenticationToken, accessToken, user, wallet];
}
