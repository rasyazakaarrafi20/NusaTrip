import 'package:flutter/material.dart';

class ProfileHeader extends StatelessWidget {
  final String nama;
  final String email;

  const ProfileHeader({
    super.key,
    required this.nama,
    required this.email,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const CircleAvatar(
          radius: 55,
          backgroundColor: Color(0xFF2563EB),
          child: Icon(
            Icons.person,
            size: 60,
            color: Colors.white,
          ),
        ),

        const SizedBox(height: 15),

        Text(
          nama,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 5),

        Text(
          email,
          style: const TextStyle(
            color: Colors.grey,
            fontSize: 15,
          ),
        ),
      ],
    );
  }
}