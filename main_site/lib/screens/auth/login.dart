import 'package:flutter/material.dart';
import 'package:main_site/screens/home/home.dart';
import 'package:main_site/services/api-service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool passwordObscure = true;
  bool isLoading = false;
  String errorText = '';

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> login(String username, String password) async {
    setState(() {
      isLoading = true;
      errorText = '';
    });

    try {
      final api = ApiService();
      final prefs = await SharedPreferences.getInstance();

      final data = await api.login(username, password);

      await prefs.setBool('isLoggedIn', true);
      await prefs.setString('userId', data['user_id']);

      if (!mounted) return;

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const Home()),
        (_) => false,
      );
    } catch (e) {
      setState(() {
        errorText = e.toString().replaceFirst('Exception: ', '');
      });
    } finally {
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(15)),
      ),
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const SizedBox(height: 40),
          const Text(
            "LOGIN",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 28),
          ),
          const SizedBox(height: 20),

          /// EMAIL
          TextField(
            controller: emailController,
            keyboardType: TextInputType.emailAddress,
            decoration: _inputDecoration(hint: 'Email', icon: Icons.email),
          ),

          const SizedBox(height: 20),

          /// PASSWORD
          TextField(
            controller: passwordController,
            obscureText: passwordObscure,
            decoration: _inputDecoration(
              hint: 'Password',
              icon: Icons.lock,
              suffix: IconButton(
                onPressed: () {
                  setState(() => passwordObscure = !passwordObscure);
                },
                icon: Icon(
                  passwordObscure ? Icons.visibility : Icons.visibility_off,
                ),
              ),
            ),
          ),

          const SizedBox(height: 20),

          /// LOGIN BUTTON
          ElevatedButton(
            onPressed: isLoading
                ? null
                : () => login(
                    emailController.text.trim(),
                    passwordController.text,
                  ),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromARGB(255, 2, 78, 78),
            ),
            child: isLoading
                ? const CircularProgressIndicator(color: Colors.white)
                : const Text("Login", style: TextStyle(color: Colors.white)),
          ),

          const SizedBox(height: 12),

          /// ERROR MESSAGE
          if (errorText.isNotEmpty)
            Text(
              errorText,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.red),
            ),
        ],
      ),
    );
  }

  InputDecoration _inputDecoration({
    required String hint,
    required IconData icon,
    Widget? suffix,
  }) {
    return InputDecoration(
      hintText: hint,
      icon: Icon(icon, color: Colors.black),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: Color(0xFF6B1B9A), width: 2),
      ),
      suffixIcon: suffix,
    );
  }
}
