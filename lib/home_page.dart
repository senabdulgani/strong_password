import 'package:flutter/material.dart';
import 'package:strong_password/common/color_constants.dart';
import 'package:strong_password/models/password_model.dart';

class StrongPassword extends StatefulWidget {
  const StrongPassword({super.key});

  @override
  State<StrongPassword> createState() => _StrongPasswordState();
}

class _StrongPasswordState extends State<StrongPassword> {

  List<PasswordModel> passwordList = [
    PasswordModel(password: 'abdulganisen123', name: 'abdulganisen'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.backgroundColor,
        appBar: AppBar(
          title: const Text('My Passwords'),
          centerTitle: true,
          backgroundColor: AppColors.primaryColor,
        ),
        body: ListView(
          children: [
            const SearchPassword(),
            ListView.builder(
              shrinkWrap: true,
              itemCount: passwordList.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  tileColor: Colors.grey.shade700,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                  title: Text(passwordList[index].password, style: const TextStyle(color: Colors.white)),
                  leading: const CircleAvatar(
                    backgroundColor: Colors.grey,
                    child: Icon(Icons.lock),
                  ),
                  trailing: const Icon(Icons.delete),
                );
              },
            ),
          ],
        ),
        floatingActionButton: const AddPasword());
  }
}

class AddPasword extends StatelessWidget {
  const AddPasword({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(56)),
      ),
      // todo Yuvarlak yap.
      backgroundColor: AppColors.primaryColor,
      onPressed: () {
        showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              builder: (BuildContext context) {
                return SingleChildScrollView(
                  child: Container(
                    padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom,
                    ),
                    child: const MyBottomSheetForm(),
                  ),
                );
              },
            );
      },
      child: const Icon(Icons.add),
    );
  }
}

class MyBottomSheetForm extends StatelessWidget {
  const MyBottomSheetForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20.0),
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
          const TextField(
            decoration: InputDecoration(
              labelText: 'Name',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 10.0),
          const TextField(
            decoration: InputDecoration(
              labelText: 'Email',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 20.0),
          ElevatedButton(
            onPressed: () {
              // Submit form logic here
              Navigator.of(context).pop();
            },
            child: const Text('Submit'),
          ),
        ],
      ),
    );
  }
}

class SearchPassword extends StatelessWidget {
  const SearchPassword({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
              child: SearchAnchor(
                builder: (BuildContext context, SearchController controller) {
              return SearchBar(
                controller: controller,
                padding: const MaterialStatePropertyAll<EdgeInsets>(
                    EdgeInsets.symmetric(horizontal: 16.0)),
                onTap: () {
                  controller.openView();
                },
                onChanged: (_) {
                  controller.openView();
                },
                leading: const Icon(Icons.search),
              );
                        }, suggestionsBuilder:
                    (BuildContext context, SearchController controller) {
              return List<ListTile>.generate(5, (int index) {
                final String item = 'item $index';
                return ListTile(
                  title: Text(item),
                  onTap: () {
                  },
                );
              });
                        }),
            );
  }
}