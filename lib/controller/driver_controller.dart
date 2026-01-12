import 'package:flutter/material.dart';
import 'package:prebet/data/driver_model.dart';
import 'package:prebet/repositories/driver_repositories.dart';

class DriverController extends ChangeNotifier {
  final DriverRepository _repository = DriverRepository();

  bool isLoading = false;
  List<DriverModel> drivers = [];
  DriverModel? selectedDriver;

  // =========================
  // FETCH AVAILABLE DRIVERS
  // =========================
  Future<void> fetchAvailableDrivers({
    required double basePrice, // 🔥 LOCATION-BASED PRICE
    required int passenger,
  }) async {
    isLoading = true;
    notifyListeners();

    try {
      final allDrivers = await _repository.getAvailableDrivers();

      // Ambil max 5 driver
      allDrivers.shuffle();
      drivers = allDrivers.take(5).toList();

      for (var driver in drivers) {
        final extraPassengerCharge =
            passenger > 1 ? (passenger - 1) * 1.0 : 0.0;

        final finalPrice =
            basePrice + extraPassengerCharge;

        driver.price = finalPrice;
      }
    } catch (e) {
      debugPrint('❌ ERROR fetchAvailableDrivers: $e');
      drivers = [];
    }

    isLoading = false;
    notifyListeners();
  }

  // =========================
  // FETCH DRIVER BY ID
  // =========================
  Future<void> fetchDriverById(String driverId) async {
    isLoading = true;
    notifyListeners();

    try {
      selectedDriver = await _repository.getDriverById(driverId);
    } catch (e) {
      debugPrint('❌ ERROR fetchDriverById: $e');
    }

    isLoading = false;
    notifyListeners();
  }
}
