import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:prebet/data/driver_model.dart';

class DriverRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<DriverModel>> getAvailableDrivers() async {
    final query = await _firestore
        .collection('drivers')
        .where('isAvailable', isEqualTo: true)
        .get();

    return query.docs
        .map((doc) => DriverModel.fromFirestore(doc))
        .toList();
  }

  Future<DriverModel?> getDriverById(String driverId) async {
    final doc =
        await _firestore.collection('drivers').doc(driverId).get();

    if (!doc.exists) return null;
    return DriverModel.fromFirestore(doc);
  }
}
