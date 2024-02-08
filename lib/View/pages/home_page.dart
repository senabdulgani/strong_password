import 'package:flutter/material.dart';
import 'package:strong_password/View/component/costum_app_bar.dart';
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
  
  List<TextEditingController> controllers = [];
  final String title = 'Passwords';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: costumAppBar(title: title, color: AppColors.primaryColor),
      body: ListView(
        children: [
          const SearchPassword(),
          ListView.builder(
            itemCount: boxPasswords.length,
            shrinkWrap: true,
            itemBuilder: (BuildContext context, int index) {
              Password password = boxPasswords.getAt(index);
              TextEditingController nameController =
                  TextEditingController(text: password.name);
              TextEditingController passwordController =
                  TextEditingController(text: password.password);
              return ListTile(
                tileColor: Colors.grey.shade700,
                contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                title: Text(password.name, style: ProjectTextStyles.title),
                subtitle: Text(
                  '•' * password.password.toString().length,
                  style: ProjectTextStyles.password,
                ),
                leading: CircleAvatar(
                  backgroundColor: AppColors.primaryColor,
                  child: const Icon(Icons.lock),
                ),
                onTap: () {
                  showPasswordEditBottomSheet(
                    context,
                    nameController: nameController,
                    passwordController: passwordController,
                    index: index,
                  ).then((value) => setState(() {}));
                },
                trailing: SizedBox(
                  width: 220,
                  child: Row(
                    children: [
                      const SizedBox(width: 90),
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
          // Yeni bir controller oluşturarak alt sayfayı gösterin
          TextEditingController nameController = TextEditingController();
          TextEditingController passwordController = TextEditingController();
          showPasswordEditBottomSheet(
            context,
            nameController: nameController,
            passwordController: passwordController,
            index: 0,
          ).then((value) => setState(() {}));
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
