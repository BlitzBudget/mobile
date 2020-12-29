class Wallet {
  String walletId;
  String userId;
  String walletName;
  String currency;
  double totalDebtBalance;
  double walletBalance;
  double totalAssetBalance;

  /// Optional field: wallet id, wallet name, total debt balance, wallet balance, total asset balance
  Wallet(this.userId, this.currency,
      [this.walletId,
      this.walletName,
      this.totalDebtBalance,
      this.walletBalance,
      this.totalAssetBalance]);

  /// Map JSON Wallet to List of object
  Wallet.fromJSON(dynamic wallet) {
    this.walletId = wallet['walletId'];
    this.userId = wallet['userId'];
    this.walletName = wallet['name'];
    this.currency = wallet['currency'];
    this.totalDebtBalance = wallet['total_debt_balance'];
    this.walletBalance = wallet['wallet_balance'];
    this.totalAssetBalance = wallet['total_asset_balance'];
  }

  /// Wallet to JSON
  Map<String, dynamic> toJSON() => {
        'walletId': walletId,
        'userId': userId,
        'currency': currency,
        'name': walletName
      };
}
