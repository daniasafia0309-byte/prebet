import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:prebet/data/driver_model.dart';
import 'package:prebet/common/widgets/header.dart';
import 'package:prebet/controller/booking_controller.dart';
import 'payment.dart';

class DriverDetailPage extends StatefulWidget {
  final DriverModel driver;
  final String pickupName;
  final String destinationName;
  final String bookingDate;
  final String bookingTime;
  final int passenger;
  final double price;

  const DriverDetailPage({
    super.key,
    required this.driver,
    required this.pickupName,
    required this.destinationName,
    required this.bookingDate,
    required this.bookingTime,
    required this.passenger,
    required this.price,
  });

  @override
  State<DriverDetailPage> createState() => _DriverDetailPageState();
}

class _DriverDetailPageState extends State<DriverDetailPage> {
  static const Color primaryGreen = Color(0xFF0D7C7B);
  bool _isSubmitting = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: const PrebetHeader(title: 'Driver Details'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
        child: Column(
          children: [
            _driverCard(),
            const SizedBox(height: 16),
            _safetyInfo(),
            const SizedBox(height: 24),
            _bookButton(context),
          ],
        ),
      ),
    );
  }

  Widget _driverCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(22, 30, 22, 28),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: primaryGreen, width: 1.4),
      ),
      child: Column(
        children: [
          CircleAvatar(
            radius: 48,
            backgroundColor: widget.driver.avatarColor,
            child: Text(
              widget.driver.name[0],
              style: const TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            widget.driver.name,
            style: const TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.star, size: 20, color: Colors.orange),
              const SizedBox(width: 6),
              Text(
                widget.driver.rating.toStringAsFixed(1),
                style: const TextStyle(fontSize: 16),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Divider(color: Colors.grey.shade300),
          const SizedBox(height: 16),
          _infoItem(Icons.directions_car, 'Vehicle',
              '${widget.driver.car} • ${widget.driver.carColor}'),
          _infoItem(Icons.confirmation_number, 'Plate', widget.driver.plate),
          _infoItem(Icons.calendar_today, 'Date', widget.bookingDate),
          _infoItem(Icons.access_time, 'Time', widget.bookingTime),
          _infoItem(Icons.people, 'Passengers', widget.passenger.toString()),
          _infoItem(
            Icons.attach_money,
            'Price',
            'RM ${widget.price.toStringAsFixed(2)}',
          ),
        ],
      ),
    );
  }

  Widget _safetyInfo() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.teal.shade50,
        borderRadius: BorderRadius.circular(14),
      ),
      child: const Row(
        children: [
          Icon(Icons.info_outline, color: primaryGreen),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              'Your safety is our priority. All drivers are verified.',
              style: TextStyle(fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }

  Widget _bookButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: _isSubmitting ? null : () => _showConfirmBottomSheet(context),
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryGreen,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: const Text(
          'Book Driver',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  void _showConfirmBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (sheetContext) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(20, 28, 20, 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Confirm Booking',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              _summaryRow('Pickup', widget.pickupName),
              _summaryRow('Destination', widget.destinationName),
              _summaryRow('Date', widget.bookingDate),
              _summaryRow('Time', widget.bookingTime),
              _summaryRow('Passengers', widget.passenger.toString()),
              const Divider(height: 32),
              _summaryRow(
                'Total Price',
                'RM ${widget.price.toStringAsFixed(2)}',
                bold: true,
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _isSubmitting
                      ? null
                      : () => _confirmBooking(context, sheetContext),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryGreen,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: _isSubmitting
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          'Confirm Booking',
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _confirmBooking(
    BuildContext context,
    BuildContext sheetContext,
  ) async {
    setState(() => _isSubmitting = true);

    final bookingController = context.read<BookingController>();

    try {
      final orderId = await bookingController.createBooking(
        pickup: widget.pickupName,
        destination: widget.destinationName,
        bookingDate: widget.bookingDate,
        bookingTime: widget.bookingTime,
        passenger: widget.passenger,
        price: widget.price,
        driverId: widget.driver.id,
        driverName: widget.driver.name,
        driverAvatarColor: widget.driver.avatarColor.value,
      );

      if (!mounted) return;

      Navigator.pop(sheetContext);

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => PaymentPage(
            orderId: orderId,
            amount: widget.price,
            pickup: widget.pickupName,
            destination: widget.destinationName,
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      Navigator.pop(sheetContext);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Booking failed. Please try again.'),
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }

  Widget _summaryRow(String title, String value, {bool bold = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontWeight: bold ? FontWeight.bold : FontWeight.w500,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontWeight: bold ? FontWeight.bold : FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoItem(IconData icon, String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        children: [
          Icon(icon, color: primaryGreen),
          const SizedBox(width: 14),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: primaryGreen,
                ),
              ),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
