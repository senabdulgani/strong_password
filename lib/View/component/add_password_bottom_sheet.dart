import 'package:flutter/material.dart';
import 'package:strong_password/models/Hive/boxes.dart';
import 'package:strong_password/models/Hive/password.dart';

class BottomSheetComponent extends StatefulWidget {
  const BottomSheetComponent({
    super.key, 
    required this.nameController,
    required this.passwordController,
    required this.index,
  });

  final TextEditingController nameController;
  final TextEditingController passwordController;
  final int index;

  @override
  // ignore: library_private_types_in_public_api
  _BottomSheetComponentState createState() => _BottomSheetComponentState();
}

class _BottomSheetComponentState extends State<BottomSheetComponent> {


  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.fromLTRB(
            20.0, 20.0, 20.0, MediaQuery.of(context).viewInsets.bottom),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            const Text(
              'Fill out the form',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20.0),
            TextFormField(
              controller: widget.nameController,
              decoration: const InputDecoration(
                labelText: 'Name',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                value = widget.nameController.text;
              },
            ),
            const SizedBox(height: 10.0),
            TextFormField(
              controller: widget.passwordController,
              decoration: const InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                value = widget.passwordController.text;
              },
            ),
            const SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                  boxPasswords.put(
                  'key_${widget.index.toString()}',
                  Password(
                    name: widget.nameController.text,
                    password: widget.passwordController.text,
                  ),
                ).then((value) => Navigator.pop(context));
                },
              child: const Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}
