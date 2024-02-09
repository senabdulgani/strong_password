import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:strong_password/View/pages/home_page.dart';

class DetectPassword extends StatefulWidget {
  const DetectPassword({super.key});

  @override
  State<DetectPassword> createState() => _DetectPasswordState();
}

class _DetectPasswordState extends State<DetectPassword> {
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  String _detectedPassword = '';

  void setFirstLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('firstLogin', false);
  }

  // Buradaki şifre mekanizmasını iyileştir. Belirli kurallar getir.
  void _detectPassword() async {
    String password = _passwordController.text;
    String confirmPassword = _confirmPasswordController.text;
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (password.isEmpty || confirmPassword.isEmpty) {
      setState(() {
        _detectedPassword = 'Please fill password fields!';
      });
    } else if (password != confirmPassword) {
      setState(() {
        _detectedPassword = 'Passwords do not match!';
      });
    } else if (password == confirmPassword) {
      setState(() {
        _detectedPassword = password;
        prefs.setString('appPassword', _detectedPassword);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const StrongPassword()));
              // Belli koşullar sağlanamazsa buradan ileri gidememeli.
        },
        child: const Icon(Icons.arrow_forward),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            SizedBox(height: MediaQuery.of(context).size.height * 0.1),
            const Text(
              'Detect Password',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: _confirmPasswordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Confirm Password',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _detectPassword,
              child: const Text('Detect Password'),
            ),
            const SizedBox(height: 20),
            Text(
              _detectedPassword,
              style: TextStyle(
                color: _detectedPassword == 'Passwords do not match!'
                    ? Colors.red
                    : Colors.green,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
