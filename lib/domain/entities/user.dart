class User {
  String userId;
  String email;
  String name;
  String fileFormat;
  String locale;
  String familyName;

  User(
      {this.userId,
      this.email,
      this.name,
      this.locale,
      this.familyName,
      this.fileFormat});

  /// Convert String JSON into user object
  static User fromJSON(Map<String, dynamic> currentUser) {
    return User(
        userId: currentUser['financialPortfolioId'] as String,
        email: currentUser['email'] as String,
        name: currentUser['name'] as String,
        locale: currentUser['locale'] as String,
        fileFormat: currentUser['exportFileFormat'] as String,
        familyName: currentUser['family_name'] as String);
  }
}
