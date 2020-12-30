class Wallet {
  String walletId;
  String userId;
  String walletName;
  String currency;
  double totalDebtBalance;
  double walletBalance;
  double totalAssetBalance;

  /// Optional field: wallet id, wallet name, total debt balance, wallet balance, total asset balance
  Wallet(
      {this.userId,
      this.currency,
      this.walletId,
      this.walletName,
      this.totalDebtBalance,
      this.walletBalance,
      this.totalAssetBalance});

  /// Map JSON Wallet to List of object
  factory Wallet.fromJSON(Map<String, dynamic> wallet) {
    return Wallet(
        walletId: wallet['walletId'],
        userId: wallet['userId'],
        walletName: wallet['name'],
        currency: wallet['currency'],
        totalDebtBalance: wallet['total_debt_balance'],
        walletBalance: wallet['wallet_balance'],
        totalAssetBalance: wallet['total_asset_balance']);
  }

  /// Wallet to JSON
  Map<String, dynamic> toJSON() => <String, dynamic>{
        'walletId': walletId,
        'userId': userId,
        'currency': currency,
        'name': walletName
      };
}
