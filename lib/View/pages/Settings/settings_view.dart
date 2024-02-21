import 'package:flutter/material.dart';
import 'package:strong_password/View/pages/Introduction/detect_password_view.dart';
import 'package:strong_password/View/pages/Feature/password_generator.dart';

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
        title: const Text('Settings', style: TextStyle(fontStyle: FontStyle.italic, fontWeight: FontWeight.w500),),
        centerTitle: false,
        backgroundColor: Colors.transparent,
      ),
      body: Center(
        child: Column(
          children: [
            const CostumDivider(),
            CostumSettingItem(
              iconData: Icons.shield_outlined,
              text: 'Master Password',
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
