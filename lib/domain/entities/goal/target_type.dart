enum TargetType { wallet, account }

extension TargetTypeExtension on TargetType {
  String get name {
    switch (this) {
      case TargetType.wallet:
        return 'Wallet';
      case TargetType.account:
        return 'Account';
      default:
        return null;
    }
  }
}
