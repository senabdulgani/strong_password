import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:strong_password/View/pages/Feature/password_generator.dart';
import 'package:strong_password/models/card.dart';

// ignore: must_be_immutable
class CardHolderInfo extends StatefulWidget {
  const CardHolderInfo({
    super.key,
    required this.card,
    this.cardLabel,
  });

  final CreditCard card;
  final String? cardLabel;


  @override
  State<CardHolderInfo> createState() => _CardHolderInfoState();
}

class _CardHolderInfoState extends State<CardHolderInfo> {
  bool isVisible = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.cardLabel ?? 'Card Info'),
        backgroundColor: Colors.transparent,
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                isVisible = !isVisible;
              });
            },
            icon: const Icon(Icons.visibility),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.04,
              ),
              Stack(
                children: [
                  Container(
                      height: MediaQuery.of(context).size.height * 0.25,
                      width: MediaQuery.of(context).size.width * 0.95,
                      // color: Colors.grey.shade300,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        gradient: const LinearGradient(
                          colors: [
                            Color.fromRGBO(44, 213, 228, 0.612),
                            Color.fromRGBO(214, 115, 72, 0.612),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      )),
                  Positioned(
                    bottom: 90,
                    left: 20,
                    child: Text(
                      isVisible
                          ? widget.card.cardNumber
                          : '**** ${widget.card.cardNumber.substring(12, 16)}',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 20,
                    left: 20,
                    child: Text(
                      isVisible
                          ? widget.card.cardHolder
                          : '*** ***',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 20,
                    right: 20,
                    child: Text(
                      isVisible
                          ? widget.card.cardExpiry
                          : '**/**',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 20,
                    right: 20,
                    child: Image.asset(
                      'assets/card-issuers/mastercard.png',
                      height: 50,
                      width: 50,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.06,
              ),
              CardPageInfoCard(
                fieldName: 'Card Number: ',
                text: isVisible
                    ? widget.card.cardNumber
                    : '**** ${widget.card.cardNumber.substring(12, 16)}',
              ),
              const Gap(10),
              CardPageInfoCard(
                  fieldName: 'Card Holder: ',
                  text: isVisible
                      ? widget.card.cardHolder
                      : '*** ***'),
              const Gap(10),
              CardPageInfoCard(
                  fieldName: 'Expiry Date: ',
                  text: isVisible
                      ? widget.card.cardExpiry
                      : '**/**'),
              const Gap(10),
              CardPageInfoCard(
                  fieldName: 'CVV: ', text: isVisible ? '***' : '404'),
              const Gap(20),
              const CostumDivider(),
              const Gap(10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  CircleButtonLarge(
                      onPressed: () {
                        
                      },
                      iconData: Icons.delete,
                      text: 'Delete Card',
                      iconColor: Colors.red),
                  CircleButtonLarge(
                      onPressed: () {
                        //todo share card information with url_launcher package
                      },
                      iconData: Icons.share,
                      text: 'Share Card'),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CardPageInfoCard extends StatelessWidget {
  const CardPageInfoCard({
    super.key,
    required this.text,
    required this.fieldName,
  });

  final String text;
  final String fieldName;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          RichText(
              text: TextSpan(children: [
            TextSpan(
              text: fieldName,
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey.shade600,
              ),
            ),
            TextSpan(
              text: text,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
          ])),
        ],
      ),
    );
  }
}
