import 'package:prebet/lib/data/driver_model.dart';
import 'package:prebet/lib/repositories/driver_repositories.dart';


class DriverController {
  final DriverRepository _repository = DriverRepository();

  // =============================== STATE ===============================
  bool isLoading = false;
  List<DriverModel> drivers = [];
  DriverModel? selectedDriver;

  // =============================== LOAD AVAILABLE DRIVERS ===============================
  Future<void> fetchAvailableDrivers() async {
    isLoading = true;

    drivers = await _repository.getAvailableDrivers();

    isLoading = false;
  }

  // =============================== LOAD DRIVER BY ID ===============================
  Future<void> fetchDriverById(String driverId) async {
    isLoading = true;

    selectedDriver = await _repository.getDriverById(driverId);

    isLoading = false;
  }

  // =============================== SAVE / UPDATE DRIVER ===============================
  Future<void> saveDriver(DriverModel driver) async {
    await _repository.saveDriver(driver);
  }

  // =============================== UPDATE DRIVER AVAILABILITY ===============================
  Future<void> setDriverAvailability(
    String driverId,
    bool isAvailable,
  ) async {
    await _repository.updateAvailability(driverId, isAvailable);
  }

  // =============================== DELETE DRIVER ===============================
  Future<void> deleteDriver(String driverId) async {
    await _repository.deleteDriver(driverId);
    drivers.removeWhere((d) => d.id == driverId);
  }
}
