import 'dart:typed_data';

import 'package:flutter/material.dart';

class ProfileHeader extends StatelessWidget {
  final String nama;
  final String email;
  final Uint8List? fotoProfil;

  const ProfileHeader({
    super.key,
    required this.nama,
    required this.email,
    this.fotoProfil,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 55,
          backgroundColor: const Color(0xFF2563EB),
          backgroundImage: fotoProfil != null
              ? MemoryImage(fotoProfil!)
              : null,
          child: fotoProfil == null
              ? const Icon(
                  Icons.person,
                  size: 60,
                  color: Colors.white,
                )
              : null,
        ),

        const SizedBox(height: 15),

        Text(
          nama,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 5),

        Text(
          email,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Colors.grey,
            fontSize: 15,
          ),
        ),
      ],
    );
  }
}
