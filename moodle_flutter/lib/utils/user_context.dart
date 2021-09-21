class UserContext {
  String _username;
  String _password;
  String _token;
  String _moodleSession;
  int _userId;

  String get username => _username;

  String get password => _password;

  String get token => _token;

  String get moodleSession => _moodleSession;
  set moodleSession(String value) {
    _moodleSession = value;
  }

  int get userId => _userId;
  set userId(int value) {
    _userId = value;
  }

  UserContext(this._username, this._password, this._token);
}

class ServerLocalHieuEnvironment implements UserContext {
  @override
  String _moodleSession;

  @override
  String _password;

  @override
  String _token;

  @override
  String _username;

  @override
  String get token => "ae5354f8a47778ff1d9c3144126b4470";

  @override
  String get username => "admin";

  @override
  String get password => "Moodle-2020";

  @override
  String get moodleSession => _moodleSession;

  @override
  void set moodleSession(String value) {
    _moodleSession = value;
  }

  @override
  int _userId;

  @override
  set userId(int value) {
    userId = value;
  }

  @override
  int get userId => userId;

}

class UserFirebase {

}

// class LocalTaiEnvironment implements UserContext {
//   @override
//   String _token;
//
//   @override
//   String _username;
//
//   LocalTaiEnvironment();
//
//   @override
//   String get token => "58ab4770b6bfb77c4cfdaa1abb0e6d66";
//
//   @override
//   String get username => "admin";
//
//   String get password => "Admin2020%23";
// }

// class ServerTaiEnvironment implements UserContext {
//   @override
//   String _token;
//
//   @override
//   String _username;
//
//   @override
//   String get token => "025f62b89ed4c850d06a06e77f255d98";
//
//   @override
//   String get username => "tai";
//
//   String get password => "Moodle2020%23";
// }

//
// class OngTaiEnvironment implements UserContext {
//   @override
//   String _token;
//
//   @override
//   String _username = "tainguyencse";
//
//   @override
//   String get token => "22c8a9bfeb408884322576e1326b8d4e";
//
//   @override
//   String get username => _username;
//
//   String get password => "NTai@BK2020";
// }
