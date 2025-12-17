import 'package:flutter/material.dart';
import 'pay_later.dart';

enum PaymentMethod { cash, visa, fpx, tng }

class PaymentConfirmationPage extends StatefulWidget {
  const PaymentConfirmationPage({super.key});

  @override
  State<PaymentConfirmationPage> createState() =>
      _PaymentConfirmationPageState();
}

class _PaymentConfirmationPageState extends State<PaymentConfirmationPage> {
  PaymentMethod selectedMethod = PaymentMethod.cash;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Payment Confirmation',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _driverCard(),
            const SizedBox(height: 16),

            const Text(
              'Trip Summary',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            _tripSummary(),

            const SizedBox(height: 20),

            const Text(
              'Payment Method',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),

            _selectablePayment(
              method: PaymentMethod.cash,
              icon: Icons.payments,
              title: 'Pay Later by Cash',
              subtitle: 'Cash / QR Payment',
              iconColor: Colors.green,
            ),
            _selectablePayment(
              method: PaymentMethod.visa,
              icon: Icons.credit_card,
              title: 'Visa ending 4242',
              subtitle: 'Card',
              iconColor: Colors.red,
            ),
            _selectablePayment(
              method: PaymentMethod.fpx,
              icon: Icons.account_balance,
              title: 'FPX Online Banking',
              subtitle: 'Bank Transfer',
              iconColor: Colors.blue,
            ),
            _selectablePayment(
              method: PaymentMethod.tng,
              icon: Icons.account_balance_wallet,
              title: 'Touch n Go',
              subtitle: 'E-Wallet',
              iconColor: Colors.green.shade700,
            ),

            const SizedBox(height: 20),

            _fareBreakdown(),
            const SizedBox(height: 16),
            _securePayment(),
            const SizedBox(height: 20),

            // ===== CONFIRM & PAY =====
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  if (selectedMethod == PaymentMethod.cash) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const PayLaterPage(),
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content:
                            Text('Payment method not implemented yet'),
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0D7C7B),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Confirm & Pay',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 10),

            const Center(
              child: Text(
                'By confirming, you agree to our Terms & Conditions',
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ================= PAYMENT OPTION =================
  Widget _selectablePayment({
    required PaymentMethod method,
    required IconData icon,
    required String title,
    required String subtitle,
    required Color iconColor,
  }) {
    final bool isSelected = selectedMethod == method;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedMethod = method;
        });
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? const Color(0xFF0D7C7B)
                : Colors.grey.shade300,
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            Icon(icon, color: iconColor),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600)),
                  Text(subtitle,
                      style: const TextStyle(
                          fontSize: 12, color: Colors.grey)),
                ],
              ),
            ),
            if (isSelected)
              const Icon(Icons.check_circle,
                  color: Color(0xFF0D7C7B)),
          ],
        ),
      ),
    );
  }

  // ================= SECTIONS =================

  Widget _driverCard() {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            CircleAvatar(
              radius: 24,
              backgroundColor: Colors.orange.shade200,
              child: const Text(
                'A',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
            ),
            const SizedBox(width: 12),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Ahmad Zaki',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'Perodua Myvi Black\nABC 1234',
                    style: TextStyle(
                        fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            ),
            const Column(
              children: [
                Row(
                  children: [
                    Icon(Icons.star,
                        size: 16, color: Colors.amber),
                    Text('5',
                        style: TextStyle(
                            fontWeight: FontWeight.w600)),
                  ],
                ),
                Row(
                  children: [
                    Icon(Icons.verified,
                        size: 16, color: Colors.green),
                    Text('Verified',
                        style: TextStyle(
                            fontSize: 12, color: Colors.green)),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _tripSummary() {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          children: const [
            _InfoRow(
                Icons.location_on,
                Colors.green,
                'Pickup',
                'Khar Block 4'),
            SizedBox(height: 12),
            _InfoRow(
                Icons.flag,
                Colors.red,
                'Destination',
                'Complex Academic'),
            SizedBox(height: 12),
            _InfoRow(
                Icons.access_time,
                Colors.blue,
                'Estimated Time',
                '8–10 minutes'),
          ],
        ),
      ),
    );
  }

  Widget _fareBreakdown() {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              'Fare Breakdown',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            _FareRow('Base Fare', 'RM 3.50'),
            _FareRow('Distance (2.2 km)', 'RM 1.20'),
            _FareRow('Service Fee', 'RM 0.30'),
            Divider(),
            _FareRow('Total Fare', 'RM 5.00', bold: true),
          ],
        ),
      ),
    );
  }

  Widget _securePayment() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Row(
        children: [
          Icon(Icons.security, color: Colors.blue),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              'Secure Payment\nYour payment information is encrypted and secure',
              style: TextStyle(fontSize: 13, color: Colors.blue),
            ),
          ),
        ],
      ),
    );
  }
}

// ================= HELPER WIDGETS =================

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String title;
  final String subtitle;

  const _InfoRow(this.icon, this.color, this.title, this.subtitle);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600)),
            Text(subtitle,
                style: const TextStyle(
                    fontSize: 12, color: Colors.grey)),
          ],
        ),
      ],
    );
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
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title,
              style: TextStyle(
                  fontWeight:
                      bold ? FontWeight.bold : FontWeight.normal)),
          Text(value,
              style: TextStyle(
                  fontWeight:
                      bold ? FontWeight.bold : FontWeight.normal)),
        ],
      ),
    );
  }
}
