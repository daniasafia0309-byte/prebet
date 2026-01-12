import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:prebet/controller/driver_controller.dart';
import 'package:prebet/data/driver_model.dart';
import 'package:prebet/common/widgets/driver_card.dart';
import 'package:prebet/common/widgets/header.dart';

enum SortType { price, rating }

class BookingPage extends StatefulWidget {
  final String pickupName;
  final String destinationName;
  final String bookingDate;
  final String bookingTime;
  final int passenger;

  const BookingPage({
    super.key,
    required this.pickupName,
    required this.destinationName,
    required this.bookingDate,
    required this.bookingTime,
    required this.passenger,
  });

  @override
  State<BookingPage> createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  SortType _sortType = SortType.price;
  bool _loaded = false;

  static const Map<String, Map<String, double>> _priceMatrix = {
    'Kolej Za\'ba': {
      'Pekan Tanjung Malim': 6.0,
      'Stesen KTM Tanjung Malim': 7.0,
      'Terminal Bas Tanjung Malim': 7.5,
      'Bangunan Canselor': 4.0,
      'Fakulti Sains & Matematik': 3.5,
    },
    'Kolej Aminuddin Baki': {
      'Pekan Tanjung Malim': 6.5,
      'Stesen KTM Tanjung Malim': 7.8,
      'Terminal Bas Tanjung Malim': 8.0,
      'Bangunan Canselor': 4.5,
      'Fakulti Sains & Matematik': 4.0,
    },
    'Kolej Tuanku Bainun': {
      'Pekan Tanjung Malim': 6.2,
      'Stesen KTM Tanjung Malim': 7.2,
      'Terminal Bas Tanjung Malim': 7.6,
      'Bangunan Canselor': 4.2,
      'Fakulti Sains & Matematik': 3.8,
    },
  };

  double _getPriceByLocation(String from, String to) {
    if (_priceMatrix.containsKey(from) &&
        _priceMatrix[from]!.containsKey(to)) {
      return _priceMatrix[from]![to]!;
    }

    if (_priceMatrix.containsKey(to) &&
        _priceMatrix[to]!.containsKey(from)) {
      return _priceMatrix[to]![from]!;
    }

    return 6.0; // default fallback price
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_loaded) return;
    _loaded = true;

    final basePrice = _getPriceByLocation(
      widget.pickupName,
      widget.destinationName,
    );

    context.read<DriverController>().fetchAvailableDrivers(
          basePrice: basePrice,
          passenger: widget.passenger,
        );
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<DriverController>();
    final List<DriverModel> drivers = [...controller.drivers];

    drivers.sort((a, b) {
      if (_sortType == SortType.price) {
        return a.price.compareTo(b.price);
      }
      return b.rating.compareTo(a.rating);
    });

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: const PrebetHeader(title: 'Available Drivers'),
      body: Column(
        children: [
          
          Container(
            margin: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _locationRow(
                  color: Colors.green,
                  label: 'Pickup',
                  value: widget.pickupName,
                ),
                const SizedBox(height: 10),
                _locationRow(
                  color: Colors.red,
                  label: 'Destination',
                  value: widget.destinationName,
                ),
                const Divider(height: 20),
                _infoRow(
                  icon: Icons.calendar_today,
                  label: 'Date',
                  value: widget.bookingDate,
                ),
                const SizedBox(height: 8),
                _infoRow(
                  icon: Icons.access_time,
                  label: 'Time',
                  value: widget.bookingTime,
                ),
                const SizedBox(height: 8),
                _infoRow(
                  icon: Icons.people,
                  label: 'Passengers',
                  value: widget.passenger.toString(),
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Drivers Found (${drivers.length})',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                DropdownButton<SortType>(
                  value: _sortType,
                  underline: const SizedBox(),
                  items: const [
                    DropdownMenuItem(
                      value: SortType.price,
                      child: Text('Sort by Price'),
                    ),
                    DropdownMenuItem(
                      value: SortType.rating,
                      child: Text('Sort by Rating'),
                    ),
                  ],
                  onChanged: (value) {
                    if (value != null) {
                      setState(() => _sortType = value);
                    }
                  },
                ),
              ],
            ),
          ),

          Expanded(
            child: controller.isLoading
                ? const Center(child: CircularProgressIndicator())
                : drivers.isEmpty
                    ? const Center(
                        child: Text(
                          'No drivers available',
                          style: TextStyle(color: Colors.grey),
                        ),
                      )
                    : ListView.builder(
                        padding:
                            const EdgeInsets.fromLTRB(16, 0, 16, 16),
                        itemCount: drivers.length,
                        itemBuilder: (context, index) {
                          return DriverCard(
                            driver: drivers[index],
                            pickupName: widget.pickupName,
                            destinationName: widget.destinationName,
                            bookingDate: widget.bookingDate,
                            bookingTime: widget.bookingTime,
                            passenger: widget.passenger,
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }

  Widget _locationRow({
    required Color color,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Icon(Icons.circle, color: color, size: 10),
        const SizedBox(width: 10),
        Text(
          '$label:',
          style: const TextStyle(fontSize: 13, color: Colors.grey),
        ),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _infoRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.grey),
        const SizedBox(width: 10),
        Text(
          '$label:',
          style: const TextStyle(fontSize: 13, color: Colors.grey),
        ),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}
