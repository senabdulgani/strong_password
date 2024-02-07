import 'package:flutter/material.dart';
import 'package:strong_password/View/component/add_password_button.dart';
import 'package:strong_password/View/component/search_bar.dart';
import 'package:strong_password/common/color_constants.dart';
import 'package:strong_password/common/text_styles.dart';
import 'package:strong_password/models/password_model.dart';

class StrongPassword extends StatefulWidget {
  const StrongPassword({super.key});

  @override
  State<StrongPassword> createState() => _StrongPasswordState();
}

class _StrongPasswordState extends State<StrongPassword> {
  
  List<PasswordModel> passwordList = [
    PasswordModel(
      name: 'Ziraat Ban.',
      password: '123434',
    ),
  ];

  @override
  void initState() {
    super.initState();
    debugPrint(passwordList.length.toString());
  }

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
                  title: Text(passwordList[index].name,
                      style: ProjectTextStyles.title),
                  subtitle: Text('•' * passwordList[index].password.length,
                      style: ProjectTextStyles.password),
                  leading: CircleAvatar(
                    backgroundColor: AppColors.primaryColor,
                    child: const Icon(Icons.lock),
                  ),
                  trailing: Text('15.04', style: ProjectTextStyles.date),
                );
              },
            ),
          ],
        ),
        floatingActionButton: AddActionButton(
          passwordList: passwordList,
        ),);
  }
}




