// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';

import 'package:strong_password/View/component/costum_button.dart';
import 'package:strong_password/View/pages/Details/details_password_view.dart';
import 'package:strong_password/models/card.dart';

import '../../../provider/credit_card/credit_card_notifier.dart';

// ignore: must_be_immutable
class EditCardDetails extends StatefulWidget {
  String? cardHolder;
  String? cardNumber;
  String? cardExpiry;
  String? cardCvv;

  CreditCard? card;
  bool isUpdate;

  EditCardDetails({
    super.key,
    this.cardHolder,
    this.cardNumber,
    this.cardExpiry,
    this.cardCvv,
    this.card, // Eğer güncelleme yapıyorsak hangi kart olduğunu bilmeliyiz.
    this.isUpdate = false,
  });

  @override
  // ignore: library_private_types_in_public_api
  _EditCardDetailsState createState() => _EditCardDetailsState();
}

class _EditCardDetailsState extends State<EditCardDetails> {
  late final CreditCardNotifier cardProvider;

  final TextEditingController _cardNameController = TextEditingController();
  final TextEditingController _cardNumberController = TextEditingController();
  final TextEditingController _cardExpireDateController =
      TextEditingController();
  final TextEditingController _cardCvvController = TextEditingController();

  final String _cardHolderName = '';
  final String _cardNumber = '';
  final String _expireDate = '';

  @override
  void initState() {
    super.initState();
    _cardNameController.text = widget.cardHolder ?? '';
    _cardNumberController.text = widget.cardNumber ?? '';
    _cardExpireDateController.text = widget.cardExpiry ?? '';
    _cardCvvController.text = widget.cardCvv ?? '';

    cardProvider = Provider.of<CreditCardNotifier>(context, listen: false);
  }

  @override
  void dispose() {
    _cardNameController.dispose();
    _cardNumberController.dispose();
    _cardExpireDateController.dispose();
    _cardCvvController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        actions: const [
          // GestureDetector(
          //   onTap: () {

          //   },
          //   child: Container(
          //     padding: const EdgeInsets.all(8.0),
          //     color: Colors.transparent,
          //     child: const Text(
          //       'Preview',
          //       style: TextStyle(
          //         color: Colors.black,
          //         fontSize: 16,
          //         fontWeight: FontWeight.w500,
          //       ),
          //     ),
          //   ),
          // ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ListView(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.04,
            ),
            const Text(
              'Credit Card Details',
              style: TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.w600,
                color: Colors.red,
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.04,
            ),
            CostumTextField(
              controller: _cardNameController,
              labelText: 'Card Label',
            ),
            const SizedBox(height: 20),
            CostumTextField(
              controller: _cardNumberController,
              labelText: 'Card Number',
            ),
            const SizedBox(height: 20),
            CostumTextField(
              controller: _cardExpireDateController,
              labelText: 'Expire Date',
            ),
            const SizedBox(height: 20),
            CostumTextField(
              controller: _cardCvvController,
              labelText: 'CVV',
            ),
            const Gap(20),
            CostumButton(
                onPressed: () {
                  if (widget.isUpdate) {
                    cardProvider.updateCard(
                      card: CreditCard(
                        cardHolder: _cardHolderName,
                        cardNumber: _cardNumber,
                        cardExpiry: _expireDate,
                        cardCvv: _cardCvvController.text,
                      ),
                      oldCardIndex: cardProvider.cards.indexOf(widget.card!),
                    );
                  } else {
                    cardProvider.addCard(
                      card: CreditCard(
                        cardHolder: _cardHolderName,
                        cardNumber: _cardNumber,
                        cardExpiry: _expireDate,
                        cardCvv: _cardCvvController.text,
                      ),
                    );
                  }
                },
                buttonText: 'Save Card'),
          ],
        ),
      ),
    );
  }
}
