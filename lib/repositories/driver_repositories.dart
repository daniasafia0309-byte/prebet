import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:prebet/lib/data/driver_model.dart';

class DriverRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // =============================== GET ALL AVAILABLE DRIVERS ===============================
  Future<List<DriverModel>> getAvailableDrivers() async {
    final query = await _firestore
        .collection('drivers')
        .where('isAvailable', isEqualTo: true)
        .get();

    return query.docs.map((doc) {
      return DriverModel.fromMap(doc.id, doc.data());
    }).toList();
  }

  // =============================== GET DRIVER BY ID ===============================
  Future<DriverModel?> getDriverById(String driverId) async {
    final doc = await _firestore
        .collection('drivers')
        .doc(driverId)
        .get();

    if (!doc.exists) return null;

    return DriverModel.fromMap(doc.id, doc.data()!);
  }

  // =============================== CREATE / UPDATE DRIVER ===============================
  Future<void> saveDriver(DriverModel driver) async {
    await _firestore
        .collection('drivers')
        .doc(driver.id)
        .set(driver.toMap());
  }

  // =============================== UPDATE DRIVER AVAILABILITY ===============================
  Future<void> updateAvailability(
    String driverId,
    bool isAvailable,
  ) async {
    await _firestore
        .collection('drivers')
        .doc(driverId)
        .update({'isAvailable': isAvailable});
  }

  // =============================== DELETE DRIVER ===============================
  Future<void> deleteDriver(String driverId) async {
    await _firestore
        .collection('drivers')
        .doc(driverId)
        .delete();
  }
}
