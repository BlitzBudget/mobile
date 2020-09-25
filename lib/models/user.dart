class User {
  String _userid;
  String _email;
  String _name;
  String _fileformat;
  String _locale;
  String _familyname;
  User(this._userid, this._email);

  User.map(dynamic obj) {
    this._userid = obj["custom:financialPortfolioId"];
    this._email = obj["email"];
    this._name =  obj["name"];
    this._locale =  obj["locale"];
    this._fileformat = obj["custom:exportFileFormat"];
    this._familyname = obj["family_name"];

  }

  String get username => _userid;
  String get email => _email;

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map["_userid"] = _userid;
    map["email"] = _email;
    map["name"] = _name;
    map["locale"] = _locale;
    map["fileformat"] = _fileformat;
    map["familyname"] = _familyname;

    return map;
  }
}
