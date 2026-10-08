import 'package:flutter/material.dart';
import '../fungsi/trip_data.dart';
import '../models/trip_plan.dart';

class TripPlanning extends StatefulWidget {
  final String namaWisata;
  final VoidCallback onMaps;
  final VoidCallback onTiket;
  final VoidCallback onPenginapan;

  const TripPlanning({
    super.key,
    required this.namaWisata,
    required this.onMaps,
    required this.onTiket,
    required this.onPenginapan,
  });

  @override
  State<TripPlanning> createState() => _TripPlanningState();
}

class _TripPlanningState extends State<TripPlanning> {
  DateTime? tanggalMulai;
  DateTime? tanggalSelesai;

  final TextEditingController catatanController =
      TextEditingController();

  Future<void> pilihTanggal({
    required bool tanggalMulaiPilih,
  }) async {
    final tanggal = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2035),
    );

    if (tanggal == null) return;

    setState(() {
      if (tanggalMulaiPilih) {
        tanggalMulai = tanggal;

        if (tanggalSelesai != null &&
            tanggalSelesai!.isBefore(tanggal)) {
          tanggalSelesai = null;
        }
      } else {
        tanggalSelesai = tanggal;
      }
    });
  }

    void simpanRencana() {
      if (tanggalMulai == null || tanggalSelesai == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Silakan pilih tanggal mulai dan tanggal selesai.',
            ),
          ),
        );
        return;
      }

      final trip = TripPlan(
        id: TripData.rencana.length + 1,
        namaWisata: widget.namaWisata,
        tanggalMulai: tanggalMulai!,
        tanggalSelesai: tanggalSelesai!,
        catatan: catatanController.text.trim(),
      );

      TripData.tambah(trip);

      // Bersihkan form
      setState(() {
        tanggalMulai = null;
        tanggalSelesai = null;
        catatanController.clear();
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            '✅ Rencana perjalanan berhasil disimpan.',
          ),
        ),
      );
    }

  String formatTanggal(DateTime? tanggal) {
    if (tanggal == null) {
      return 'Pilih tanggal';
    }

    return '${tanggal.day.toString().padLeft(2, '0')}-'
        '${tanggal.month.toString().padLeft(2, '0')}-'
        '${tanggal.year}';
  }

  @override
  void dispose() {
    catatanController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFFE8F0FF),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.calendar_month,
                  color: Color(0xFF2563EB),
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Text(
                  'Rencanakan Perjalanan',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          const Text(
            'Atur jadwal perjalananmu sebelum berangkat.',
            style: TextStyle(
              color: Colors.grey,
              fontSize: 14,
            ),
          ),

          const SizedBox(height: 22),

          const Text(
            'Tanggal Mulai',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 8),

          InkWell(
            onTap: () {
              pilihTanggal(tanggalMulaiPilih: true);
            },
            borderRadius: BorderRadius.circular(14),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(
                horizontal: 15,
                vertical: 15,
              ),
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: const Color(0xFFE2E8F0),
                ),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.calendar_today,
                    size: 20,
                    color: Color(0xFF2563EB),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    formatTanggal(tanggalMulai),
                    style: TextStyle(
                      color: tanggalMulai == null
                          ? Colors.grey
                          : const Color(0xFF0F172A),
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 18),

          const Text(
            'Tanggal Selesai',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 8),

          InkWell(
            onTap: () {
              pilihTanggal(tanggalMulaiPilih: false);
            },
            borderRadius: BorderRadius.circular(14),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(
                horizontal: 15,
                vertical: 15,
              ),
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: const Color(0xFFE2E8F0),
                ),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.calendar_today,
                    size: 20,
                    color: Color(0xFF2563EB),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    formatTanggal(tanggalSelesai),
                    style: TextStyle(
                      color: tanggalSelesai == null
                          ? Colors.grey
                          : const Color(0xFF0F172A),
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 18),

          const Text(
            'Catatan Perjalanan',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 8),

          TextField(
            controller: catatanController,
            maxLines: 4,
            decoration: InputDecoration(
              hintText:
                  'Contoh: berangkat pagi, membawa perlengkapan...',
              filled: true,
              fillColor: const Color(0xFFF8FAFC),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: const BorderSide(
                  color: Color(0xFFE2E8F0),
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: const BorderSide(
                  color: Color(0xFFE2E8F0),
                ),
              ),
            ),
          ),

          const SizedBox(height: 20),

          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton.icon(
              onPressed: simpanRencana,
              icon: const Icon(Icons.save_outlined),
              label: const Text(
                'Simpan Rencana',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2563EB),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),
          ),

          const SizedBox(height: 22),

          const Divider(),

          const SizedBox(height: 12),

          const Text(
            'Layanan Perjalanan',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 12),

          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: widget.onMaps,
                  icon: const Icon(Icons.map_outlined),
                  label: const Text('Maps'),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: widget.onTiket,
                  icon: const Icon(Icons.flight),
                  label: const Text('Tiket'),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: widget.onPenginapan,
                  icon: const Icon(Icons.hotel),
                  label: const Text('Hotel'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}