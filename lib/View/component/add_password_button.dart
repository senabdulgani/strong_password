import 'package:flutter/material.dart';
import 'package:strong_password/View/component/input_sheet.dart';
import 'package:strong_password/common/color_constants.dart';
import 'package:strong_password/models/password_model.dart';

class AddActionButton extends StatelessWidget {
  const AddActionButton({
    super.key,
    required this.passwordList,
  });

  final List<PasswordModel> passwordList;

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(56)),
      ),
      // todo Yuvarlak yap.
      backgroundColor: AppColors.primaryColor,
      onPressed: () {
        addPassword(context);
      },
      child: const Icon(Icons.add),
    );
  }

  addPassword(BuildContext context) {
    return showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            builder: (BuildContext context) {
              return SingleChildScrollView(
                child: InputBottomSheet(passwordList: passwordList),
              );
            },
          );
  }
}