import 'package:flutter/material.dart';
import 'package:prebet/common/app_colors.dart';
import 'package:prebet/common/widgets/header.dart';

class HelpSupportPage extends StatelessWidget {
  const HelpSupportPage({super.key});

  static const double _bottomSpace = 100;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: const PrebetHeader(
        title: 'Help & Support',
        showBack: true,
      ),

      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 20, 16, _bottomSpace),
        children: [
          _sectionTitle('Frequently Asked Questions'),
          const SizedBox(height: 6),

          _faqTile(
            question: 'How do I earn points?',
            answer:
                'You will earn 2 points for every completed ride. '
                'Bonus points may be given during promotions or first-time rides.',
          ),
          _faqTile(
            question: 'How does membership work?',
            answer:
                'Membership is automatically upgraded based on your points. '
                'Silver (0–49), Gold (50–99), Platinum (100+).',
          ),
          _faqTile(
            question: 'Can my membership be downgraded?',
            answer:
                'No. Once you upgrade your membership, it will not be downgraded.',
          ),

          const SizedBox(height: 28),
          _sectionTitle('Contact Support'),

          _contactTile(
            icon: Icons.email,
            title: 'Email Support',
            subtitle: 'support@prebet.com',
          ),
          _contactTile(
            icon: Icons.phone,
            title: 'Customer Service',
            subtitle: '+60 11-2345 6789',
          ),
        ],
      ),

      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 22),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _sectionTitle('Report a Problem'),
              const SizedBox(height: 10),

              SizedBox(
                height: 54,
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () => _showReportDialog(context),
                  icon: const Icon(Icons.report_problem),
                  label: const Text(
                    'Report an Issue',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showReportDialog(BuildContext context) {
    String selectedType = 'Booking Issue';
    final TextEditingController controller = TextEditingController();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text(
          'Report an Issue',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButtonFormField<String>(
              value: selectedType,
              items: const [
                DropdownMenuItem(value: 'Booking Issue', child: Text('Booking Issue')),
                DropdownMenuItem(value: 'Payment Issue', child: Text('Payment Issue')),
                DropdownMenuItem(value: 'Driver Issue', child: Text('Driver Issue')),
                DropdownMenuItem(value: 'App Bug', child: Text('App Bug')),
                DropdownMenuItem(value: 'Other', child: Text('Other')),
              ],
              onChanged: (value) {
                if (value != null) selectedType = value;
              },
              decoration: const InputDecoration(labelText: 'Issue Type'),
            ),
            const SizedBox(height: 14),
            TextField(
              controller: controller,
              maxLines: 3,
              decoration: const InputDecoration(
                hintText: 'Describe the issue...',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),

        actions: [
          Row(
            children: [
              Expanded(
                child: TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Issue reported successfully'),
                      ),
                    );
                  },
                  child: const Text(
                    'Submit',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: Colors.black87,
        ),
      ),
    );
  }

  Widget _faqTile({
    required String question,
    required String answer,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: ExpansionTile(
        tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        title: Text(
          question,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w500,
          ),
        ),
        childrenPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        children: [
          Text(
            answer,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade600,
              height: 1.45,
            ),
          ),
        ],
      ),
    );
  }

  Widget _contactTile({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: ListTile(
        leading: Icon(icon, color: AppColors.primaryColor),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
        subtitle: Text(subtitle),
      ),
    );
  }
}
