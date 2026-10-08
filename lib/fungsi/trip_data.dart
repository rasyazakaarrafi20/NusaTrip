import '../models/trip_plan.dart';

class TripData {
  static final List<TripPlan> rencana = [];

  static void tambah(TripPlan trip) {
    rencana.add(trip);
  }

  static void hapus(TripPlan trip) {
    rencana.remove(trip);
  }
}