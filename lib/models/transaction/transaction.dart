class Transaction {
    String transactionId;
    String walletId;
    Double amount;
    String description;
    String accountId;
    String dateMeantFor;
    String categoryId;
    Recurrence recurrence;
    CategoryType categoryType;
    String categoryName;
    List<String> tags;

    /// Optional Transactions id, description, recurrence, category type, category name and tags
    Transaction(this.walletId, this.amount, this.accountId, this.dateMeantFor, this.categoryId, [this.transactionId, this.description, this.recurrence, this.categoryType, this.categoryName, this.tags])

    /// Map JSON transactions to List of object
    Transaction.map(dynamic transactions) {

    }

    /// Transaction to JSON
    Map<String, dynamic> toJSON() => {
        'walletId': walletId,
        'transactionId': transactionId,
        'amount': amount,
        'recurrence': recurrence,
        'account': accountId,
        'dateMeantFor': dateMeantFor,
        'description': description,
        'tags': tags,
        'category': categoryId,
        'categoryType': categoryType,
        'categoryName': categoryName
      };
}
