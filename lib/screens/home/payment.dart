import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:prebet/common/widgets/header.dart';
import 'package:prebet/controller/booking_controller.dart';
import 'fpx_gateway.dart';
import 'pay_later_sheet.dart';

enum PaymentMethod { cash, fpx, tng }

class PaymentPage extends StatefulWidget {
  final String orderId;
  final double amount;
  final String pickup;
  final String destination;

  const PaymentPage({
    super.key,
    required this.orderId,
    required this.amount,
    required this.pickup,
    required this.destination,
  });

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  PaymentMethod selectedMethod = PaymentMethod.cash;
  String? selectedBank;
  bool _isProcessing = false;

  static const Color primaryGreen = Color(0xFF0D7C7B);

  final List<String> fpxBanks = [
    'Maybank',
    'CIMB Bank',
    'Bank Islam',
    'RHB Bank',
    'Public Bank',
    'Hong Leong Bank',
    'AmBank',
    'BSN',
  ];

  double get totalAmount => widget.amount;
  double get serviceFee => 0.30;

  double get baseFare {
    final value = totalAmount - serviceFee;
    return value < 0 ? 0 : value;
  }

  bool get canProceed {
    if (selectedMethod == PaymentMethod.fpx) {
      return selectedBank != null;
    }
    return true;
  }

  void _showPayLaterSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => PayLaterSheet(
        orderId: widget.orderId,
        amount: totalAmount,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      stream: FirebaseFirestore.instance
          .collection('bookings')
          .doc(widget.orderId)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData || snapshot.data!.data() == null) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final data = snapshot.data!.data()!;
        final String driverName = data['driverName'] ?? 'Driver';
        final int avatarColorValue =
            data['driverAvatarColor'] ?? primaryGreen.value;

        final String bookingDate = data['bookingDate'] ?? '-';
        final String bookingTime = data['bookingTime'] ?? '-';
        final int passenger = data['passenger'] ?? 1;

