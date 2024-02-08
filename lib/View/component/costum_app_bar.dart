import 'package:flutter/material.dart';
import 'package:strong_password/View/component/add_password_bottom_sheet.dart';
import 'package:strong_password/common/color_constants.dart';
import 'package:strong_password/common/text_styles.dart';

costumAppBar({required String title, required Color color}) {
  return AppBar(
    title: Text(title),
    centerTitle: true,
    backgroundColor: color,
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
  bool isUpdate = false,
  required int index,
}) {
  return showModalBottomSheet(
      context: context,
      builder: (context) {
        return BottomSheetComponent(
          nameController: nameController,
          passwordController: passwordController,
          index: index,
        );
      });
}
