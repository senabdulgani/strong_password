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
  final String title = 'Passwords';

  @override
  void initState() {
    super.initState();
    _filteredPasswords = boxPasswords.values.toList() as List<Password>;
  }

  bool isCancelActive = false;
  List<Password> _filteredPasswords = [];

  void onSearch(String query) {
    if (query.isEmpty) {
      setState(() {
        _filteredPasswords = boxPasswords.values.toList() as List<Password>;
      });
    } else {
      setState(() {
        _filteredPasswords = boxPasswords
          .toMap()
          .values
          .where((password) =>
              password.name.toLowerCase().contains(query.toLowerCase()))
          .toList() as List<Password>;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: costumAppBar(title: title, color: AppColors.primaryColor),
      body: ListView(
        children: [
          SearchPassword(onSearch: onSearch),
          SingleChildScrollView(
            physics: const NeverScrollableScrollPhysics(),
            child: ListView.builder(
              itemCount: _filteredPasswords.length,
              shrinkWrap: true,
              itemBuilder: (BuildContext context, int index) {
                Password password = _filteredPasswords[index];
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
                      isUpdate: true,
                      index: _filteredPasswords.length,
                      filteredPasswords: _filteredPasswords,
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
                              _filteredPasswords.removeAt(index);
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
            index: _filteredPasswords.length,
            filteredPasswords: _filteredPasswords,
            isUpdate: false,
          ).then((value) => setState(() {}));
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
