import 'package:flutter/material.dart';
import 'package:credit_card_scanner/credit_card_scanner.dart';
import 'package:strong_password/View/component/costum_app_bar.dart';
import 'package:strong_password/View/component/search_bar.dart';
import 'package:strong_password/View/pages/card_holder_info.dart';
import 'package:strong_password/View/pages/check_password_page.dart';
import 'package:strong_password/View/pages/password_generator.dart';
import 'package:strong_password/View/pages/settings_view.dart';
import 'package:strong_password/common/color_constants.dart';
import 'package:strong_password/models/boxes.dart';
import 'package:strong_password/models/card.dart';
import 'package:strong_password/models/password.dart';

class StrongPassword extends StatefulWidget {
  const StrongPassword({super.key});

  @override
  State<StrongPassword> createState() => _StrongPasswordState();
}

class _StrongPasswordState extends State<StrongPassword>
    with SingleTickerProviderStateMixin {
  final String title = 'Passwords';
  late bool _isUnlocked;

  @override
  void initState() {
    super.initState();
    _filteredPasswords = boxPasswords.values.toList() as List<Password>;
    _filteredCreditCard = cardBox.values.toList() as List<CreditCard>;

    _isUnlocked = true;
  }

  List<Password> _filteredPasswords = [];
  List<CreditCard> _filteredCreditCard = [];

  CardDetails? _cardDetails;
  CardScanOptions scanOptions = const CardScanOptions(
    scanCardHolderName: false,
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
      cardBox.put(_filteredCreditCard.length, creditCard);
      _filteredCreditCard.add(creditCard);
    });
  }
  // todo If user IOS 12 and above dont use credit card scanner plugin.

  void onSearch(String query) {
    if (query.isEmpty) {
      setState(() {
        _filteredPasswords = boxPasswords.values.toList() as List<Password>;
        _filteredCreditCard = cardBox.values.toList() as List<CreditCard>;
      });
    } else {
      setState(() {
        _filteredPasswords = boxPasswords
            .toMap()
            .values
            .where((password) =>
                password.name.toLowerCase().contains(query.toLowerCase()))
            .toList() as List<Password>;

        _filteredCreditCard = cardBox
            .toMap()
            .values
            .where((card) =>
                card.cardHolder.toLowerCase().contains(query.toLowerCase()))
            .toList() as List<CreditCard>;
      });
    }
  }

  toggleLock() {
    setState(() {
      _isUnlocked = !_isUnlocked;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(title),
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
            Row(
              children: [
                const Spacer(),
                InkWell(
                  onTap: () {},
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: Colors.black,
                        width: 2,
                      ),
                      color: Colors.white,
                    ),
                    padding:
                        const EdgeInsets.all(8), // Adjust padding as needed
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'By Name',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Icon(
                          Icons.arrow_drop_down,
                          color: Colors.black,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            // todo Login list in my passwords
            if (_filteredPasswords.isNotEmpty)
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
                itemCount: _filteredPasswords.length,
                shrinkWrap: true,
                itemBuilder: (BuildContext context, int index) {
                  Password password = _filteredPasswords[index];
                  TextEditingController nameController =
                      TextEditingController(text: password.name);
                  TextEditingController passwordController =
                      TextEditingController(text: password.password);
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
                        setState(() {
                          boxPasswords.deleteAt(index);
                          _filteredPasswords.removeAt(index);
                        });
                      },
                      child: ListTile(
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 8),
                        tileColor: Colors.white,
                        title: Text(
                          password.name,
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Text(
                          '•' * password.password.toString().length,
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
                                  // setState(() {
                                  //   boxPasswords.deleteAt(index);
                                  //   _filteredPasswords.removeAt(index);
                                  // });
                                },
                                icon: const Icon(Icons.copy),
                                color: Colors.black,
                              ),
                              // IconButton(
                              //   onPressed: () async {},
                              //   icon: const Icon(Icons.more_vert),
                              //   color: Colors.black,
                              // ),
                              PopUpMenuButton(
                                firstItem: () {},
                                secondItem: () {
                                  setState(() {
                                    boxPasswords.deleteAt(index);
                                    _filteredPasswords.removeAt(index);
                                  });
                                },
                              ),

                              // IconButton(
                              //   onPressed: () {
                              //     setState(() {
                              //       boxPasswords.deleteAt(index);
                              //       _filteredPasswords.removeAt(index);
                              //     });
                              //   },
                              //   icon: const Icon(Icons.delete),
                              //   color: Colors.red,
                              // ),
                              // Text('15.04', style: ProjectTextStyles.date),
                            ],
                          ),
                        ),
                        onTap: () {
                          showPasswordEditBottomSheet(
                            context,
                            nameController: nameController,
                            passwordController: passwordController,
                            isUpdate: true,
                            index: index,
                            filteredPasswords: _filteredPasswords,
                          ).then((value) => setState(() {}));
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
            if (_filteredCreditCard.isNotEmpty)
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
                itemCount: _filteredCreditCard.length,
                shrinkWrap: true,
                itemBuilder: (BuildContext context, int index) {
                  CreditCard card = _filteredCreditCard[index];
                  return ListTile(
                    leading: Icon(Icons.star, color: Colors.yellow.shade700),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                    tileColor: Colors.white,
                    title: RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text:
                                '${card.cardIssuer}  - **** ', // Boş olabilir.
                            style: const TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                          ),
                          TextSpan(
                            text: card.cardNumber.substring(12, 16),
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
                            onPressed: () {},
                            icon: const Icon(Icons.copy),
                            color: Colors.black,
                          ),
                          IconButton(
                            onPressed: () {
                              setState(() {
                                cardBox.deleteAt(index);
                                _filteredCreditCard.removeAt(index);
                              });
                            },
                            icon: const Icon(Icons.delete),
                            color: Colors.black,
                          ),
                          // IconButton(
                          //   onPressed: () {
                          //     setState(() {
                          //       boxPasswords.deleteAt(index);
                          //       _filteredPasswords.removeAt(index);
                          //     });
                          //   },
                          //   icon: const Icon(Icons.delete),
                          //   color: Colors.red,
                          // ),
                          // Text('15.04', style: ProjectTextStyles.date),
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
                      );
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
              // Yeni bir controller oluşturarak alt sayfayı gösterin
              TextEditingController nameController = TextEditingController();
              TextEditingController passwordController =
                  TextEditingController();
              showPasswordEditBottomSheet(
                context,
                nameController: nameController,
                passwordController: passwordController,
                index: _filteredPasswords.length,
                filteredPasswords: _filteredPasswords,
                isUpdate: false,
              ).then((value) => setState(() {}));
            },
            child: const Icon(Icons.add),
          ),
        ],
      ),
    );
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
