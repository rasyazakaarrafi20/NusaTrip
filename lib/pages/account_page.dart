import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:fluttermoji/fluttermoji.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../fungsi/user_data.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  final _formKey = GlobalKey<FormState>();
  final _namaController = TextEditingController();
  final _emailController = TextEditingController();

  final ImagePicker _picker = ImagePicker();

  Uint8List? _fotoBaru;
  String? _fotoUrlLama;
  String? _fotoMimeType;
  bool _gunakanFluttermoji = false;

  bool _sedangMemilihFoto = false;
  bool _sedangMenyimpan = false;

  @override
  void initState() {
    super.initState();

    final user = Supabase.instance.client.auth.currentUser;

    _namaController.text =
        user?.userMetadata?['full_name']?.toString() ?? '';

    _emailController.text = user?.email ?? '';

    _fotoUrlLama =
        user?.userMetadata?['avatar_url']?.toString();

    _gunakanFluttermoji =
        user?.userMetadata?['avatar_mode'] == 'fluttermoji';
  }

  Future<void> _pilihFoto() async {
    try {
      setState(() => _sedangMemilihFoto = true);

      final XFile? foto = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
        maxWidth: 800,
      );

      if (foto != null) {
        final bytes = await foto.readAsBytes();

        if (!mounted) return;

        setState(() {
          _fotoBaru = bytes;
          _fotoMimeType = foto.mimeType ?? 'image/jpeg';
          _gunakanFluttermoji = false;
        });
      }
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Gagal memilih foto. Silakan coba lagi.'),
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _sedangMemilihFoto = false);
      }
    }
  }

  Future<void> _buatAvatar() async {
    final selesai = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) => const _FluttermojiEditorPage(),
      ),
    );

    if (selesai == true && mounted) {
      setState(() {
        _gunakanFluttermoji = true;
        _fotoBaru = null;
      });
    }
  }

  Future<String?> _unggahFoto(User user) async {
    if (_fotoBaru == null) return null;

    final supabase = Supabase.instance.client;
    final mimeType = _fotoMimeType ?? 'image/jpeg';

    final extension = switch (mimeType) {
      'image/png' => 'png',
      'image/webp' => 'webp',
      'image/gif' => 'gif',
      _ => 'jpg',
    };

    final path = '${user.id}/avatar.$extension';

    await supabase.storage.from('avatars').uploadBinary(
      path,
      _fotoBaru!,
      fileOptions: FileOptions(
        cacheControl: '0',
        upsert: true,
        contentType: mimeType,
      ),
    );

    final publicUrl =
        supabase.storage.from('avatars').getPublicUrl(path);

    return '$publicUrl?t=${DateTime.now().millisecondsSinceEpoch}';
  }

  Future<void> _simpanPerubahan() async {
    final supabase = Supabase.instance.client;
    final user = supabase.auth.currentUser;

    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Akun tidak ditemukan. Silakan login kembali.',
          ),
        ),
      );
      return;
    }

    if (!_formKey.currentState!.validate()) return;

    final namaBaru = _namaController.text.trim();
    final emailBaru = _emailController.text.trim();

    setState(() => _sedangMenyimpan = true);

    try {
      final fotoUrlBaru = await _unggahFoto(user);

      final metadata = <String, dynamic>{
        ...?user.userMetadata,
        'full_name': namaBaru,
      };

      if (fotoUrlBaru != null) {
        metadata['avatar_url'] = fotoUrlBaru;
      }

      metadata['avatar_mode'] =
          _gunakanFluttermoji ? 'fluttermoji' : 'photo';

      await supabase.auth.updateUser(
        UserAttributes(
          data: metadata,
          email: emailBaru != user.email ? emailBaru : null,
        ),
      );

      if (userAktif != null) {
        userAktif!.nama = namaBaru;
        userAktif!.email = emailBaru;

        if (_fotoBaru != null) {
          userAktif!.fotoProfil = _fotoBaru;
        }
      }

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            emailBaru != user.email
                ? 'Profil diperbarui. Silakan cek email untuk konfirmasi perubahan email.'
                : 'Profil berhasil diperbarui!',
          ),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.pop(context, true);
    } on AuthException catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal memperbarui profil: ${e.message}'),
          backgroundColor: Colors.red,
        ),
      );
    } on StorageException catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal mengunggah foto: ${e.message}'),
          backgroundColor: Colors.red,
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Terjadi kesalahan: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _sedangMenyimpan = false);
      }
    }
  }

  @override
  void dispose() {
    _namaController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const biru = Color(0xFF2563EB);

    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    final fotoLokalLama = userAktif?.fotoProfil;

    final appBarBackground =
        theme.appBarTheme.backgroundColor ?? colors.primary;

    final appBarForeground =
        theme.appBarTheme.foregroundColor ?? colors.onPrimary;

    final backgroundColor = theme.scaffoldBackgroundColor;
    final textColor = colors.onSurface;

    final inputFillColor = isDark
        ? colors.surfaceContainerHighest
        : Colors.white;

    ImageProvider? gambarProfil;

    if (_gunakanFluttermoji) {
      gambarProfil = null;
    } else if (_fotoBaru != null) {
      gambarProfil = MemoryImage(_fotoBaru!);
    } else if (_fotoUrlLama != null && _fotoUrlLama!.isNotEmpty) {
      gambarProfil = NetworkImage(_fotoUrlLama!);
    } else if (fotoLokalLama != null) {
      gambarProfil = MemoryImage(fotoLokalLama);
    }

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: appBarBackground,
        foregroundColor: appBarForeground,
        elevation: 0,
        title: Text(
          'Kelola Profil',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: appBarForeground,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 15),

              Center(
                child: Column(
                  children: [
                    Stack(
                      children: [
                        _gunakanFluttermoji
                            ? FluttermojiCircleAvatar(radius: 55)
                            : CircleAvatar(
                                radius: 55,
                                backgroundColor: biru,
                                backgroundImage: gambarProfil,
                                child: gambarProfil == null
                                    ? const Icon(
                                        Icons.person,
                                        size: 60,
                                        color: Colors.white,
                                      )
                                    : null,
                              ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: InkWell(
                            onTap: _sedangMemilihFoto ||
                                    _sedangMenyimpan
                                ? null
                                : _pilihFoto,
                            child: CircleAvatar(
                              radius: 19,
                              backgroundColor: biru,
                              child: _sedangMemilihFoto
                                  ? const SizedBox(
                                      width: 18,
                                      height: 18,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: Colors.white,
                                      ),
                                    )
                                  : const Icon(
                                      Icons.camera_alt,
                                      color: Colors.white,
                                      size: 20,
                                    ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    TextButton.icon(
                      onPressed: _sedangMemilihFoto ||
                              _sedangMenyimpan
                          ? null
                          : _pilihFoto,
                      icon: const Icon(Icons.image_outlined),
                      label: const Text('Ganti Foto Profil'),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 12),

              Center(
                child: OutlinedButton.icon(
                  onPressed:
                      _sedangMenyimpan ? null : _buatAvatar,
                  icon: const Icon(
                    Icons.face_retouching_natural,
                  ),
                  label: const Text('Buat / ubah avatar'),
                ),
              ),

              const SizedBox(height: 30),

              Text(
                'Informasi Pribadi',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),

              const SizedBox(height: 16),

              _buildLabel('Nama Lengkap', textColor),

              TextFormField(
                controller: _namaController,
                textCapitalization: TextCapitalization.words,
                style: TextStyle(color: textColor),
                decoration: _inputDecoration(
                  hint: 'Masukkan nama lengkap',
                  icon: Icons.person_outline,
                  fillColor: inputFillColor,
                  colors: colors,
                  isDark: isDark,
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Nama tidak boleh kosong';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 20),

              _buildLabel('Alamat Email', textColor),

              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                style: TextStyle(color: textColor),
                decoration: _inputDecoration(
                  hint: 'Masukkan alamat email',
                  icon: Icons.email_outlined,
                  fillColor: inputFillColor,
                  colors: colors,
                  isDark: isDark,
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Email tidak boleh kosong';
                  }

                  final email = value.trim();

                  if (!RegExp(
                    r'^[^@\s]+@[^@\s]+\.[^@\s]+$',
                  ).hasMatch(email)) {
                    return 'Format email tidak valid';
                  }

                  return null;
                },
              ),

              const SizedBox(height: 35),

              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton.icon(
                  onPressed: _sedangMenyimpan
                      ? null
                      : _simpanPerubahan,
                  icon: _sedangMenyimpan
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Icon(Icons.save_outlined),
                  label: Text(
                    _sedangMenyimpan
                        ? 'Menyimpan...'
                        : 'Simpan Perubahan',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: biru,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String label, Color textColor) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        label,
        style: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 14,
          color: textColor,
        ),
      ),
    );
  }

  InputDecoration _inputDecoration({
    required String hint,
    required IconData icon,
    required Color fillColor,
    required ColorScheme colors,
    required bool isDark,
  }) {
    final borderColor = colors.outlineVariant;

    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(
        color: colors.onSurfaceVariant,
      ),
      prefixIcon: Icon(
        icon,
        color: colors.primary,
      ),
      filled: true,
      fillColor: fillColor,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(
          color: borderColor,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(
          color: colors.primary,
          width: 1.5,
        ),
      ),
    );
  }
}

class _FluttermojiEditorPage extends StatelessWidget {
  const _FluttermojiEditorPage();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Buat Avatar'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Selesai'),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 12),
            FluttermojiCircleAvatar(radius: 55),
            const SizedBox(height: 12),
            Expanded(
              child: FluttermojiCustomizer(),
            ),
          ],
        ),
      ),
    );
  }
}
