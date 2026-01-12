import 'package:flutter/material.dart';
import 'live_tracking.dart';

class PayLaterSheet extends StatefulWidget {
  final String orderId;
  final double amount;

  const PayLaterSheet({
    super.key,
    required this.orderId,
    required this.amount,
  });

  @override
  State<PayLaterSheet> createState() => _PayLaterSheetState();
}

class _PayLaterSheetState extends State<PayLaterSheet> {
  bool agreed = false;

  static const Color primaryGreen = Color(0xFF0D7C7B);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 10),
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Pay by Cash',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _rm(widget.amount),
                        style: const TextStyle(
                          color: primaryGreen,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),

            Divider(height: 1, thickness: 1.2, color: Colors.grey.shade300),
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 18, 16, 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _greenCard(),
                    const SizedBox(height: 22),

                    _priceRow('Trip Fare', _rm(widget.amount)),
                    Divider(
                      height: 22,
                      thickness: 1.2,
                      color: Colors.grey.shade300,
                    ),
                    _priceRow(
                      'Cash to Prepare',
                      _rm(widget.amount),
                      valueColor: Colors.green,
                    ),

                    const SizedBox(height: 18),
                    _importantInfo(),
                    const SizedBox(height: 14),
                    _recommendedInfo(),
                    const SizedBox(height: 18),
                    _agreement(),
                  ],
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.fromLTRB(16, 10, 16, 18),
              child: Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 200),
                      child: agreed
                          ? _gradientConfirmButton()
                          : _disabledConfirmButton(),
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'No payment required now',
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.grey,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _confirmPayLater() async {
    if (!mounted) return;

    Navigator.pop(context);

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => LiveTrackingPage(orderId: widget.orderId),
      ),
    );
  }

  Widget _gradientConfirmButton() {
    return GestureDetector(
      key: const ValueKey('enabled'),
      onTap: _confirmPayLater,
      child: Container(
        height: 56,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF12A56B), primaryGreen],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(14),
        ),
        child: const Text(
          'Confirm Booking (Pay Cash Later)',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontSize: 15.5,
            letterSpacing: 0.3,
          ),
        ),
      ),
    );
  }

  Widget _disabledConfirmButton() {
    return Container(
      key: const ValueKey('disabled'),
      height: 56,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.grey.shade400,
        borderRadius: BorderRadius.circular(14),
      ),
      child: const Text(
        'Confirm Booking (Pay Cash Later)',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.white,
          fontSize: 15.5,
          letterSpacing: 0.3,
        ),
      ),
    );
  }

  Widget _greenCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(34),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF12A56B), primaryGreen],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(18),
      ),
      child: const Column(
        children: [
          CircleAvatar(
            radius: 28,
            backgroundColor: Colors.white,
            child: Icon(Icons.payments, color: primaryGreen, size: 30),
          ),
          SizedBox(height: 14),
          Text(
            'Pay Later By Cash',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 6),
          Text(
            'Pay to driver after trip completion',
            style: TextStyle(fontSize: 12, color: Colors.white70),
          ),
        ],
      ),
    );
  }

  Widget _importantInfo() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.blue.shade200, width: 1.1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.lightbulb_outline, color: Colors.blue),
              SizedBox(width: 6),
              Text(
                'Important Instructions:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          _bullet('Prepare exact amount or small change before driver arrives'),
          _bullet('Pay directly to driver after reaching destination'),
          _bullet('Request receipt from driver for your records'),
          _bullet('Cancellation charges may apply if cancelled'),
        ],
      ),
    );
  }

  Widget _recommendedInfo() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.green.shade50,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.green.shade300, width: 1.2),
      ),
      child: const Row(
        children: [
          Icon(Icons.attach_money, color: Colors.green),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              'Recommended\nBring RM 10.00 for easier transaction',
              style: TextStyle(fontSize: 13, color: Colors.green),
            ),
          ),
        ],
      ),
    );
  }

  Widget _agreement() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Checkbox(
          value: agreed,
          activeColor: primaryGreen,
          onChanged: (value) =>
              setState(() => agreed = value ?? false),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              'I understand and agree to pay cash of ${_rm(widget.amount)} '
              'to the driver after trip completion.',
              style: const TextStyle(fontSize: 12),
            ),
          ),
        ),
      ],
    );
  }

  Widget _priceRow(String title, String value,
      {Color valueColor = Colors.black}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: const TextStyle(fontSize: 14)),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: valueColor,
          ),
        ),
      ],
    );
  }

  static String _rm(double value) => 'RM ${value.toStringAsFixed(2)}';

  static Widget _bullet(String text) {
    return Padding(
      padding: const EdgeInsets.only(left: 6, bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('• ', style: TextStyle(color: Colors.blue)),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }
}
