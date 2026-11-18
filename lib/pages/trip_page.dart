
import 'package:flutter/material.dart';

import '../fungsi/trip_data.dart';
import '../models/trip_plan.dart';
import 'profile_page.dart';

class TripPage extends StatefulWidget {
  final bool sebagaiRiwayat;

  const TripPage({
    super.key,
    this.sebagaiRiwayat = false,
  });

  @override
  State<TripPage> createState() => _TripPageState();
}

class _TripPageState extends State<TripPage> {
  String formatTanggal(DateTime tanggal) {
    const bulan = [
      'Januari',
      'Februari',
      'Maret',
      'April',
      'Mei',
      'Juni',
      'Juli',
      'Agustus',
      'September',
      'Oktober',
      'November',
      'Desember',
    ];

    return '${tanggal.day} ${bulan[tanggal.month - 1]} ${tanggal.year}';
  }

  int durasi(TripPlan trip) {
    return trip.tanggalSelesai.difference(trip.tanggalMulai).inDays + 1;
  }

  void hapusTrip(TripPlan trip) {
    setState(() {
      TripData.hapus(trip);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Rencana perjalanan dihapus.'),
      ),
    );
  }

  void bukaDetail(TripPlan trip) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TripDetailPage(trip: trip),
      ),
    ).then((_) {
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final daftarTrip = TripData.rencana;
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    final appBarBackground =
        theme.appBarTheme.backgroundColor ?? colors.primary;

    final appBarForeground =
        theme.appBarTheme.foregroundColor ?? colors.onPrimary;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        automaticallyImplyLeading: !widget.sebagaiRiwayat,
        title: Text(
          widget.sebagaiRiwayat
              ? 'Riwayat Perjalanan'
              : 'Rencana Perjalanan',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: appBarForeground,
          ),
        ),
        backgroundColor: appBarBackground,
        foregroundColor: appBarForeground,
        elevation: 0,
        actions: widget.sebagaiRiwayat
            ? [
                TextButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ProfilePage(),
                      ),
                    );
                  },
                  style: TextButton.styleFrom(
                    foregroundColor: appBarForeground,
                  ),
                  icon: Icon(
                    Icons.person_outline,
                    color: appBarForeground,
                  ),
                  label: Text(
                    'Profil',
                    style: TextStyle(
                      color: appBarForeground,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
              ]
            : null,
      ),
      body: daftarTrip.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.luggage_outlined,
                    size: 70,
                    color: colors.onSurfaceVariant,
                  ),
                  const SizedBox(height: 15),
                  Text(
                    widget.sebagaiRiwayat
                        ? 'Belum ada riwayat perjalanan'
                        : 'Belum ada rencana perjalanan',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    widget.sebagaiRiwayat
                        ? 'Rencana perjalanan yang kamu simpan akan muncul di sini.'
                        : 'Buat rencana dari halaman detail wisata.',
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: colors.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: daftarTrip.length,
              itemBuilder: (context, index) {
                final trip = daftarTrip[index];

                return Card(
                  color: colors.surface,
                  margin: const EdgeInsets.only(bottom: 14),
                  clipBehavior: Clip.antiAlias,
                  child: InkWell(
                    onTap: () => bukaDetail(trip),
                    child: Padding(
                      padding: const EdgeInsets.all(17),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(11),
                                decoration: BoxDecoration(
                                  color: colors.primaryContainer,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Icon(
                                  Icons.place_outlined,
                                  color: colors.primary,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  trip.namaWisata,
                                  style: theme.textTheme.titleMedium?.copyWith(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              IconButton(
                                onPressed: () => hapusTrip(trip),
                                icon: const Icon(
                                  Icons.delete_outline,
                                  color: Colors.red,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Icon(
                                Icons.calendar_today,
                                size: 17,
                                color: colors.primary,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  '${formatTanggal(trip.tanggalMulai)} – '
                                  '${formatTanggal(trip.tanggalSelesai)}',
                                  style: theme.textTheme.bodyMedium,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Icon(
                                Icons.timelapse,
                                size: 17,
                                color: colors.primary,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                '${durasi(trip)} hari',
                                style: theme.textTheme.bodyMedium,
                              ),
                              const Spacer(),
                              Text(
                                'Lihat detail',
                                style: TextStyle(
                                  color: colors.primary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(width: 4),
                              Icon(
                                Icons.arrow_forward_ios,
                                size: 13,
                                color: colors.primary,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}

class TripDetailPage extends StatelessWidget {
  final TripPlan trip;

  const TripDetailPage({
    super.key,
    required this.trip,
  });

  String formatTanggal(DateTime tanggal) {
    const bulan = [
      'Januari',
      'Februari',
      'Maret',
      'April',
      'Mei',
      'Juni',
      'Juli',
      'Agustus',
      'September',
      'Oktober',
      'November',
      'Desember',
    ];

    return '${tanggal.day} ${bulan[tanggal.month - 1]} ${tanggal.year}';
  }

  @override
  Widget build(BuildContext context) {
    final totalHari =
        trip.tanggalSelesai.difference(trip.tanggalMulai).inDays + 1;

    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    final appBarBackground =
        theme.appBarTheme.backgroundColor ?? colors.primary;

    final appBarForeground =
        theme.appBarTheme.foregroundColor ?? colors.onPrimary;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          'Detail Perjalanan',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: appBarForeground,
          ),
        ),
        backgroundColor: appBarBackground,
        foregroundColor: appBarForeground,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Container(
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  colors.primary,
                  colors.primary.withValues(alpha: 0.75),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(22),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.luggage,
                  color: Colors.white,
                  size: 34,
                ),
                const SizedBox(height: 18),
                const Text(
                  'DESTINASI PERJALANAN',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  trip.namaWisata,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '$totalHari hari perjalanan',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          _detailCard(
            context: context,
            icon: Icons.date_range,
            title: 'Jadwal Perjalanan',
            child: Column(
              children: [
                _dateRow(
                  context,
                  'Tanggal mulai',
                  formatTanggal(trip.tanggalMulai),
                ),
                const Divider(height: 22),
                _dateRow(
                  context,
                  'Tanggal selesai',
                  formatTanggal(trip.tanggalSelesai),
                ),
                const Divider(height: 22),
                _dateRow(
                  context,
                  'Durasi',
                  '$totalHari hari',
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          _detailCard(
            context: context,
            icon: Icons.notes,
            title: 'Catatan Perjalanan',
            child: Text(
              trip.catatan.isEmpty
                  ? 'Belum ada catatan untuk perjalanan ini.'
                  : trip.catatan,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontSize: 14,
                height: 1.6,
                color: colors.onSurfaceVariant,
              ),
            ),
          ),
          const SizedBox(height: 14),
          _detailCard(
            context: context,
            icon: Icons.info_outline,
            title: 'Informasi',
            child: Text(
              'Pastikan jadwal dan perlengkapan perjalanan '
              'sudah dipersiapkan sebelum berangkat.',
              style: theme.textTheme.bodyMedium?.copyWith(
                fontSize: 14,
                height: 1.6,
                color: colors.onSurfaceVariant,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _detailCard({
    required BuildContext context,
    required IconData icon,
    required String title,
    required Widget child,
  }) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                color: colors.primary,
              ),
              const SizedBox(width: 9),
              Text(
                title,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }

  Widget _dateRow(
    BuildContext context,
    String label,
    String value,
  ) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colors.onSurfaceVariant,
            ),
          ),
        ),
        Text(
          value,
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
