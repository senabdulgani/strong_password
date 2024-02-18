import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:credit_card_scanner/credit_card_scanner.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import 'package:strong_password/View/component/search_bar.dart';
import 'package:strong_password/View/pages/Details/card_holder_info.dart';
import 'package:strong_password/View/pages/Details/details_password_view.dart';
import 'package:strong_password/View/pages/Details/edit_card_detail.dart';
import 'package:strong_password/View/pages/Feature/password_generator.dart';
import 'package:strong_password/View/pages/Introduction/check_password_page.dart';
import 'package:strong_password/View/pages/Settings/settings_view.dart';
import 'package:strong_password/models/card.dart';
import 'package:strong_password/models/password.dart';
import 'package:strong_password/provider/credit_card/credit_card_notifier.dart';
import 'package:strong_password/provider/password/password_notifier.dart';

class StrongPassword extends StatefulWidget {
  const StrongPassword({super.key});

  @override
  State<StrongPassword> createState() => _StrongPasswordState();
}

class _StrongPasswordState extends State<StrongPassword>
    with SingleTickerProviderStateMixin {
  late final PasswordNotifier passwordProvider;
  late final CreditCardNotifier cardProvider;

  @override
  void initState() {
    super.initState();

    _isUnlocked = true;

    passwordProvider = Provider.of<PasswordNotifier>(context, listen: false);
    getPasswords();
    cardProvider = Provider.of<CreditCardNotifier>(context, listen: false);
    getCards();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: const Text('Passwords'),
        centerTitle: false,
        backgroundColor: Colors.transparent,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: IconButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return const PasswordGeneratorView();
                }));
              },
              icon: const Icon(Icons.password),
            ),
          ),
          IconButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return const SettingsPage();
              }));
            },
            icon: const Icon(Icons.menu),
          ),
          AnimatedCrossFade(
            duration: const Duration(milliseconds: 200),
            crossFadeState: _isUnlocked
                ? CrossFadeState.showFirst
                : CrossFadeState.showSecond,
            firstChild: IconButton(
              onPressed: () async {
                await toggleLock();
                await Future.delayed(const Duration(milliseconds: 250), () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const CheckPassword(),
                    ),
                  );
                });
              },
              icon: const Icon(Icons.lock_open),
            ),
            secondChild: IconButton(
              onPressed: () {
                return;
              },
              icon: const Icon(Icons.lock, color: Colors.red),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: ListView(
          children: [
            SearchPassword(onSearch: onSearch),
            // const TopNavigation(),
            const SizedBox(height: 10),
            // todo Login list in my passwords
            if (context.watch<PasswordNotifier>().passwords.isNotEmpty)
              Text(
                'LOGINS',
                style: TextStyle(
                    color: Colors.grey.shade700,
                    fontSize: 12,
                    fontWeight: FontWeight.bold),
              ),
            SingleChildScrollView(
              physics: const NeverScrollableScrollPhysics(),
              child: ListView.builder(
                itemCount: passwordProvider.passwords.length,
                shrinkWrap: true,
                itemBuilder: (BuildContext context, int index) {
                  Password password =
                      context.watch<PasswordNotifier>().passwords[index];
                  return GestureDetector(
                    child: Dismissible(
                      dismissThresholds: const {
                        DismissDirection.endToStart: 0.5
                      },
                      direction: DismissDirection.endToStart,
                      key: ValueKey<int>(password.hashCode),
                      background: Container(
                        alignment: Alignment.centerRight,
                        color: Colors.red,
                        child: const Padding(
                          padding: EdgeInsets.only(right: 24.0),
                          child: Icon(
                            Icons.delete,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      onDismissed: (_) {
                        passwordProvider.deletePassword(password);
                      },
                      child: ListTile(
                        selectedTileColor: Colors.grey.shade100,
                        leading: Icon(Icons.lock_person_outlined,
                            color: Colors.grey.shade700),
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 8),
                        tileColor: Colors.grey.shade100,
                        title: Text(
                          context
                              .watch<PasswordNotifier>()
                              .passwords[index]
                              .name,
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Text(
                          '•' *
                              context
                                  .watch<PasswordNotifier>()
                                  .passwords[index]
                                  .password
                                  .toString()
                                  .length,
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        trailing: SizedBox(
                          width: 100,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Spacer(),
                              IconButton(
                                onPressed: () {
                                  FlutterClipboard.copy(password.password).then(
                                      (value) => Fluttertoast.showToast(
                                          msg: 'Copied to clipboard',
                                          toastLength: Toast.LENGTH_SHORT,
                                          gravity: ToastGravity.BOTTOM,
                                          timeInSecForIosWeb: 1,
                                          backgroundColor: Colors.grey.shade700,
                                          textColor: Colors.white,
                                          fontSize: 16));
                                },
                                icon: const Icon(Icons.copy),
                                color: Colors.black,
                              ),
                              PopUpMenuButton(
                                firstItem: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) {
                                        return PasswordDetailsView(
                                          password: password,
                                        );
                                      },
                                    ),
                                  );
                                },
                                secondItem: () {
                                  passwordProvider.deletePassword(password);
                                },
                              ),
                            ],
                          ),
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return PasswordDetailsView(
                                  password: password,
                                );
                              },
                            ),
                          );
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
            if (context.watch<CreditCardNotifier>().cards.isNotEmpty)
              Text(
                'CARDS',
                style: TextStyle(
                    color: Colors.grey.shade700,
                    fontSize: 12,
                    fontWeight: FontWeight.bold),
              ),
            SingleChildScrollView(
              physics: const NeverScrollableScrollPhysics(),
              child: ListView.builder(
                itemCount: cardProvider.cards.length,
                shrinkWrap: true,
                itemBuilder: (BuildContext context, int index) {
                  CreditCard card =
                      context.watch<CreditCardNotifier>().cards[index];
                  return ListTile(
                    onLongPress: () {},
                    leading:
                        Icon(Icons.credit_card, color: Colors.grey.shade700),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                    tileColor: Colors.grey.shade100,
                    title: RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text:
                                '${context.watch<CreditCardNotifier>().cards[index].cardIssuer}  - **** ', // Boş olabilir.
                            style: const TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                          ),
                          TextSpan(
                            text: context
                                .watch<CreditCardNotifier>()
                                .cards[index]
                                .cardNumber
                                .toString()
                                .substring(12, 16), // todo 16 haneli olmalı.
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                    trailing: SizedBox(
                      width: 100,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Spacer(),
                          IconButton(
                            onPressed: () {
                              FlutterClipboard.copy(card.cardNumber).then(
                                  (value) => FlutterClipboard.copy(
                                          card.cardNumber)
                                      .then((value) => Fluttertoast.showToast(
                                          msg: 'Copied to clipboard',
                                          toastLength: Toast.LENGTH_SHORT,
                                          gravity: ToastGravity.BOTTOM,
                                          timeInSecForIosWeb: 1,
                                          backgroundColor: Colors.grey.shade700,
                                          textColor: Colors.white,
                                          fontSize: 16)));
                            },
                            icon: const Icon(Icons.copy),
                            color: Colors.black,
                          ),
                          IconButton(
                            onPressed: () {
                              setState(() {
                                cardProvider.deleteCard(card);
                              });
                            },
                            icon: const Icon(Icons.delete),
                            color: Colors.black,
                          ),
                        ],
                      ),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return CardDetailInfo(
                              card: card,
                            );
                          },
                        ),
                      ).then((value) => setState(() {}));
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: SpeedDial(
        icon: Icons.add,
        activeIcon: Icons.close,
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.grey.shade700,
        overlayColor: Colors.grey.shade100,
        overlayOpacity: 0.8,
        spacing: 12,
        spaceBetweenChildren: 12,
        closeDialOnPop: true,
        children: [
          SpeedDialChild(
            shape: const CircleBorder(),
            child: const Icon(FontAwesomeIcons.key),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return const PasswordDetailsView();
              }));
            },
          ),
          SpeedDialChild(
            shape: const CircleBorder(),
            child: const Icon(FontAwesomeIcons.creditCard),
            onTap: () async {
              await scanCard();
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) {
                  return EditCardDetails(
                    
                  );
                }),
              );
            },
          ),
          SpeedDialChild(
            shape: const CircleBorder(),
            child: const Icon(FontAwesomeIcons.link),
            onTap: () {
              // Share app ama henüz yapmadım.
            },
          ),
        ],
      ),
    );
  }

  late bool _isUnlocked;

  CardDetails? _cardDetails;

  Future<void> scanCard() async {
    _cardDetails = await CardScanner.scanCard();
    if (_cardDetails != null) {
      CreditCard card = CreditCard(
        cardNumber: _cardDetails!.cardNumber,
        cardHolder: _cardDetails!.cardHolderName,
        cardIssuer: _cardDetails!.cardIssuer,
        cardExpiry: _cardDetails!.expiryDate,
      );
      cardProvider.addCard(
        card: card,
      );
    }
  }

  late List<Password> _filteredPasswords = [];

  void onSearch(String query) {
    if (query.isEmpty) {
      setState(() {
        _filteredPasswords = passwordProvider.passwords;
      });
    } else {
      setState(() {
        _filteredPasswords.add(passwordProvider.passwords.firstWhere(
            (password) =>
                password.name.toLowerCase().contains(query.toLowerCase())));
      });
    }
  }

  toggleLock() {
    setState(() {
      _isUnlocked = !_isUnlocked;
    });
  }

  Future<void> getPasswords() async {
    await passwordProvider.getAllPasswords();
    setState(() {});
  }

  Future<void> getCards() async {
    await cardProvider.getAllCards();
    setState(() {});
  }
}

