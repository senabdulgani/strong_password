import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:strong_password/View/component/costum_button.dart';
import 'package:strong_password/View/pages/home_page.dart';

// ignore: must_be_immutable
class DetectPassword extends StatefulWidget {
  DetectPassword({
    super.key,
    this.isUpdate,
  });

  bool? isUpdate = false;

  @override
  State<DetectPassword> createState() => _DetectPasswordState();
}

class _DetectPasswordState extends State<DetectPassword> {
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  String _detectedPassword = '';

  bool isVisible = false;

  void setFirstLoginFalse() async {
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
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     // Belli koşullar sağlanamazsa buradan ileri gidememeli.
      //   },
      //   child: const Icon(Icons.arrow_forward),
      // ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            SizedBox(height: MediaQuery.of(context).size.height * 0.1),
            Row(
              children: [
                widget.isUpdate == true
                    ? const Header(
                        text: 'Change\nMaster\nPassword...',
                      )
                    : const Header(
                        text: 'Detect\nMaster\nPassword...',
                      ),
                const Spacer()
              ],
            ),
            const SizedBox(height: 20),
            CostumTextField(
              controller: _passwordController,
              isVisible: isVisible,
              labelText: widget.isUpdate == true ? 'New Password' : 'Password',
            ),
            const SizedBox(height: 12),
            CostumTextField(
              controller: _confirmPasswordController,
              isVisible: isVisible,
              labelText: widget.isUpdate == true
                  ? 'Confirm New Password'
                  : 'Confirm Password',
            ),
            const SizedBox(height: 20),
            CostumButton(
              onPressed: () {
                _detectPassword();
                setFirstLoginFalse();
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const StrongPassword()));
              },
              buttonText:
                  widget.isUpdate == true ? 'Change Password' : 'Sign In',
            ),
          ],
        ),
      ),
    );
  }
}

class Header extends StatelessWidget {
  const Header({
    super.key,
    required this.text,
  });

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: TextAlign.left,
      style: Theme.of(context).textTheme.headlineLarge!.copyWith(
            fontWeight: FontWeight.bold,
            fontSize: 48,
          ),
    );
  }
}

// ignore: must_be_immutable
class CostumTextField extends StatefulWidget {
  CostumTextField({
    super.key,
    required this.controller,
    required this.isVisible,
    required this.labelText,
  });

  final TextEditingController controller;
  bool isVisible;
  final String labelText;

  @override
  State<CostumTextField> createState() => _CostumTextFieldState();
}

class _CostumTextFieldState extends State<CostumTextField> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        TextField(
          cursorColor: Colors.black,
          onEditingComplete: () {},
          textInputAction: TextInputAction.done,
          controller: widget.controller,
          obscureText: widget.isVisible,
          decoration: InputDecoration(
            floatingLabelStyle: const TextStyle(
              color: Colors.black,
            ),
            focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.black,
              ),
            ),
            disabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.black,
              ),
            ),
            border: const OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.black,
              ),
            ),
            labelText: widget.labelText,
          ),
        ),
        Positioned(
          right: 10,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(
              onPressed: () {
                if (widget.controller.text.isNotEmpty) {
                  setState(() {
                    widget.isVisible = !widget.isVisible;
                  });
                } else {
                  return;
                }
              },
              icon: Icon(
                  widget.isVisible
                      ? Icons.visibility_off_rounded
                      : Icons.remove_red_eye_rounded,
                  color: Colors.grey),
            ),
          ),
        ),
      ],
    );
  }
}
