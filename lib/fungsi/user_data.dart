import '../models/user.dart';

final List<User> userData = [];

User? userAktif;

User? cariUser(int idUser) {
  for (final user in userData) {
    if (user.id == idUser) {
      return user;
    }
  }

  return null;
}