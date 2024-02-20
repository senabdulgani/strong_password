import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:strong_password/models/password.dart';
import 'package:strong_password/provider/password/password_notifier.dart';

class HistoryPass extends StatefulWidget {
  final Password password;
  
  const HistoryPass({
    Key? key,
    required this.password,
  }) : super(key: key);

  @override
  State<HistoryPass> createState() => _HistoryPassState();
}

class _HistoryPassState extends State<HistoryPass> {
  late final PasswordNotifier passwordProvider;

  @override
  void initState() {
    super.initState();
    passwordProvider = Provider.of<PasswordNotifier>(context, listen: false);
    getPasswords();
  }

  Future<void> getPasswords() async {
    await passwordProvider.getAllPasswords();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: widget.password.passwordHistory.length,
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            title: Text('Password History ${index + 1}: ${widget.password.passwordHistory[index]}'),
          );
        },
      ),
    );
  }
}