class TopNavigation extends StatefulWidget {
  const TopNavigation({
    super.key,
  });

  @override
  State<TopNavigation> createState() => _TopNavigationState();
}

class _TopNavigationState extends State<TopNavigation> {
  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        CostumSelectButton(
          text: 'Logins',
        ),
        Gap(10),
        CostumSelectButton(
          text: 'Cards',
        ),
        Gap(10),
        CostumSelectButton(
          text: 'Favorites',
        ),
      ],
    );
  }
}

// ignore: must_be_immutable
class CostumSelectButton extends StatefulWidget {
  final String text;

  const CostumSelectButton({
    super.key,
    required this.text,
  });

  @override
  State<CostumSelectButton> createState() => _CostumSelectButtonState();
}

class _CostumSelectButtonState extends State<CostumSelectButton> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: () {},
        style: ButtonStyle(
          elevation: MaterialStateProperty.all(4),
          backgroundColor: MaterialStateProperty.all(Colors.grey.shade200),
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          side: MaterialStateProperty.all(
            const BorderSide(
              color: Colors.black,
              width: 1,
            ),
          ),
        ),
        child: Text(
          widget.text,
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w500,
          ),
        ));
  }
}

// ignore: must_be_immutable
class PopUpMenuButton extends StatefulWidget {
  PopUpMenuButton({
    super.key,
    required this.firstItem,
    required this.secondItem,
  });

  Function() firstItem;
  Function() secondItem;

  @override
  State<PopUpMenuButton> createState() => _PopUpMenuButtonState();
}

class _PopUpMenuButtonState extends State<PopUpMenuButton> {
  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<int>(
      color: Colors.grey.shade100,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      offset: const Offset(-20, 20),
      itemBuilder: (BuildContext context) => <PopupMenuEntry<int>>[
        const PopupMenuItem<int>(
          value: 0,
          child: ListTile(
            leading: Icon(Icons.edit),
            title: Text('Edit'),
          ),
        ),
        const PopupMenuItem<int>(
          value: 1,
          child: ListTile(
            leading: Icon(Icons.delete),
            title: Text('Delete'),
          ),
        ),
      ],
      onSelected: (int value) {
        switch (value) {
          case 0:
            widget.firstItem();
            break;
          case 1:
            // Handle delete action
            widget.secondItem();
            break;
        }
      },
    );
  }
}
