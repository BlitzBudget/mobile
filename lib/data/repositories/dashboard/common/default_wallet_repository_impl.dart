import '../../datasource/local/authentication/default_wallet_local_data_source.dart';

class DefaultWalletRepositoryImpl implements DefaultWalletRepository {
  final DefaultWalletLocalDataSource defaultWalletLocalDataSource;

  DefaultWalletRepositoryImpl({@required this.defaultWalletLocalDataSource});

  @override
  Future<String> readDefaultWallet() async {
    return await defaultWalletLocalDataSource.readDefaultWallet();
  }

  Future<void> writeDefaultWallet(String value) async {
    return await defaultWalletLocalDataSource.writeDefaultWallet(value);
  }
}