        return Scaffold(
          backgroundColor: const Color(0xFFF5F5F5),
          appBar: const PrebetHeader(title: 'Payment Confirmation'),
          body: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 18),
            child: Column(
              children: [
                _driverCard(driverName, Color(avatarColorValue)),
                _tripSummary(
                  bookingDate: bookingDate,
                  bookingTime: bookingTime,
                  passenger: passenger,
                ),
                _paymentMethods(),
                _fareBreakdown(),
                _secureInfo(),
                const SizedBox(height: 14),
                _confirmButton(context),
                const SizedBox(height: 8),
                const Text(
                  'By confirming, you agree to our Terms & Conditions',
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _confirmButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: canProceed && !_isProcessing
            ? () async {
                if (selectedMethod == PaymentMethod.fpx) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => FpxGatewayPage(
                        orderId: widget.orderId,
                        bankName: selectedBank!,
                        amount: totalAmount,
                        onSuccess: () async {
                          // ✅ FPX: update booking sahaja
                          final bookingController =
                              context.read<BookingController>();
                          await bookingController
                              .markAsPaid(widget.orderId);
                        },
                      ),
                    ),
                  );
                } else if (selectedMethod == PaymentMethod.cash) {
                  _showPayLaterSheet();
                }
              }
            : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryGreen,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        ),
        child: _isProcessing
            ? const CircularProgressIndicator(color: Colors.white)
            : const Text(
                'Confirm & Pay',
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
              ),
      ),
    );
  }

  Widget _driverCard(String name, Color avatarColor) {
    return _card(
      Row(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: avatarColor,
            child: Text(
              name.isNotEmpty ? name[0] : '?',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              name,
              style:
                  const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ),
          const Icon(Icons.verified, color: Colors.green),
        ],
      ),
    );
  }

  Widget _tripSummary({
    required String bookingDate,
    required String bookingTime,
    required int passenger,
  }) {
    return _card(
      Column(
        children: [
          _tripRow(Icons.my_location, Colors.green, 'Pickup', widget.pickup),
          _tripRow(Icons.location_on, Colors.redAccent, 'Destination',
              widget.destination),
          _tripRow(Icons.calendar_today, Colors.blueGrey, 'Date', bookingDate),
          _tripRow(Icons.access_time, Colors.orange, 'Time', bookingTime),
          _tripRow(Icons.people, Colors.purple, 'Passengers',
              passenger.toString()),
        ],
      ),
    );
  }

  Widget _tripRow(
      IconData icon, Color color, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, size: 20, color: color),
          const SizedBox(width: 14),
          SizedBox(
            width: 110,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          const Spacer(),
          Expanded(child: Text(value, textAlign: TextAlign.right)),
        ],
      ),
    );
  }

  Widget _paymentMethods() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Payment Method',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
        ),
        const SizedBox(height: 8),
        _paymentTile(
          PaymentMethod.cash,
          Icons.payments,
          'Pay Later (Cash / QR Pay)',
        ),
        _fpxTile(),
      ],
    );
  }

  Widget _paymentTile(
      PaymentMethod method, IconData icon, String title) {
    final selected = selectedMethod == method;

    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () {
        setState(() {
          selectedMethod = method;
          if (method != PaymentMethod.fpx) selectedBank = null;
        });
      },
      child: _card(
        Row(
          children: [
            Icon(icon, size: 26, color: _iconColor(method)),
            const SizedBox(width: 16),
            Expanded(child: Text(title)),
            if (selected)
              const Icon(Icons.check_circle,
                  color: primaryGreen, size: 22),
          ],
        ),
        border: selected ? primaryGreen : Colors.grey.shade300,
      ),
    );
  }

  Widget _fpxTile() {
    final selected = selectedMethod == PaymentMethod.fpx;

    return _card(
      Column(
        children: [
          InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: () =>
                setState(() => selectedMethod = PaymentMethod.fpx),
            child: Row(
              children: [
                const Icon(Icons.account_balance,
                    size: 26, color: Colors.orange),
                const SizedBox(width: 16),
                const Expanded(child: Text('FPX Online Banking')),
                Icon(
                  selected
                      ? Icons.keyboard_arrow_up
                      : Icons.keyboard_arrow_down,
                ),
              ],
            ),
          ),
          if (selected) ...[
            const SizedBox(height: 12),
            DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                isExpanded: true,
                value: selectedBank,
                hint: const Text('Select Bank'),
                items: fpxBanks
                    .map(
                      (bank) => DropdownMenuItem(
                        value: bank,
                        child: Text(bank),
                      ),
                    )
                    .toList(),
                onChanged: (value) =>
                    setState(() => selectedBank = value),
              ),
            ),
          ],
        ],
      ),
      border: selected ? primaryGreen : Colors.grey.shade300,
    );
  }

  Widget _fareBreakdown() {
    return _card(
      Column(
        children: [
          _FareRow('Base Fare', 'RM ${baseFare.toStringAsFixed(2)}'),
          _FareRow('Service Fee', 'RM ${serviceFee.toStringAsFixed(2)}'),
          const Divider(height: 24),
          _FareRow(
            'Total',
            'RM ${totalAmount.toStringAsFixed(2)}',
            bold: true,
          ),
        ],
      ),
    );
  }

  Widget _secureInfo() {
    return Container(
      margin: const EdgeInsets.only(bottom: 11),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.blue.shade200),
      ),
      child: const Row(
        children: [
          Icon(Icons.security, color: Colors.blue),
          SizedBox(width: 14),
          Expanded(
            child: Text(
              'Your payment is secure & encrypted',
              style: TextStyle(
                color: Colors.blue,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _card(Widget child, {Color? border}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 11),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: border ?? Colors.grey.shade300),
      ),
      child: child,
    );
  }

  Color _iconColor(PaymentMethod method) {
    switch (method) {
      case PaymentMethod.cash:
        return Colors.green;
      case PaymentMethod.fpx:
        return Colors.orange;
      case PaymentMethod.tng:
        return Colors.blue;
    }
  }
}

class _FareRow extends StatelessWidget {
  final String title;
  final String value;
  final bool bold;

  const _FareRow(this.title, this.value, {this.bold = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontWeight: bold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontWeight: bold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
