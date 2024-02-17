import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:credit_card_scanner/credit_card_scanner.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import 'package:strong_password/View/component/search_bar.dart';
import 'package:strong_password/View/pages/Details/card_holder_info.dart';
import 'package:strong_password/View/pages/Details/details_password_view.dart';
import 'package:strong_password/View/pages/Feature/password_generator.dart';
import 'package:strong_password/View/pages/Introduction/check_password_page.dart';
import 'package:strong_password/View/pages/Settings/settings_view.dart';
import 'package:strong_password/common/color_constants.dart';
import 'package:strong_password/models/card.dart';
import 'package:strong_password/models/password.dart';
import 'package:strong_password/provider/credit_card/credit_card_notifier.dart';
import 'package:strong_password/provider/credit_card/credit_card_service.dart';
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
      backgroundColor: Colors.white,
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
            // Row(
            //   children: [
            //     const Spacer(),
            //     InkWell(
            //       onTap: () {},
            //       child: Container(
            //         decoration: BoxDecoration(
            //           borderRadius: BorderRadius.circular(8),
            //           border: Border.all(
            //             color: Colors.black,
            //             width: 2,
            //           ),
            //           color: Colors.white,
            //         ),
            //         padding:
            //             const EdgeInsets.all(8), // Adjust padding as needed
            //         child: const Row(
            //           mainAxisSize: MainAxisSize.min,
            //           children: [
            //             Text(
            //               'By Name',
            //               style: TextStyle(
            //                 fontSize: 12,
            //                 color: Colors.black,
            //                 fontWeight: FontWeight.bold,
            //               ),
            //             ),
            //             Icon(
            //               Icons.arrow_drop_down,
            //               color: Colors.black,
            //             ),
            //           ],
            //         ),
            //       ),
            //     ),
            //   ],
            // ),
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
                      context.watch<PasswordNotifier>().passwords[
                          index];
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
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 8),
                        tileColor: Colors.white,
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
                                  // copy password
                                  FlutterClipboard.copy(password.password).then(
                                      (value) => ScaffoldMessenger.of(context)
                                          .showSnackBar(const SnackBar(
                                              content: Text(
                                                  'Copied to clipboard'))));
                                },
                                icon: const Icon(Icons.copy),
                                color: Colors.black,
                              ),
                              PopUpMenuButton(
                                firstItem: () {
                                  // edit password
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
                                  // setState(() {
                                  passwordProvider.deletePassword(password);
                                  // });
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
                      context.watch<CreditCardNotifier>().cards[
                          index];
                  return ListTile(
                    leading: Icon(Icons.credit_card, color: Colors.grey.shade700),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                    tileColor: Colors.white,
                    title: RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text:
                                '${context.watch<CreditCardNotifier>()
                              .cards[index]
                              .cardIssuer}  - **** ', // Boş olabilir.
                            style: const TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                          ),
                          TextSpan(
                            text: context.watch<CreditCardNotifier>()
                              .cards[index]
                              .cardNumber.toString().substring(12, 16),
                              
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
                                  (value) => ScaffoldMessenger.of(context)
                                      .showSnackBar(const SnackBar(
                                          content: Text('Copied to clipboard'))));
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
                            return CardHolderInfo(
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
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: 'sample password',
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(56)),
            ),
            backgroundColor: AppColors.primaryColor,
            onPressed: () {
              setState(() {
                passwordProvider.addPassword(
                  password: Password(
                    name: 'deneme adi',
                    password: 'deneme123',
                    website: 'deneme.com',
                    note: 'deneme notu',
                    isFavorite: false,
                  ),
                );
              });
            },
            child: const Icon(Icons.flight_takeoff),
          ),
          const Gap(10),
          FloatingActionButton(
            heroTag: 'sample card',
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(56)),
            ),
            backgroundColor: AppColors.primaryColor,
            onPressed: () {
              setState(() {
                cardProvider.addCard(
                  card: CreditCard(
                    cardHolder: 'Abdulgani Şen',
                    cardNumber: '1234567890127630',
                    cardExpiry: 'deneme.com',
                    cardIssuer: 'MasterCard',
                    isFavorite: false,
                  ),
                );
              });
            },
            child: const Icon(Icons.flight_outlined),
          ),
          const Gap(10),
          FloatingActionButton(
            heroTag: 'scan',
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(56)),
            ),
            backgroundColor: AppColors.primaryColor,
            onPressed: () {
              // scan and then go to car page
              scanCard();
              // cardBox
              //     .put(
              //       _filteredCreditCard.length,
              //       _cardDetails,
              //     )
              //     .then((value) => setState(() {}));
              // _filteredCreditCard.add(_cardDetails as CreditCard);
              // } else {

              // Navigator.push(
              //   context,
              //   MaterialPageRoute(
              //     builder: (context) {
              //       return CardHolderInfo(
              //         cardDetails: _cardDetails,
              //       );
              //     },
              //   ),
              // );

              // }
              // Bu kendisi otomatik kamera izini alıyor.
              // todo Kullanıcı izin vermezse ne olacak bu durumu yönet.
            },
            child: const Icon(Icons.credit_card),
          ),
          const SizedBox(height: 10),
          FloatingActionButton(
            heroTag: 'add',
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(56)),
            ),
            backgroundColor: AppColors.primaryColor,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return const PasswordDetailsView();
                  },
                ),
              );
            },
            child: const Icon(Icons.add),
          ),
        ],
      ),
    );
  }

  late bool _isUnlocked;

  final List<Password> _filteredPasswords = [];
  final List<CreditCard> _filteredCreditCard = [];

  CardDetails? _cardDetails;
  CardScanOptions scanOptions = const CardScanOptions(
    scanCardHolderName: true,
    scanExpiryDate: true,
    enableLuhnCheck: false,
    cardScannerTimeOut: 1,
    initialScansToDrop: 1,
    enableDebugLogs: true,
    validCardsToScanBeforeFinishingScan: 5,
    possibleCardHolderNamePositions: [
      CardHolderNameScanPosition.belowCardNumber,
    ],
  );

  Future<void> scanCard() async {
    final CardDetails? cardDetails =
        await CardScanner.scanCard(scanOptions: scanOptions);
    if (!mounted || cardDetails == null) {
      return;
    }
    setState(() {
      _cardDetails = cardDetails;
      CreditCard creditCard = CreditCard(
        cardHolder: _cardDetails!.cardHolderName,
        cardNumber: _cardDetails!.cardNumber,
        cardExpiry: _cardDetails!.expiryDate,
        cardIssuer: _cardDetails!.cardIssuer,
      );
      cardProvider.addCard(card: creditCard);
    });
  }

  void onSearch(String query) {
    if (query.isEmpty) {
      setState(() {
        // _filteredPasswords = boxPasswords.values.toList() as List<Password>;
        // _filteredCreditCard = cardBox.values.toList() as List<CreditCard>;
        // passwordProvider.getAllPasswords();
      });
    } else {
      setState(() {
        // _filteredPasswords.add(passwordProvider.passwords.firstWhere(
        //     (password) =>
        //         password.name.toLowerCase().contains(query.toLowerCase())));
        
        // _filteredCreditCard.add(cardProvider.cards.firstWhere(
        //     (card) =>
        //         card.cardHolder.toLowerCase().contains(query.toLowerCase())));
        
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
