abstract class DefaultWalletRepository {
  Future<String> readDefaultWallet();

  Future<void> writeDefaultWallet(String value);
}
