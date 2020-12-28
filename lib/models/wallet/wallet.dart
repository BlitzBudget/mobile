class Wallet {
  String walletId;
  String userId;
  String walletName;
  String currency;
  doubletotalDebtBalance;
  doublewalletBalance;
  doubletotalAssetBalance;

  /// Optional field: wallet id, wallet name, total debt balance, wallet balance, total asset balance
  Wallet(this.userId, this.currency,
      [this.walletId,
      this.walletName,
      this.totalDebtBalance,
      this.walletBalance,
      this.totalAssetBalance]);

  /// Wallet to JSON
  Map<String, dynamic> toJSON() => {
        'walletId': walletId,
        'userId': userId,
        'currency': currency,
        'name': walletName
      };
}
