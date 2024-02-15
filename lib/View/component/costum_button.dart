import 'package:flutter/material.dart';

class CostumButton extends StatelessWidget {
  const CostumButton({
    super.key,
    required this.onPressed,
    required this.buttonText,
    this.color = Colors.black,
  });

  final Function()? onPressed;
  final String buttonText;
  final Color? color;

  
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.8,
      height: 50,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ButtonStyle(
          backgroundColor:
              MaterialStateProperty.all<Color>(color!),
        ),
        child: Text(
          buttonText,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16, // Adjust font size as needed
          ),
        ),
      ),
    );
  }
}
