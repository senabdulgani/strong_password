import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import 'package:strong_password/View/component/costum_button.dart';
import 'package:strong_password/common/feature/basic_helper.dart';
import 'package:strong_password/View/pages/Feature/history_password.dart';
import 'package:strong_password/models/password.dart';
import 'package:strong_password/provider/password/password_notifier.dart';

class PasswordDetailsView extends StatefulWidget {
  final Password? password;

  const PasswordDetailsView({
    super.key,
    this.password,
  });

  @override
  State<PasswordDetailsView> createState() => _PasswordDetailsViewState();
}

class _PasswordDetailsViewState extends State<PasswordDetailsView> {
  late final PasswordNotifier passwordProvider;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController websiteController = TextEditingController();
  final TextEditingController noteController = TextEditingController();

  bool isPasswordVisible = false;

  @override
  void initState() {
    super.initState();
    passwordProvider = Provider.of<PasswordNotifier>(context, listen: false);

    if (widget.password != null) {
      nameController.text = widget.password!.name;
      passwordController.text = widget.password!.password;
      websiteController.text = widget.password!.website;
      noteController.text = widget.password!.note;
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            widget.password != null ? widget.password!.name : 'New Password',
            style: const TextStyle(fontWeight: FontWeight.w500)),
        backgroundColor: Colors.transparent,
        actions: [
          GestureDetector(
            onTap: () {
              widget.password != null
                  ? Navigator.push(context,
                      MaterialPageRoute(builder: (context) {
                      return HistoryPass(
                        password: widget.password!,
                      );
                    }))
                  : Fluttertoast.showToast(
                      msg: 'Password history cleared',
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.black,
                      textColor: Colors.white,
                      fontSize: 16.0,
                    );
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              color: Colors.transparent,
              child: const Icon(Icons.history, color: Colors.black, size: 30),
            ),
          ),
          InkWell(
            onTap: () {},
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              color: Colors.transparent,
              child: const Text(
                'Save',
                style: TextStyle(color: Colors.grey, fontSize: 16),
              ),
            ),
          ),
        ],
      ),
      body: Form(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              children: [
                Gap(MediaQuery.of(context).size.height * 0.01),
                TextFieldWithIcon(
                  labelText: 'Password label',
                  iconData: Icons.label,
                  controller: nameController,
                ),
                const Gap(12),
                TextFieldWithIcon(
                  labelText: 'Enter password',
                  iconData: isPasswordVisible
                      ? Icons.visibility_off
                      : Icons.visibility,
                  isObscure: isPasswordVisible,
                  controller: passwordController,
                  firstIconAction: () {
                    setState(() {
                      isPasswordVisible = !isPasswordVisible;
                    });
                  },
                  secondIcon: FontAwesomeIcons.g,
                  secondIconAction: () {
                    String newPass =
                        BasicHelpers.generatePassword(12, true, true, true);
                    passwordController.text = newPass;
                  },
                ),
                const Gap(12),
                const FieldInfoArea(
                  infoHeader: 'Generate Password',
                  infoBody:
                      'You can generate a strong password to click G button.',
                ),
                const Gap(12),
                TextFieldWithIcon(
                  labelText: 'Website (optional)',
                  iconData: Icons.web,
                  controller: websiteController,
                ),
                const Gap(36),
                CostumNoteField(
                  noteController: noteController,
                  text: 'Note Something',
                ),
                const Gap(20),
                CostumButton(
                  onPressed: () {
                    savePassword();
                  },
                  buttonText: 'Save',
                  color: Colors.black,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void savePassword() {
    if (nameController.text.isEmpty || passwordController.text.isEmpty) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Error'),
            content: const Text('Name and password cannot be empty.'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    } else {
      if (widget.password != null) {
        passwordProvider.updatePassword(
          password: Password(
            name: nameController.text,
            password: passwordController.text,
            website: websiteController.text,
            note: noteController.text,
            passwordHistory: widget.password!.passwordHistory,
          ),
          oldPasswordIndex:
              passwordProvider.passwords.indexOf(widget.password!),
        );
      } else {
        passwordProvider.addPassword(
          password: Password(
            name: nameController.text,
            password: passwordController.text,
            website: websiteController.text,
            note: noteController.text,
            passwordHistory: [passwordController.text],
          ),
        );
      }
      Navigator.pop(context);
    }
  }
}

class CostumNoteField extends StatelessWidget {
  const CostumNoteField({
    super.key,
    required this.noteController,
    required this.text,
  });

  final TextEditingController noteController;
  final String text;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: noteController,
      minLines: 4,
      maxLines: null,
      keyboardType: TextInputType.multiline,
      decoration: InputDecoration(
        alignLabelWithHint: true,
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        labelText: text,
      ),
    );
  }
}

class FieldInfoArea extends StatelessWidget {
  const FieldInfoArea({
    super.key,
    required this.infoHeader,
    required this.infoBody,
  });

  final String infoHeader;
  final String infoBody;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Text(infoHeader,
                style: Theme.of(context).textTheme.titleSmall!.copyWith(
                      color: Colors.grey.shade600,
                      fontSize: 16,
                    )),
            const Gap(6),
            Icon(
              Icons.info,
              color: Colors.grey.shade700,
              size: 16,
            )
          ],
        ),
        Text(
          infoBody,
          style: const TextStyle(color: Colors.grey, fontSize: 14),
        )
      ],
    );
  }
}

class TextFieldWithIcon extends StatelessWidget {
  final String labelText;
  final IconData iconData;
  final IconData? secondIcon;
  final bool isObscure;
  final TextEditingController? controller;
  final Function()? firstIconAction;
  final Function()? secondIconAction;

  const TextFieldWithIcon({
    super.key,
    required this.labelText,
    required this.iconData,
    this.secondIcon,
    required this.controller,
    this.isObscure = false,
    this.firstIconAction,
    this.secondIconAction,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Flexible(
          flex: 8,
          child: CostumTextField(
              controller: controller,
              isObscure: isObscure,
              labelText: labelText),
        ),
        if (secondIcon != null)
          Flexible(
            flex: 2,
            child: GestureDetector(
              onTap: secondIconAction,
              child: Container(
                padding: const EdgeInsets.all(8),
                color: Colors.transparent,
                child: Icon(secondIcon, size: 30, color: Colors.green.shade500),
              ),
            ),
          ),
        Flexible(
          flex: 2,
          child: GestureDetector(
            onTap: firstIconAction,
            child: Container(
              padding: const EdgeInsets.all(8),
              color: Colors.transparent,
              child: Icon(iconData, size: 30),
            ),
          ),
        ),
      ],
    );
  }
}

class CostumTextField extends StatelessWidget {
  const CostumTextField({
    super.key,
    required this.controller,
    this.isObscure = false,
    required this.labelText,
  });

  final TextEditingController? controller;
  final bool isObscure;
  final String labelText;

  @override
  Widget build(BuildContext context) {
    return TextField(
      cursorColor: Colors.black,
      onEditingComplete: () {},
      textInputAction: TextInputAction.done,
      controller: controller,
      obscureText: isObscure,
      decoration: InputDecoration(
        floatingLabelStyle: const TextStyle(
          color: Colors.black,
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.black,
          ),
        ),
        disabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.black,
          ),
        ),
        labelText: labelText,
      ),
    );
  }
}

class CostumTextFormPassDetails extends StatelessWidget {
  const CostumTextFormPassDetails({
    super.key,
    required this.labelText,
  });

  final String labelText;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
        border: const UnderlineInputBorder(),
        labelText: labelText,
      ),
    );
  }
}
