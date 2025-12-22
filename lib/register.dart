import 'package:flutter/material.dart';
import 'login.dart';
import 'common/app_colors.dart';
import 'controller/user_auth_controller.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _auth = UserAuthController();
  final name = TextEditingController();
  final email = TextEditingController();
  final phone = TextEditingController();
  final pass = TextEditingController();
  final confirm = TextEditingController();

  bool hide = true, loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (c, s) => SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: s.maxHeight),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [AppColors.primaryLight, AppColors.primaryDark],
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 60),

                  CircleAvatar(
                    radius: 55,
                    backgroundColor: Colors.white,
                    child: Image.asset('assets/images/logoo.png', width: 60),
                  ),

                  const SizedBox(height: 16),
                  const Text(
                    'Create Account',
                    style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),

                  const SizedBox(height: 30),

                  _card(),

                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _card() => Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            _field(name, 'Full Name', Icons.person),
            const SizedBox(height: 12),
            _field(email, 'Email', Icons.email),
            const SizedBox(height: 12),
            _field(phone, 'Phone Number', Icons.phone),
            const SizedBox(height: 12),
            _field(
              pass,
              'Password',
              Icons.lock,
              obscure: hide,
              suffix: IconButton(
                icon: Icon(hide ? Icons.visibility_off : Icons.visibility),
                onPressed: () => setState(() => hide = !hide),
              ),
            ),
            const SizedBox(height: 12),
            _field(confirm, 'Confirm Password', Icons.lock, obscure: hide),

            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: loading ? null : _register,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: loading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                        'Register',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
              ),
            ),

            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                'Login',
                style: TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      );

  Future<void> _register() async {
    if (pass.text != confirm.text) {
      _toast('Password not match');
      return;
    }

    setState(() => loading = true);
    try {
      await _auth.register(
        name: name.text.trim(),
        email: email.text.trim(),
        phone: phone.text.trim(),
        password: pass.text.trim(),
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginPage()),
      );
    } catch (e) {
      _toast('Register failed');
    }
    setState(() => loading = false);
  }

  Widget _field(TextEditingController c, String h, IconData i,
          {bool obscure = false, Widget? suffix}) =>
      TextField(
        controller: c,
        obscureText: obscure,
        decoration: InputDecoration(
          hintText: h,
          prefixIcon: Icon(i),
          suffixIcon: suffix,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );

  void _toast(String m) =>
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(m)),
      );
}
