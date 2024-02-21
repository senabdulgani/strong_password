import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:strong_password/models/password.dart';
import 'package:strong_password/provider/password/password_notifier.dart';

class HistoryPass extends StatefulWidget {
  final Password password;

  const HistoryPass({
    super.key,
    required this.password,
  });

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
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: RichText(
          text: TextSpan(children: [
            TextSpan(
                text: widget.password.name,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontSize: 20,
                )),
            const TextSpan(
              text: ' History',
              style: TextStyle(
                color: Colors.black,
                fontSize: 20,
              ),
            ),
          ]),
        ),
        centerTitle: true,
        actions: [
          GestureDetector(
            onTap: () {
              setState(() {
                widget.password.passwordHistory.clear();
              });
              Fluttertoast.showToast(
                msg: 'Password history cleared',
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.black,
                textColor: Colors.white,
                fontSize: 16.0,
              );
            },
            child: Container(
                padding: const EdgeInsets.all(10),
                color: Colors.transparent,
                child: const Icon(
                  Icons.delete_outlined,
                  color: Colors.black,
                  size: 28,
                )),
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: widget.password.passwordHistory.length,
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            title:
                Text('${index + 1}. ${widget.password.passwordHistory[index]}'),
            // subtitle:
            //     Text(widget.password.createdAt.toString().substring(0, 16)),
          );
        },
      ),
    );
  }
}
