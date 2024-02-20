import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:strong_password/View/pages/Introduction/detect_password_view.dart';

class HintPassword extends StatefulWidget {
  const HintPassword({Key? key}) : super(key: key);

  @override
  State<HintPassword> createState() => _HintPasswordState();
}

class _HintPasswordState extends State<HintPassword> {
  
  String _storedText = 'You don\'t have a hint password.';

  @override
  void initState() {
    super.initState();
    _loadStoredText();
  }

  _loadStoredText() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _storedText = prefs.getString('hintPassword') ?? 'No data stored';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          children: [
            SizedBox(height: MediaQuery.of(context).size.height * 0.1),
            const Row(
              children: [
                Header(text: 'Hint Master\nPassword'),
                Spacer(),
              ],
            ),
            const Gap(20),
            Text(
              'Your hint password is: $_storedText',
              style: const TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
