import 'package:flutter/material.dart';

class RatingPage extends StatefulWidget {
  const RatingPage({super.key});

  @override
  State<RatingPage> createState() => _RatingPageState();
}

class _RatingPageState extends State<RatingPage> {
  int selectedRating = 0;
  final TextEditingController commentController = TextEditingController();

  @override
  void dispose() {
    commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 24),

              // ================= AVATAR =================
              const CircleAvatar(
                radius: 36,
                backgroundColor: Colors.orange,
                child: Text(
                  'A',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // ================= DRIVER NAME =================
              const Text(
                'Ahmad Zaki',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 6),

              const Text(
                'Perodua Myvi • ABC 1234',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),

              const SizedBox(height: 32),

              // ================= TITLE =================
              const Text(
                'Rate Your Trip',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 6),

              const Text(
                'How was your experience?',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),

              const SizedBox(height: 20),

              // ================= STAR RATING =================
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(5, (index) {
                  final starIndex = index + 1;
                  return IconButton(
                    icon: Icon(
                      Icons.star,
                      size: 32,
                      color: starIndex <= selectedRating
                          ? Colors.amber
                          : Colors.grey.shade400,
                    ),
                    onPressed: () {
                      setState(() {
                        selectedRating = starIndex;
                      });
                    },
                  );
                }),
              ),

              const SizedBox(height: 24),

              // ================= COMMENT LABEL =================
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Share your experience (optional)',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),

              const SizedBox(height: 8),

              // ================= COMMENT FIELD =================
              TextField(
                controller: commentController,
                maxLines: 4,
                decoration: InputDecoration(
                  hintText: 'Tell us about your ride...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide:
                        const BorderSide(color: Color(0xFF0D7C7B)),
                  ),
                ),
              ),

              const SizedBox(height: 32),

              // ================= SUBMIT BUTTON =================
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: selectedRating == 0
                      ? null
                      : () {
                          Navigator.popUntil(
                              context, (route) => route.isFirst);
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0D7C7B),
                    disabledBackgroundColor: Colors.grey.shade400,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Submit Rating',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 12),

              // ================= SKIP =================
              TextButton(
                onPressed: () {
                  Navigator.popUntil(
                      context, (route) => route.isFirst);
                },
                child: const Text(
                  'Skip for now',
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey,
                  ),
                ),
              ),

              // ✅ ruang selamat bawah (ELAK OVERFLOW)
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
