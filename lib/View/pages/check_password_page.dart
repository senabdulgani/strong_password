import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:strong_password/View/component/costum_button.dart';
import 'package:strong_password/View/pages/detect_password_view.dart';
import 'package:strong_password/View/pages/home_page.dart';

class CheckPassword extends StatefulWidget {
  const CheckPassword({super.key});

  @override
  State<CheckPassword> createState() => _CheckPasswordState();
}

class _CheckPasswordState extends State<CheckPassword> {
  final TextEditingController _passwordController = TextEditingController();

  bool isVisible = false;

  Future<bool> isUserSecure() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String appPassword = prefs.getString('appPassword')!;

    if (appPassword == _passwordController.text) {
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
            SizedBox(height: MediaQuery.of(context).size.height * 0.2),
            Row(
              children: [
                Text(
                  'Hello...',
                  textAlign: TextAlign.left,
                  style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 56,
                      ),
                ),
                const Spacer(),
              ],
            ),
            const SizedBox(height: 30),
            CostumPasswordTextField(
              controller: _passwordController,
              isVisible: isVisible,
              labelText: 'Password',
            ), 
            const SizedBox(height: 30),
            CostumButton(
              onPressed: (){
                isUserSecure().then((value) {
                    if (value) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const StrongPassword()));
                    }
                  });
              },
              buttonText: 'Log In',
            ),
            GestureDetector(
                onTap: () {
                // todo: I forgot my password process.
                },
                child: Container(
                    padding: const EdgeInsets.all(10),
                    color: Colors.transparent,
                    child: Text('Forgot Password?',
                        style: Theme.of(context).textTheme.bodySmall))),
          ],
        ),
      ),
    );
  }
}