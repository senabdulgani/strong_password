import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:strong_password/View/component/costum_button.dart';
import 'package:strong_password/View/pages/Introduction/detect_password_view.dart';
import 'package:strong_password/View/pages/Introduction/hint_master_pass.dart';
import 'package:strong_password/View/pages/home_page.dart';

class CheckPassword extends StatefulWidget {
  const CheckPassword({super.key});

  @override
  State<CheckPassword> createState() => _CheckPasswordState();
}

class _CheckPasswordState extends State<CheckPassword> {
  final TextEditingController _passwordController = TextEditingController();

  bool isVisible = false;

  late final LocalAuthentication auth;
  bool _supportState = false;

  @override
  void initState() {
    super.initState();
    auth = LocalAuthentication();
    auth.isDeviceSupported().then(
          (bool isSupported) => setState(() {
            _supportState = isSupported;
          }),
        );
  }

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
    // _authenticate(true); // Todo: Burası açılacak. her setState'de çalışıyor.

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: MediaQuery.of(context).size.height * 0.2),
              Row(
                children: [
                  Text(
                    'Welcome\nBack...',
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
                isVisible: !isVisible,
                labelText: 'Password',
              ),
              const SizedBox(height: 20),
              if (_supportState)
                CostumButton(
                  onPressed: () {
                    isUserSecure().then((value) {
                      if (value) {
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const StrongPassword()));
                      }
                    });
                  },
                  buttonText: 'Log In',
                ),
              GestureDetector(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const HintPassword()));
                  },
                  child: Container(padding: const EdgeInsets.all(10), color: Colors.transparent, child: Text('Forgot Password?', style: Theme.of(context).textTheme.bodySmall))),
              Gap(MediaQuery.of(context).size.height * 0.24),
              GestureDetector(
                onTap: () {
                  _authenticate(false);
                },
                child: Container(
                  padding: const EdgeInsets.all(30),
                  color: Colors.transparent,
                  child: Transform.scale(
                    scale: 3.2,
                    child: Image.asset(
                      'assets/fingerprint.png',
                      color: Colors.green,
                      width: 30,
                      height: 30,
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

  Future<void> _authenticate(bool automaticRequest) async {
    final authenticated = await auth.authenticate(
      localizedReason: 'Please authenticate to show your passwords.',
      options: const AuthenticationOptions(
        stickyAuth: false,
        biometricOnly: true,
      ),
    );

    if (authenticated) {
      // ignore: use_build_context_synchronously
      Navigator.push(context, MaterialPageRoute(builder: (context) => const StrongPassword()));
    } else {
      if (automaticRequest == false) {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Authentication failed'),
          ),
        );
      } else {
        return;
      }
    }

    if (!mounted) {
      return;
    }
  }
}
