import 'package:flutter/material.dart';

import '../fungsi/trip_data.dart';
import '../models/trip_plan.dart';

class TripPage extends StatefulWidget {
  const TripPage({super.key});

  @override
  State<TripPage> createState() => _TripPageState();
}

class _TripPageState extends State<TripPage> {
  // Format tanggal
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

    return Scaffold(
      backgroundColor: const Color(0xFFF5F9FF),
      appBar: AppBar(
        title: const Text(
          'Rencana Perjalanan',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF2563EB),
        foregroundColor: Colors.white,
      ),
      body: daftarTrip.isEmpty
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.luggage_outlined,
                    size: 70,
                    color: Colors.grey,
                  ),
                  SizedBox(height: 15),
                  Text(
                    'Belum ada rencana perjalanan',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 6),
                  Text(
                    'Buat rencana dari halaman detail wisata.',
                    style: TextStyle(color: Colors.grey),
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
                                  color: const Color(0xFFE8F0FF),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Icon(
                                  Icons.place_outlined,
                                  color: Color(0xFF2563EB),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  trip.namaWisata,
                                  style: const TextStyle(
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
                              const Icon(
                                Icons.calendar_today,
                                size: 17,
                                color: Color(0xFF2563EB),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  '${formatTanggal(trip.tanggalMulai)} – '
                                  '${formatTanggal(trip.tanggalSelesai)}',
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              const Icon(
                                Icons.timelapse,
                                size: 17,
                                color: Color(0xFF2563EB),
                              ),
                              const SizedBox(width: 8),
                              Text('${durasi(trip)} hari'),
                              const Spacer(),
                              const Text(
                                'Lihat detail',
                                style: TextStyle(
                                  color: Color(0xFF2563EB),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(width: 4),
                              const Icon(
                                Icons.arrow_forward_ios,
                                size: 13,
                                color: Color(0xFF2563EB),
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

    return Scaffold(
      backgroundColor: const Color(0xFFF5F9FF),
      appBar: AppBar(
        title: const Text(
          'Detail Perjalanan',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF2563EB),
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Container(
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  Color(0xFF2563EB),
                  Color(0xFF4F80F5),
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
            icon: Icons.date_range,
            title: 'Jadwal Perjalanan',
            child: Column(
              children: [
                _dateRow(
                  'Tanggal mulai',
                  formatTanggal(trip.tanggalMulai),
                ),
                const Divider(height: 22),
                _dateRow(
                  'Tanggal selesai',
                  formatTanggal(trip.tanggalSelesai),
                ),
                const Divider(height: 22),
                _dateRow(
                  'Durasi',
                  '$totalHari hari',
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          _detailCard(
            icon: Icons.notes,
            title: 'Catatan Perjalanan',
            child: Text(
              trip.catatan.isEmpty
                  ? 'Belum ada catatan untuk perjalanan ini.'
                  : trip.catatan,
              style: const TextStyle(
                fontSize: 14,
                height: 1.6,
                color: Color(0xFF475569),
              ),
            ),
          ),
          const SizedBox(height: 14),
          _detailCard(
            icon: Icons.info_outline,
            title: 'Informasi',
            child: const Text(
              'Pastikan jadwal dan perlengkapan perjalanan '
              'sudah dipersiapkan sebelum berangkat.',
              style: TextStyle(
                fontSize: 14,
                height: 1.6,
                color: Color(0xFF475569),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _detailCard({
    required IconData icon,
    required String title,
    required Widget child,
  }) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                color: const Color(0xFF2563EB),
              ),
              const SizedBox(width: 9),
              Text(
                title,
                style: const TextStyle(
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

  Widget _dateRow(String label, String value) {
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: const TextStyle(color: Colors.grey),
          ),
        ),
        Text(
          value,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
      ],
    );
  }
}