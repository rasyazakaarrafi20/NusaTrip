import 'dart:typed_data';

class User {
  final int _id;
  String _nama;
  String _email;
  String _password;
  Uint8List? _fotoProfil;

  User({
    required int id,
    required String nama,
    required String email,
    required String password,
    Uint8List? fotoProfil,
  })  : _id = id,
        _nama = nama,
        _email = email,
        _password = password,
        _fotoProfil = fotoProfil;

  int get id => _id;
  String get nama => _nama;
  String get email => _email;
  String get password => _password;
  Uint8List? get fotoProfil => _fotoProfil;

  set nama(String nilai) {
    _nama = nilai;
  }

  set email(String nilai) {
    _email = nilai;
  }

  set password(String nilai) {
    _password = nilai;
  }

  set fotoProfil(Uint8List? nilai) {
    _fotoProfil = nilai;
  }
}
