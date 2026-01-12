import 'package:flutter/material.dart';
import 'package:prebet/data/location_data.dart';
import 'booking.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _dateCtrl = TextEditingController();
  final TextEditingController _timeCtrl = TextEditingController();

  String? _pickup;
  String? _destination;
  int _passenger = 1;

  static const int _maxPassenger = 4;

  final List<String> _allLocations = LocationData.allLocations;

  bool get _canSearch =>
      _pickup != null &&
      _destination != null &&
      _pickup != _destination &&
      _dateCtrl.text.isNotEmpty &&
      _timeCtrl.text.isNotEmpty;

  Future<void> _selectDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      firstDate: now,
      lastDate: now.add(const Duration(days: 30)),
      initialDate: now,
    );

    if (picked != null) {
      _dateCtrl.text =
          '${picked.day}/${picked.month}/${picked.year}';
      setState(() {});
    }
  }

  Future<void> _selectTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (picked != null) {
      _timeCtrl.text = picked.format(context);
      setState(() {});
    }
  }

  void _searchPrebet() {
    if (!_canSearch) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content:
              Text('Please complete all booking details'),
        ),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => BookingPage(
          pickupName: _pickup!,
          destinationName: _destination!,
          bookingDate: _dateCtrl.text,
          bookingTime: _timeCtrl.text,
          passenger: _passenger,
        ),
      ),
    );
  }

  Iterable<String> _filterLocations(String query) {
    if (query.isEmpty) {
      return _allLocations;
    }

    final lowerQuery = query.toLowerCase();

    return _allLocations.where((location) {
      return location
          .toLowerCase()
          .split(RegExp(r'\s+|&|-'))
          .any((word) => word.startsWith(lowerQuery));
    });
  }

  @override
  void dispose() {
    _dateCtrl.dispose();
    _timeCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F8),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
        child: SizedBox(
          height: 54,
          child: ElevatedButton(
            onPressed: _canSearch ? _searchPrebet : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.teal,
              disabledBackgroundColor: Colors.teal.shade200,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: const Text(
              'SEARCH PREBET',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 24, 16, 90),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.teal.shade700,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Book Your Prebet',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 6),
                  Text(
                    'Simple • Fast • Reliable',
                    style: TextStyle(color: Colors.white70),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Column(
                  children: [
                    Autocomplete<String>(
                      optionsBuilder: (value) =>
                          _filterLocations(value.text),
                      onSelected: (value) =>
                          setState(() => _pickup = value),
                      fieldViewBuilder:
                          (context, controller, focusNode, _) {
                        return TextField(
                          controller: controller,
                          focusNode: focusNode,
                          decoration: InputDecoration(
                            labelText: 'Pickup Location',
                            prefixIcon:
                                const Icon(Icons.my_location),
                            border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.circular(14),
                            ),
                          ),
                        );
                      },
                    ),

                    const SizedBox(height: 12),

                    Autocomplete<String>(
                      optionsBuilder: (value) =>
                          _filterLocations(value.text),
                      onSelected: (value) =>
                          setState(() => _destination = value),
                      fieldViewBuilder:
                          (context, controller, focusNode, _) {
                        return TextField(
                          controller: controller,
                          focusNode: focusNode,
                          decoration: InputDecoration(
                            labelText: 'Destination',
                            prefixIcon: const Icon(Icons.flag),
                            border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.circular(14),
                            ),
                          ),
                        );
                      },
                    ),

                    const SizedBox(height: 12),

                    TextField(
                      controller: _dateCtrl,
                      readOnly: true,
                      onTap: _selectDate,
                      decoration: InputDecoration(
                        labelText: 'Date',
                        prefixIcon:
                            const Icon(Icons.calendar_today),
                        border: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(14),
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    TextField(
                      controller: _timeCtrl,
                      readOnly: true,
                      onTap: _selectTime,
                      decoration: InputDecoration(
                        labelText: 'Time',
                        prefixIcon:
                            const Icon(Icons.access_time),
                        border: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(14),
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    Row(
                      children: [
                        const Icon(Icons.people),
                        const SizedBox(width: 12),
                        const Text('Passengers'),
                        const Spacer(),
                        IconButton(
                          onPressed: _passenger > 1
                              ? () =>
                                  setState(() => _passenger--)
                              : null,
                          icon: const Icon(Icons.remove),
                        ),
                        Text(
                          '$_passenger',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        IconButton(
                          onPressed: _passenger < _maxPassenger
                              ? () =>
                                  setState(() => _passenger++)
                              : null,
                          icon: const Icon(Icons.add),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
