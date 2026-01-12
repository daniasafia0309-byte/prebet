import 'package:flutter/material.dart';
import 'package:prebet/common/app_colors.dart';
import 'package:prebet/controller/user_auth_controller.dart';
import 'login.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _auth = UserAuthController();

  final nameCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final phoneCtrl = TextEditingController();
  final passCtrl = TextEditingController();
  final confirmCtrl = TextEditingController();

  bool hidePassword = true;
  bool hideConfirm = true;
  bool loading = false;

  @override
  void dispose() {
    nameCtrl.dispose();
    emailCtrl.dispose();
    phoneCtrl.dispose();
    passCtrl.dispose();
    confirmCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Container(
        height: h,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.secondaryColor,
              AppColors.primaryColor,
            ],
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: h),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _header(),
                const SizedBox(height: 30),
                _card(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _header() => Column(
        children: [
          CircleAvatar(
            radius: 55,
            backgroundColor: Colors.white,
            child: Image.asset(
              'assets/images/logo.png',
              width: 60,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Create Account',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: AppColors.textWhite,
            ),
          ),
        ],
      );

  Widget _card() => Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.cardColor,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            _field(nameCtrl, 'Full Name', Icons.person),
            const SizedBox(height: 12),

            _field(
              emailCtrl,
              'Email',
              Icons.email,
              keyboard: TextInputType.emailAddress,
            ),
            const SizedBox(height: 12),

            _field(
              phoneCtrl,
              'Phone Number',
              Icons.phone,
              keyboard: TextInputType.phone,
            ),
            const SizedBox(height: 12),

            _field(
              passCtrl,
              'Password',
              Icons.lock,
              obscure: hidePassword,
              suffix: IconButton(
                icon: Icon(
                  hidePassword
                      ? Icons.visibility_off
                      : Icons.visibility,
                ),
                onPressed: () =>
                    setState(() => hidePassword = !hidePassword),
              ),
            ),
            const SizedBox(height: 12),

            _field(
              confirmCtrl,
              'Confirm Password',
              Icons.lock,
              obscure: hideConfirm,
              suffix: IconButton(
                icon: Icon(
                  hideConfirm
                      ? Icons.visibility_off
                      : Icons.visibility,
                ),
                onPressed: () =>
                    setState(() => hideConfirm = !hideConfirm),
              ),
            ),
            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: loading ? null : _register,
                child: loading
                    ? const SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Text('Register'),
              ),
            ),
          ],
        ),
      );

  Future<void> _register() async {
    if (nameCtrl.text.trim().isEmpty ||
        emailCtrl.text.trim().isEmpty ||
        phoneCtrl.text.trim().isEmpty ||
        passCtrl.text.isEmpty ||
        confirmCtrl.text.isEmpty) {
      _toast('Please fill in all fields');
      return;
    }

    if (passCtrl.text.length < 6) {
      _toast('Password must be at least 6 characters');
      return;
    }

    if (passCtrl.text != confirmCtrl.text) {
      _toast('Password does not match');
      return;
    }

    setState(() => loading = true);

    try {
      await _auth.register(
        name: nameCtrl.text.trim(),
        email: emailCtrl.text.trim(),
        phone: phoneCtrl.text.trim(),
        password: passCtrl.text,
      );

      if (!mounted) return;

      _toast('Account created. Please login.');

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => const LoginPage(),
        ),
      );
    } catch (e) {
      _toast(e.toString());
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  Widget _field(
    TextEditingController c,
    String hint,
    IconData icon, {
    bool obscure = false,
    Widget? suffix,
    TextInputType keyboard = TextInputType.text,
  }) {
    return TextField(
      controller: c,
      obscureText: obscure,
      keyboardType: keyboard,
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: Icon(icon),
        suffixIcon: suffix,
      ),
    );
  }

  void _toast(String msg) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(msg)));
  }
}
