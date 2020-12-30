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
}
