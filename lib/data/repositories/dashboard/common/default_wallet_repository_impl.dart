import 'package:flutter/foundation.dart';
import 'package:mobile_blitzbudget/data/datasource/local/dashboard/default_wallet_local_data_source.dart';
import 'package:mobile_blitzbudget/domain/repositories/dashboard/common/default_wallet_repository.dart';

class DefaultWalletRepositoryImpl implements DefaultWalletRepository {
  final DefaultWalletLocalDataSource defaultWalletLocalDataSource;

  DefaultWalletRepositoryImpl({@required this.defaultWalletLocalDataSource});

  @override
  Future<String> readDefaultWallet() async {
    return await defaultWalletLocalDataSource.readDefaultWallet();
  }

  @override
  Future<void> writeDefaultWallet(String value) async {
    return await defaultWalletLocalDataSource.writeDefaultWallet(value);
  }
}
