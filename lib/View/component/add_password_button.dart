import 'package:flutter/material.dart';
import 'package:strong_password/models/Hive/boxes.dart';
import 'package:strong_password/models/Hive/password.dart';


class BottomSheetComponent extends StatelessWidget {
  const BottomSheetComponent({
    super.key,
    required this.nameController,
    required this.passwordController,
  });

  final TextEditingController nameController;
  final TextEditingController passwordController;

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
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10.0),
            TextField(
              controller: passwordController,
              decoration: const InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                if (nameController.text.isNotEmpty &&
                    passwordController.text.isNotEmpty) {
                  boxPasswords.put(
                      'key_$nameController',
                      Password(
                          name: nameController.text,
                          password: passwordController.text));
                  Navigator.pop(context);
                  nameController.clear();
                  passwordController.clear();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please fill out both fields.'),
                    ),
                  );
                }
              },
              child: const Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}
