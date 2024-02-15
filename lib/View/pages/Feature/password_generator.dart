import 'dart:math';
import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:strong_password/common/color_constants.dart';

// ignore: must_be_immutable
class PasswordGeneratorView extends StatefulWidget {
  const PasswordGeneratorView({super.key});

  @override
  State<PasswordGeneratorView> createState() => _PasswordGeneratorViewState();
}

class _PasswordGeneratorViewState extends State<PasswordGeneratorView> {
  int lengthValue = 12;

  String? generatedPassword;
  bool isUpperCase = true;
  bool isNumbers = true;
  bool isSymbols = true;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 1,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Password Generator',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
          centerTitle: false,
          backgroundColor: Colors.white,
          automaticallyImplyLeading: false,
          toolbarHeight: 70,
          leading: Container(
            padding: const EdgeInsets.all(12),
            color: Colors.transparent,
            child: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(
                Icons.arrow_back,
                color: Colors.black,
              ),
            ),
          ),
          actions: [
            Container(
              padding: const EdgeInsets.all(12),
              color: Colors.transparent,
              child: IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.history,
                  size: 30,
                  color: Colors.black,
                ),
              ),
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              PasswordArea(
                generatedPassword: generatedPassword,
              ),
              TabBar(
                padding: const EdgeInsets.symmetric(vertical: 12.0),
                labelColor: Colors.black,
                labelStyle: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
                indicatorColor: Colors.blueGrey.shade900,
                indicatorSize: TabBarIndicatorSize.tab,
                tabs: const <Widget>[
                  Tab(
                    text: 'Charachters',
                  ),
                  
                ],
              ),
              // todo Şimdilik burada tabbar kullanımına gerek yok.
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  children: [
                    SliderInfoCard(
                      lengthValue: lengthValue,
                      onChanged: (value) {
                        setState(() {
                          lengthValue = value.toInt();
                        });
                      },
                    ),
                    SwitchInfoCard(
                      text: 'Use capital letters (A-Z)',
                      value: isUpperCase,
                      onChanged: (value) {
                        setState(() {
                          isUpperCase = value;
                        });
                      },
                    ),
                    SwitchInfoCard(
                        text: 'Use digits (0-9)',
                        value: isNumbers,
                        onChanged: (value) {
                          setState(() {
                            isNumbers = value;
                          });
                        }),
                    SwitchInfoCard(
                      text: 'Use symbols (!@\$%*)',
                      value: isSymbols,
                      onChanged: (value) {
                        setState(() {
                          isSymbols = value;
                        });
                      },
                    ),
                    const CostumDivider(),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          CircleButtonLarge(
                            onPressed: () {
                              if (generatedPassword != null) {
                                FlutterClipboard.copy(generatedPassword!);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content:
                                        Text('Password copied to clipboard'),
                                    duration: Duration(seconds: 1),
                                  ),
                                );
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Generate a password first!'),
                                    duration: Duration(seconds: 1),
                                  ),
                                );
                              }
                            },
                            iconData: Icons.copy,
                            text: 'Copy',
                          ),
                          CircleButtonLarge(
                            onPressed: () {
                              String newPass = generatePassword(lengthValue,
                                  isUpperCase, isNumbers, isSymbols);
                              setState(() {
                                generatedPassword = newPass;
                              });
                            },
                            iconData: Icons.refresh,
                            text: 'Generate',
                          ),
                          CircleButtonLarge(
                            onPressed: () {},
                            iconData: Icons.add,
                            text: 'Save',
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String generatePassword(int characterLength, bool includeUpperCase,
      bool includeNumbers, bool includeSymbols) {
    // Tanımlanan karakter setleri
    final List<String> upperCaseChars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'.split('');
    final List<String> lowerCaseChars = 'abcdefghijklmnopqrstuvwxyz'.split('');
    final List<String> numbers = '0123456789'.split('');
    final List<String> symbols = '~!@#\$%^&*()_-+={[}]|:;"<,>.?/'.split('');

    // Karakterlerin hepsini içerecek olan karakter seti
    List<String> allCharacters = List<String>.from(lowerCaseChars);

    // Büyük harfleri ekle
    if (includeUpperCase) {
      allCharacters.addAll(upperCaseChars);
    }

    // Sayıları ekle
    if (includeNumbers) {
      allCharacters.addAll(numbers);
    }

    // Sembolleri ekle
    if (includeSymbols) {
      allCharacters.addAll(symbols);
    }

    // Rastgele karaterler seçerek şifre oluştur
    String password = '';
    final random = Random();
    for (int i = 0; i < characterLength; i++) {
      password += allCharacters[random.nextInt(allCharacters.length)];
    }

    return password;
  }
}

