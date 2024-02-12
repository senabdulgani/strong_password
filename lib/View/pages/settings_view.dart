import 'package:flutter/material.dart';
import 'package:strong_password/View/pages/detect_password_view.dart';
import 'package:strong_password/View/pages/password_generator.dart';
import 'package:strong_password/common/color_constants.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        centerTitle: false,
        backgroundColor: AppColors.componentColor,
      ),
      body: Center(
        child: Column(
          children: [
            // CostumSettingItem(
            //   iconData: Icons.color_lens_outlined,
            //   text: 'Appearance',
            // ),
            // CostumDivider(),
            CostumSettingItem(
              iconData: Icons.shield_outlined,
              text: 'Security',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DetectPassword(isUpdate: true),
                  ),
                );
              },
            ),
            const CostumDivider(),
            // CostumSettingItem(
            //   iconData: Icons.language,
            //   text: 'Language',
            // ),
            // CostumDivider(),
            // CostumSettingItem(
            //   iconData: Icons.import_export_sharp,
            //   text: 'Export - Import',
            // ),
            // CostumDivider(),
            const CostumSettingItem(
              iconData: Icons.info_outline,
              text: 'About',
            ),
            const CostumDivider(),
          ],
        ),
      ),
    );
  }
}

class CostumSettingItem extends StatelessWidget {
  const CostumSettingItem({
    super.key,
    required this.text,
    required this.iconData,
    this.onPressed,
  });

  final String text;
  final IconData iconData;
  final Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(iconData, size: 30),
      title: Text(
        text,
        style: const TextStyle(
          fontSize: 20,
        ),
      ),
      onTap: onPressed,
    );
  }
}
