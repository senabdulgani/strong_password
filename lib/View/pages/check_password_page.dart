import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:strong_password/View/pages/home_page.dart';

class CheckPassword extends StatefulWidget {
  const CheckPassword({super.key});

  @override
  State<CheckPassword> createState() => _CheckPasswordState();
}

class _CheckPasswordState extends State<CheckPassword> {

  final TextEditingController _passwordController = TextEditingController();

  Future<bool> isUserSecure() async {

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String appPassword = prefs.getString('appPassword')!;

    if(appPassword == _passwordController.text){
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            SizedBox(height: MediaQuery.of(context).size.height * 0.1),
            const Text(
              'Please enter your password',
              style: TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Password',
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                isUserSecure().then((value) {
                  if(value){
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => const StrongPassword()));
                  }
                });
              },
              child: const Text('Enter'),
            ),
          ],
        ),
      ),
    );
  }
}