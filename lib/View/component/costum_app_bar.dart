import 'package:flutter/material.dart';
import 'package:strong_password/View/component/add_password_bottom_sheet.dart';
import 'package:strong_password/View/pages/password_generator.dart';
import 'package:strong_password/common/color_constants.dart';
import 'package:strong_password/common/text_styles.dart';
import 'package:strong_password/models/password.dart';

costumAppBar(
    {required String title,
    required Color color,
    required BuildContext context}) {
  return AppBar(
    title: Text(title),
    centerTitle: true,
    backgroundColor: color,
    actions: [
      Padding(
        padding: const EdgeInsets.only(right: 10.0),
        child: IconButton(
          onPressed: () {
            // showPasswordGenerator(context);
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return const PasswordGeneratorView();
            }));
          },
          icon: const Icon(Icons.password),
        ),
      ),
    ],
  );
}

void showCostumPasswordDetail(
    {required BuildContext context,
    required String title,
    required String content}) {
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppColors.backgroundColor,
          title: Text(title, style: ProjectTextStyles.title),
          content: Text(content, style: ProjectTextStyles.password),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Close', style: ProjectTextStyles.button),
            ),
          ],
        );
      });
}

Future showPasswordEditBottomSheet(
  BuildContext context, {
  required TextEditingController nameController,
  required TextEditingController passwordController,
  required bool isUpdate,
  required int index,
  required List<Password> filteredPasswords,
}) {
  return showModalBottomSheet(
      context: context,
      builder: (context) {
        return BottomSheetComponent(
          nameController: nameController,
          passwordController: passwordController,
          index: index,
          filteredPasswords: filteredPasswords,
          isUpdate: isUpdate,
        );
      });
}

// Future<dynamic> showPasswordGenerator(
//   BuildContext context,
// ) {
//   return showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       builder: (context) {
//         return null;
//       });
// }
