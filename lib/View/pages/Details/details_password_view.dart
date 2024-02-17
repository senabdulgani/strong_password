import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import 'package:strong_password/View/component/costum_button.dart';
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
                  iconData: Icons.add_a_photo,
                  controller: nameController,
                ),
                const Gap(12),
                // const FieldInfoArea(
                //   infoHeader: 'Password Strength',
                //   infoBody: 'This is a strong password',
                // ),
                TextFieldWithIcon(
                  labelText: 'Enter password',
                  iconData: Icons.security,
                  isObscure: true,
                  controller: passwordController,
                ),
                const Gap(12),
                // TextFieldWithIcon(
                //   labelText: 'Enter username (optional)',
                //   iconData: Icons.person,
                //   controller: usernameController!,
                // ),
                // const Gap(12),
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
                          oldPasswordIndex: passwordProvider
                              .passwords
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
                    buttonText: 'Save'),
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
        Row(
          children: [
            SizedBox(
                width: MediaQuery.of(context).size.width * 0.9,
                child: Text(
                  infoBody,
                  style: const TextStyle(color: Colors.grey, fontSize: 14),
                )),
          ],
        )
      ],
    );
  }
}

class TextFieldWithIcon extends StatelessWidget {
  const TextFieldWithIcon({
    super.key,
    required this.labelText,
    required this.iconData,
    required this.controller,
    this.isObscure = false,
  });

  final String labelText;
  final IconData iconData;
  final bool isObscure;
  final TextEditingController? controller;

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
        Flexible(
          flex: 2,
          child: Container(
            width: 50,
            padding: const EdgeInsets.all(8),
            color: Colors.transparent,
            child: Icon(iconData, size: 30),
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
