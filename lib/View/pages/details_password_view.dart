import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:strong_password/View/component/costum_button.dart';
import 'package:strong_password/models/boxes.dart';
import 'package:strong_password/models/password.dart';

// ignore: must_be_immutable
class PasswordDetailsView extends StatefulWidget {
  PasswordDetailsView({
    super.key,
    required this.nameController,
    required this.passwordController,
    required this.index,
    this.websiteController,
    this.noteController,
  }) {
    websiteController ??= TextEditingController();
    noteController ??= TextEditingController();
  }

  final TextEditingController nameController;
  final TextEditingController passwordController;
  final int index;
  TextEditingController? websiteController;
  TextEditingController? noteController;

  @override
  State<PasswordDetailsView> createState() => _PasswordDetailsViewState();
}

class _PasswordDetailsViewState extends State<PasswordDetailsView> {

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
                  controller: widget.nameController,
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
                  controller: widget.passwordController,
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
                  controller: widget.websiteController,
                ),
                const Gap(36),
                TextFormField(
                  controller: widget.noteController,
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
                      boxPasswords.put(
                        'key_${widget.index.toString()}',
                        Password(
                          name: widget.nameController.text,
                          password: widget.passwordController.text,
                          website: widget.websiteController!.text,
                          note: widget.noteController!.text,
                        ),
                      );
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
