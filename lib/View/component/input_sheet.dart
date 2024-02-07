import 'package:flutter/material.dart';
import 'package:strong_password/models/password_model.dart';


class InputBottomSheet extends StatelessWidget {
  InputBottomSheet({super.key, required this.passwordList});

  final List<PasswordModel> passwordList;


  final TextEditingController nameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(20.0, 20.0, 20.0, MediaQuery.of(context).viewInsets.bottom),
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
              // Validate form
                if (nameController.text.isNotEmpty && passwordController.text.isNotEmpty) {
                  passwordList.add(
                      PasswordModel(
                      name: nameController.text,
                      password: passwordController.text,
                    ),
                  );                  
                  nameController.clear();
                  passwordController.clear();
                  Navigator.pop(context);
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
    );
  }
}
