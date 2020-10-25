class User {
  int id;
  String login;
  String password;


  User({this.id, this.login, this.password});

  Map<String, dynamic> toMap() {
    final map = Map<String, dynamic>();
    map['id'] = id;
    map['login'] = login;
    map['password'] = password;
    return map;
  }

  User.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    login = map['login'];
    password = map['password'];
  }
}