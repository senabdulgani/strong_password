import 'package:flutter/material.dart';
import 'package:strong_password/View/component/add_password_button.dart';
import 'package:strong_password/View/component/search_bar.dart';
import 'package:strong_password/common/color_constants.dart';
import 'package:strong_password/common/text_styles.dart';
import 'package:strong_password/models/Hive/boxes.dart';
import 'package:strong_password/models/Hive/password.dart';

class StrongPassword extends StatefulWidget {
  const StrongPassword({super.key});

  @override
  State<StrongPassword> createState() => _StrongPasswordState();
}

class _StrongPasswordState extends State<StrongPassword> {

   
  final TextEditingController nameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();


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
            itemCount: boxPasswords.length,
            itemBuilder: (BuildContext context, int index) {
              Password password = boxPasswords.getAt(index);
              return ListTile(
                tileColor: Colors.grey.shade700,
                contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                title: Text(password.name, style: ProjectTextStyles.title),
                subtitle: Text('•' * password.password.toString().length,
                    style: ProjectTextStyles.password),
                leading: CircleAvatar(
                  backgroundColor: AppColors.primaryColor,
                  child: const Icon(Icons.lock),
                ),
                onTap: () {
                  // todo: Password detail page
                  
                },
                trailing: SizedBox(
                  width: 220,
                  child: Row(
                    children: [
                      const SizedBox(width: 100),
                      IconButton(
                        onPressed: () {
                          setState(() {
                            boxPasswords.deleteAt(index);
                          });
                        },
                        icon: const Icon(Icons.delete),
                        color: Colors.red,
                      ),
                      Text('15.04', style: ProjectTextStyles.date),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(56)),
        ),
        // todo Yuvarlak yap.
        backgroundColor: AppColors.primaryColor,
        onPressed: () {
          showModalBottomSheet(context: context, builder: (context) {
          return BottomSheetComponent(
            nameController: nameController,
            passwordController: passwordController,
          );
        }).then((value) => setState(() {}));
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
