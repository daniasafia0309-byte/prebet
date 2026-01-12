import 'package:flutter/material.dart';
import 'package:prebet/common/widgets/header.dart';
import 'live_tracking.dart';

class FpxGatewayPage extends StatefulWidget {
  final String orderId;
  final String bankName;
  final double amount;
  final Future<void> Function() onSuccess; // 🔥 async-safe

  const FpxGatewayPage({
    super.key,
    required this.orderId,
    required this.bankName,
    required this.amount,
    required this.onSuccess,
  });

  @override
  State<FpxGatewayPage> createState() => _FpxGatewayPageState();
}

class _FpxGatewayPageState extends State<FpxGatewayPage> {
  static const Color primaryGreen = Color(0xFF0D7C7B);

  bool isProcessing = false;
  bool isSuccess = false;
  Color get bankColor {
    final name = widget.bankName.toLowerCase();

    if (name.contains('maybank') || name.contains('mae')) {
      return const Color(0xFFFFD600);
    }
    if (name.contains('cimb')) return const Color(0xFFD32F2F);
    if (name.contains('bank islam')) return const Color(0xFFC2185B);
    if (name.contains('rhb')) return const Color(0xFF4DB6E2);
    if (name.contains('public')) return const Color(0xFFD32F2F);
    if (name.contains('hong leong')) return const Color(0xFF0D47A1);
    if (name.contains('ambank')) return const Color(0xFFC62828);
    if (name.contains('bsn')) return const Color(0xFF00838F);

    return primaryGreen;
  }

  Future<void> _processPayment() async {
    if (isProcessing) return;

    setState(() => isProcessing = true);

    try {
      // Simulate FPX redirect & bank approval
      await Future.delayed(const Duration(seconds: 3));

      // 🔥 IMPORTANT: wait until booking is updated
      await widget.onSuccess();

      if (!mounted) return;

      setState(() {
        isSuccess = true;
      });
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Payment failed. Please try again.'),
        ),
      );
    } finally {
      if (mounted) setState(() => isProcessing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: const PrebetHeader(
        title: 'FPX Online Banking',
        showBack: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: isSuccess ? _successView(context) : _paymentView(),
      ),
    );
  }

  Widget _paymentView() {
    return Column(
      children: [
        _bankHeader(),
        const SizedBox(height: 22),
        _infoCard(),
        const SizedBox(height: 10),
        const Text(
          'Please do not refresh or close this page.',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey,
            fontWeight: FontWeight.w500,
          ),
        ),
        const Spacer(),
        SizedBox(
          width: double.infinity,
          height: 56,
          child: ElevatedButton(
            onPressed: isProcessing ? null : _processPayment,
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryGreen,
              disabledBackgroundColor: Colors.grey.shade400,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            child: isProcessing
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      SizedBox(
                        height: 22,
                        width: 22,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(width: 12),
                      Text(
                        'Authorizing payment...',
                        style: TextStyle(fontSize: 15),
                      ),
                    ],
                  )
                : const Text(
                    'Pay Now',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
          ),
        ),
      ],
    );
  }

  Widget _successView(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 40),
        Icon(Icons.check_circle, size: 80, color: bankColor),
        const SizedBox(height: 16),
        const Text(
          'Payment Successful',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text(
          'Your payment via ${widget.bankName} was successful.',
          style: const TextStyle(color: Colors.grey),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 24),
        _receiptCard(),
        const Spacer(),
        SizedBox(
          width: double.infinity,
          height: 56,
          child: ElevatedButton(
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (_) =>
                      LiveTrackingPage(orderId: widget.orderId),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryGreen,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            child: const Text(
              'Return to App',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _bankHeader() {
    return Row(
      children: [
        CircleAvatar(
          radius: 24,
          backgroundColor: bankColor,
          child: Text(
            widget.bankName[0].toUpperCase(),
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            widget.bankName,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Icon(Icons.lock, color: bankColor),
      ],
    );
  }

  Widget _infoCard() {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Secure FPX Payment',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 16),
          _row('Order ID', widget.orderId),
          _row('Amount', 'RM ${widget.amount.toStringAsFixed(2)}'),
        ],
      ),
    );
  }

  Widget _receiptCard() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Transaction Receipt',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          _row('Bank', widget.bankName),
          _row('Order ID', widget.orderId),
          _row('Amount', 'RM ${widget.amount.toStringAsFixed(2)}'),
          _row('Status', 'Successful'),
          _row('Time', DateTime.now().toString()),
        ],
      ),
    );
  }

  Widget _row(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}
