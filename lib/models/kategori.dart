import 'package:flutter/material.dart';

class Kategori {
  final int _id;
  final String _nama;
  final IconData _icon;

  Kategori({
    required int id,
    required String nama,
    required IconData icon,
  })  : _id = id,
        _nama = nama,
        _icon = icon;

  int get id => _id;
  String get nama => _nama;
  IconData get icon => _icon;
}