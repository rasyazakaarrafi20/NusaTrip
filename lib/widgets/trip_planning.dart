
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
    final now = DateTime.now();
    final tanggal = await showDatePicker(
      context: context,
      initialDate: tanggalMulaiPilih
          ? (tanggalMulai ?? now)
          : (tanggalSelesai ?? tanggalMulai ?? now),
      firstDate: now,
      lastDate: DateTime(2035),
      builder: (context, child) {
        final theme = Theme.of(context);
        return Theme(
          data: theme.copyWith(
            colorScheme: theme.colorScheme.copyWith(
              primary: theme.colorScheme.primary,
              onPrimary: theme.colorScheme.onPrimary,
              surface: theme.colorScheme.surface,
              onSurface: theme.colorScheme.onSurface,
            ),
          ),
          child: child!,
        );
      },
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

    if (tanggalSelesai!.isBefore(tanggalMulai!)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Tanggal selesai tidak boleh sebelum tanggal mulai.',
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
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    final cardColor = colors.surface;
    final fieldColor = isDark
        ? colors.surfaceContainerHighest
        : const Color(0xFFF8FAFC);
    final borderColor = colors.outlineVariant;
    final textColor = colors.onSurface;
    final secondaryColor = colors.onSurfaceVariant;
    final primaryColor = colors.primary;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: borderColor),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(
              alpha: isDark ? 0.15 : 0.06,
            ),
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
                  color: colors.primaryContainer,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.calendar_month,
                  color: colors.onPrimaryContainer,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Rencanakan Perjalanan',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          Text(
            'Atur jadwal perjalananmu sebelum berangkat.',
            style: TextStyle(
              color: secondaryColor,
              fontSize: 14,
            ),
          ),

          const SizedBox(height: 22),

          _label('Tanggal Mulai', textColor),

          const SizedBox(height: 8),

          _dateField(
            tanggal: tanggalMulai,
            onTap: () => pilihTanggal(
              tanggalMulaiPilih: true,
            ),
            fieldColor: fieldColor,
            borderColor: borderColor,
            textColor: textColor,
            secondaryColor: secondaryColor,
            primaryColor: primaryColor,
          ),

          const SizedBox(height: 18),

          _label('Tanggal Selesai', textColor),

          const SizedBox(height: 8),

          _dateField(
            tanggal: tanggalSelesai,
            onTap: () => pilihTanggal(
              tanggalMulaiPilih: false,
            ),
            fieldColor: fieldColor,
            borderColor: borderColor,
            textColor: textColor,
            secondaryColor: secondaryColor,
            primaryColor: primaryColor,
          ),

          const SizedBox(height: 18),

          _label('Catatan Perjalanan', textColor),

          const SizedBox(height: 8),

          TextField(
            controller: catatanController,
            maxLines: 4,
            style: TextStyle(color: textColor),
            decoration: InputDecoration(
              hintText:
                  'Contoh: berangkat pagi, membawa perlengkapan...',
              hintStyle: TextStyle(color: secondaryColor),
              filled: true,
              fillColor: fieldColor,
              contentPadding: const EdgeInsets.all(14),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide(color: borderColor),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide(color: borderColor),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide(
                  color: primaryColor,
                  width: 1.5,
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
                backgroundColor: primaryColor,
                foregroundColor: colors.onPrimary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),
          ),

          const SizedBox(height: 22),

          Divider(color: borderColor),

          const SizedBox(height: 12),

          Text(
            'Layanan Perjalanan',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),

          const SizedBox(height: 12),

          Row(
            children: [
              Expanded(
                child: _serviceButton(
                  icon: Icons.map_outlined,
                  label: 'Maps',
                  onPressed: widget.onMaps,
                  colors: colors,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _serviceButton(
                  icon: Icons.flight,
                  label: 'Tiket',
                  onPressed: widget.onTiket,
                  colors: colors,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _serviceButton(
                  icon: Icons.hotel,
                  label: 'Hotel',
                  onPressed: widget.onPenginapan,
                  colors: colors,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _label(String text, Color color) {
    return Text(
      text,
      style: TextStyle(
        fontWeight: FontWeight.bold,
        color: color,
      ),
    );
  }

  Widget _dateField({
    required DateTime? tanggal,
    required VoidCallback onTap,
    required Color fieldColor,
    required Color borderColor,
    required Color textColor,
    required Color secondaryColor,
    required Color primaryColor,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 15,
        ),
        decoration: BoxDecoration(
          color: fieldColor,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: borderColor),
        ),
        child: Row(
          children: [
            Icon(
              Icons.calendar_today,
              size: 20,
              color: primaryColor,
            ),
            const SizedBox(width: 10),
            Text(
              formatTanggal(tanggal),
              style: TextStyle(
                color: tanggal == null
                    ? secondaryColor
                    : textColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _serviceButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
    required ColorScheme colors,
  }) {
    return OutlinedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 18),
      label: Text(
        label,
        overflow: TextOverflow.ellipsis,
      ),
      style: OutlinedButton.styleFrom(
        foregroundColor: colors.primary,
        side: BorderSide(color: colors.outline),
        padding: const EdgeInsets.symmetric(
          horizontal: 6,
          vertical: 12,
        ),
      ),
    );
  }
}
