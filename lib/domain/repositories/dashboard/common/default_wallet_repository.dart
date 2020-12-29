

abstract class DefaultWalletRepositoryImpl implements DefaultWalletRepository {

  Future<String> readDefaultWallet();

  Future<void> writeDefaultWallet(String value);
}
