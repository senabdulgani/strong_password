import 'package:flutter/material.dart';

class CostumButton extends StatelessWidget {
  const CostumButton({
    super.key,
    required this.onPressed,
    required this.buttonText,
    this.color = Colors.black,
    this.withImage = false,
  });

  final Function()? onPressed;
  final String buttonText;
  final Color? color;
  final bool withImage;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.8,
      height: 50,
      child: ElevatedButton(
          onPressed: onPressed,
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(color!),
          ),
          child: withImage == true
              ? Row(
                  children: [
                    Transform.scale(
                      scale: 2,
                      child: Image.asset(
                        'assets/fingerprint.png',
                        width: 30,
                        height: 30,
                      ),
                    ),
                    Text(
                      buttonText,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ],
                )
              : Text(
                  buttonText,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                )),
    );
  }
}
