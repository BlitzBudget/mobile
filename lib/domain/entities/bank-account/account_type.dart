enum AccountType { asset, debt }

extension AccountTypeExtension on AccountType {
  String get name {
    switch (this) {
      case AccountType.asset:
        return 'ASSET';
      case AccountType.debt:
        return 'DEBT';
      default:
        return null;
    }
  }
}
