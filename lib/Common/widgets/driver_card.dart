import 'dart:math';
import 'package:flutter/material.dart';
import 'package:prebet/data/driver_model.dart';
import 'package:prebet/screens/home/driver_detail.dart';

class DriverCard extends StatelessWidget {
  final DriverModel driver;
  final String pickupName;
  final String destinationName;
  final String bookingDate;
  final String bookingTime;
  final int passenger;

  const DriverCard({
    super.key,
    required this.driver,
    required this.pickupName,
    required this.destinationName,
    required this.bookingDate,
    required this.bookingTime,
    required this.passenger,
  });

  // Zone
  String _detectZone(String location) {
    final text = location.toUpperCase();

    if (text.contains('KSAS')) return 'KSAS';
    if (text.contains('KSAJS')) return 'KSAJS';

    return 'LUAR KAMPUS';
  }

  int _smallVariation() {
    final random = Random();
    return random.nextBool() ? 1 : 0;
  }

  // Price Logic
  int _calculatePrice() {
    final pickupZone = _detectZone(pickupName);
    final destinationZone = _detectZone(destinationName);

    if (pickupZone == destinationZone) {
      return 5 + _smallVariation();
    }

    if ((pickupZone == 'KSAJS' && destinationZone == 'LUAR KAMPUS') ||
        (pickupZone == 'LUAR KAMPUS' && destinationZone == 'KSAJS')) {
      return 6 + _smallVariation();
    }

    if ((pickupZone == 'KSAS' && destinationZone == 'LUAR KAMPUS') ||
        (pickupZone == 'LUAR KAMPUS' && destinationZone == 'KSAS')) {
      return 7 + _smallVariation();
    }

    if ((pickupZone == 'KSAS' && destinationZone == 'KSAJS') ||
        (pickupZone == 'KSAJS' && destinationZone == 'KSAS')) {
      return 8 + _smallVariation();
    }

    return 6;
  }

  @override
  Widget build(BuildContext context) {
    final int finalPrice = _calculatePrice();

    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => DriverDetailPage(
              driver: driver,
              pickupName: pickupName,
              destinationName: destinationName,
              bookingDate: bookingDate,
              bookingTime: bookingTime,
              passenger: passenger,
              price: finalPrice.toDouble(),
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: const Color(0xFF0D7C7B),
            width: 1.3,
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 28,
              backgroundColor: driver.avatarColor,
              child: Text(
                driver.name[0],
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ),

            const SizedBox(width: 16),

            // Driver info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          driver.name,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      if (driver.verified)
                        const Icon(
                          Icons.verified,
                          size: 20,
                          color: Colors.green,
                        ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${driver.car} · ${driver.plate}',
                    style: const TextStyle(fontSize: 14),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    driver.carColor,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey.shade700,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(width: 14),

            // Price & rating
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  'RM $finalPrice',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    const Icon(Icons.star, size: 18, color: Colors.orange),
                    const SizedBox(width: 4),
                    Text(
                      driver.rating.toStringAsFixed(1),
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
