import '../utils/utils.dart';
import 'dart:developer' as developer;

class User {
  String _userid;
  String _email;
  String _name;
  String _fileformat;
  String _locale;
  String _familyname;
  User(this._userid, this._email);

  User.map(dynamic obj) {
    Map currentUserLocal = {};

    dynamic userAttributes = obj;

    /// SUCCESS Scenarios
    for (var i = 0; i < userAttributes.length; i++) {
      developer.log("Printing User Attributes " + userAttributes[i]['Name']);
      String name = userAttributes[i]['Name'];

      developer.log('User:: The name is $name');
      if (name.contains('custom:')) {
        /// if custom values then remove custom:
        var elemName = lastElement(splitElement(name, ':'));
        developer.log('User:: The elemName is $elemName');
        currentUserLocal[elemName] = userAttributes[i]['Value'];
      } else {
        currentUserLocal[name] = userAttributes[i]['Value'];
      }
    }
    this._userid = currentUserLocal["financialPortfolioId"];
    this._email = currentUserLocal["email"];
    this._name = currentUserLocal["name"];
    this._locale = currentUserLocal["locale"];
    this._fileformat = currentUserLocal["exportFileFormat"];
    this._familyname = currentUserLocal["family_name"];
  }

  String get username => _userid;
  String get email => _email;

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map["userid"] = _userid;
    map["email"] = _email;
    map["name"] = _name;
    map["locale"] = _locale;
    map["fileformat"] = _fileformat;
    map["familyname"] = _familyname;

    return map;
  }

  Map<String, dynamic> toJSON() => {
        'userid': _userid,
        'email': _email,
        'name': _name,
        'locale': _locale,
        'fileformat': _fileformat,
        'familyname': _familyname,
      };
}
