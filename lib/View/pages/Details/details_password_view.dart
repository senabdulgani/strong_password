import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import 'package:strong_password/View/component/costum_button.dart';
import 'package:strong_password/common/feature/basic_helper.dart';
import 'package:strong_password/models/password.dart';
import 'package:strong_password/provider/password/password_notifier.dart';

// ignore: must_be_immutable
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
  bool isDirty = false;

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

    nameController.addListener(() {
      setState(() {
        isDirty = true;
      });
    });

    passwordController.addListener(() {
      setState(() {
        isDirty = true;
      });
    });

    websiteController.addListener(() {
      setState(() {
        isDirty = true;
      });
    });

    noteController.addListener(() {
      setState(() {
        isDirty = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Password'),
        backgroundColor: Colors.transparent,
        actions: [
          GestureDetector(
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
                    // generate password
                    String newPass = BasicHelpers.generatePassword(
                        12, true, true, true);
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
                TextFormField(
                  controller: noteController,
                  minLines: 4,
                  maxLines: null,
                  keyboardType: TextInputType.multiline,
                  decoration: const InputDecoration(
                    alignLabelWithHint: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    labelText: 'Note Something',
                  ),
                ),
                const Gap(20),
                CostumButton(
                  onPressed: () {
                    if (widget.password != null) {
                      passwordProvider.updatePassword(
                        password: Password(
                          name: nameController.text,
                          password: passwordController.text,
                          website: websiteController.text,
                          note: noteController.text,
                        ),
                        oldPasswordIndex: passwordProvider.passwords
                            .indexOf(widget.password!),
                      );
                    } else {
                      passwordProvider.addPassword(
                        password: Password(
                          name: nameController.text,
                          password: passwordController.text,
                          website: websiteController.text,
                          note: noteController.text,
                        ),
                      );
                    }
                    Navigator.pop(context);
                    debugPrint('Password saved');
                  },
                  buttonText: 'Save',
                  color: isDirty ? Colors.black : Colors.grey,
                ),
              ],
            ),
          ),
        ),
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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Column(
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
          Row(
            children: [
              SizedBox(
                  child: Text(
                infoBody,
                style: const TextStyle(color: Colors.grey, fontSize: 14),
              )),
            ],
          )
        ],
      ),
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
          child: TextField(
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
          ),
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
