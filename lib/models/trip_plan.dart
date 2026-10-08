class TripPlan {
  int id;
  String namaWisata;
  DateTime tanggalMulai;
  DateTime tanggalSelesai;
  String catatan;

  TripPlan({
    required this.id,
    required this.namaWisata,
    required this.tanggalMulai,
    required this.tanggalSelesai,
    required this.catatan,
  });
}