class CostumDivider extends StatelessWidget {
  const CostumDivider({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Divider(
      color: Colors.grey.shade200,
      thickness: 1,
    );
  }
}

// ignore: must_be_immutable
class PasswordArea extends StatefulWidget {
  const PasswordArea({
    super.key,
    this.generatedPassword,
  });

  final String? generatedPassword;

  @override
  State<PasswordArea> createState() => _PasswordAreaState();
}

class _PasswordAreaState extends State<PasswordArea> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: MediaQuery.of(context).size.height * 0.3,
          width: MediaQuery.of(context).size.width,
          color: Colors.grey.shade200,
        ),
        Positioned(
          top: 40,
          left: 40,
          child: Text(
            widget.generatedPassword ?? '',
            style: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        widget.generatedPassword == null
            ? const Positioned(
                bottom: 20,
                left: 20,
                child: Row(
                  children: [
                    Icon(
                      Icons.health_and_safety,
                      color: Color.fromARGB(255, 101, 182, 103),
                      size: 30,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      'Strong',
                      style: TextStyle(
                        color: Color.fromARGB(255, 101, 182, 103),
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              )
            : const SizedBox(),
      ],
    );
  }
}

class SwitchInfoCard extends StatelessWidget {
  const SwitchInfoCard({
    super.key,
    required this.text,
    required this.value,
    required this.onChanged,
  });

  final String text;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            text,
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 18,
            ),
          ),
          CostumSwitch(
            switchValue: value,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}

// ignore: must_be_immutable
class SliderInfoCard extends StatefulWidget {
  SliderInfoCard({
    super.key,
    required this.lengthValue,
    required this.onChanged,
  });

  int lengthValue;
  Function(double) onChanged;

  @override
  State<SliderInfoCard> createState() => _SliderInfoCardState();
}

class _SliderInfoCardState extends State<SliderInfoCard> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: 'Length: ',
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 18,
                  ),
                ),
                TextSpan(
                  text: widget.lengthValue.toString(),
                  style: const TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          const SizedBox(
            width: 40,
          ),
          Expanded(
            child: SliderTheme(
              data: SliderThemeData(
                thumbColor: Colors.white,
                activeTrackColor: AppColors.componentColor,
                inactiveTrackColor: Colors.grey,
              ),
              child: Slider(
                value: widget.lengthValue.toDouble(),
                min: 0,
                max: 20,
                onChanged: (value) {
                  setState(() {
                    widget.onChanged(value);
                  });
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CircleButtonLarge extends StatefulWidget {
  const CircleButtonLarge({
    super.key,
    required this.onPressed,
    required this.iconData,
    required this.text,
    this.iconColor,
  });

  final Function() onPressed;
  final IconData iconData;
  final String text;
  final Color? iconColor;

  @override
  State<CircleButtonLarge> createState() => _CircleButtonLargeState();
}

class _CircleButtonLargeState extends State<CircleButtonLarge> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          CircleAvatar(
            radius: 36,
            backgroundColor: Colors.grey.shade200,
            child: IconButton(
              onPressed: () {
                setState(() {
                  widget.onPressed();
                });
              },
              icon: Icon(
                widget.iconData,
                size: 28,
                color: widget.iconColor ?? Colors.black87,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            widget.text,
            style: const TextStyle(
                color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}

// ignore: must_be_immutable
class CostumSwitch extends StatefulWidget {
  CostumSwitch({
    super.key,
    required this.switchValue,
    required this.onChanged,
  });

  bool switchValue;
  final ValueChanged<bool> onChanged;

  @override
  State<CostumSwitch> createState() => _CostumSwitchState();
}

class _CostumSwitchState extends State<CostumSwitch> {
  @override
  Widget build(BuildContext context) {
    return Transform.scale(
      scale: 1.2,
      child: Switch.adaptive(
        thumbColor: MaterialStateColor.resolveWith((states) => Colors.white),
        value: widget.switchValue,
        onChanged: (value) {
          widget.onChanged(value);
        },
        activeColor: AppColors.componentColor,
      ),
    );
  }
}
