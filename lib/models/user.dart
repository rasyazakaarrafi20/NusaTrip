class User {
  final int _id;
  String _nama;
  String _email;
  String _password;

  User({
    required int id,
    required String nama,
    required String email,
    required String password,
  })  : _id = id,
        _nama = nama,
        _email = email,
        _password = password;

  int get id => _id;
  String get nama => _nama;
  String get email => _email;
  String get password => _password;

  set nama(String nilai) {
    _nama = nilai;
  }

  set email(String nilai) {
    _email = nilai;
  }

  set password(String nilai) {
    _password = nilai;
  }
}