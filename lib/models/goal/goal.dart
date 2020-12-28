class Goal {


    Map<String, dynamic> toJSON() => {
        'userid': _userid,
        'email': _email,
        'name': _name,
        'locale': _locale,
        'fileformat': _fileformat,
        'familyname': _familyname,
      };
}
