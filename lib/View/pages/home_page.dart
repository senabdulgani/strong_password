import 'package:credit_card_scanner/credit_card_scanner.dart';
import 'package:flutter/material.dart';
import 'package:strong_password/View/component/costum_app_bar.dart';
import 'package:strong_password/View/component/search_bar.dart';
import 'package:strong_password/View/pages/card_holder_info.dart';
import 'package:strong_password/common/color_constants.dart';
import 'package:strong_password/common/text_styles.dart';
import 'package:strong_password/models/Hive/boxes.dart';
import 'package:strong_password/models/Hive/password.dart';

class StrongPassword extends StatefulWidget {
  const StrongPassword({super.key});

  @override
  State<StrongPassword> createState() => _StrongPasswordState();
}

class _StrongPasswordState extends State<StrongPassword> {
  final String title = 'Passwords';

  @override
  void initState() {
    super.initState();
    _filteredPasswords = boxPasswords.values.toList() as List<Password>;
  }

  bool isCancelActive = false;
  List<Password> _filteredPasswords = [];
  // todo If user IOS 12 and above dont use credit card scanner plugin.

  CardDetails? _cardDetails;
  CardScanOptions scanOptions = const CardScanOptions(
    scanCardHolderName: true,
    validCardsToScanBeforeFinishingScan: 5,
    possibleCardHolderNamePositions: [
      CardHolderNameScanPosition.aboveCardNumber,
      CardHolderNameScanPosition.belowCardNumber,
    ],
  );

  Future<void> scanCard() async {
    final CardDetails? cardDetails =
        await CardScanner.scanCard(scanOptions: scanOptions);
    if (!mounted || cardDetails == null) return;
    setState(() {
      _cardDetails = cardDetails;
    });
    debugPrint('Card number: ${cardDetails.cardNumber}');
  }

  void onSearch(String query) {
    if (query.isEmpty) {
      setState(() {
        _filteredPasswords = boxPasswords.values.toList() as List<Password>;
      });
    } else {
      setState(() {
        _filteredPasswords = boxPasswords
            .toMap()
            .values
            .where((password) =>
                password.name.toLowerCase().contains(query.toLowerCase()))
            .toList() as List<Password>;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: costumAppBar(
          title: title, color: Colors.transparent, context: context),
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
                  return ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                    tileColor: Colors.white,
                    title: Text(
                      password.name,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      '•' * password.password.toString().length,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 10,
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
                            onPressed: () {},
                            icon: const Icon(Icons.copy),
                            color: Colors.black,
                          ),
                          IconButton(
                            onPressed: () {
                              setState(() {
                                boxPasswords.deleteAt(index);
                                _filteredPasswords.removeAt(index);
                              });
                            },
                            icon: const Icon(Icons.more_vert),
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
                      showPasswordEditBottomSheet(
                        context,
                        nameController: nameController,
                        passwordController: passwordController,
                        isUpdate: true,
                        index: index,
                        filteredPasswords: _filteredPasswords,
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
            heroTag: 'scan',
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(56)),
            ),
            backgroundColor: AppColors.primaryColor,
            onPressed: () {
              // if(_cardDetails == null){
              //   // scanCard();
              // } else {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return CardHolderInfo(
                  cardDetails: _cardDetails,
                );
              }));
              // }
              // scanCard();
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
