import 'dart:math';

import 'package:bankcard_flip/widgets/payment_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class FlipCard extends StatefulWidget {
  const FlipCard({super.key});

  @override
  State<FlipCard> createState() => _FlipCardState();
}

class _FlipCardState extends State<FlipCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _frontRotation;
  late Animation<double> _backRotation;

  TextEditingController cardNumberController = TextEditingController();
  TextEditingController cardHolderController = TextEditingController();
  TextEditingController cardExpiryDate = TextEditingController();
  TextEditingController cvvController = TextEditingController();

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _frontRotation = Tween<double>(begin: 0, end: 180).animate(_controller);
    _backRotation = Tween<double>(begin: 180, end: 360).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggleCard() {
    if (_controller.isCompleted) {
      _controller.reverse();
    } else {
      _controller.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            children: [
              GestureDetector(
                onTap: _toggleCard,
                child: AnimatedBuilder(
                  animation: _controller,
                  builder: (context, child) {
                    return Transform(
                      transform: Matrix4.identity()
                        ..setEntry(3, 2, 0.002)
                        ..rotateY(_controller.value < 0.5
                            ? _frontRotation.value * 3.1415927 / 180
                            : _backRotation.value * 3.1415927 / 180),
                      alignment: Alignment.center,
                      child: _controller.value < 0.5 ? frontCard() : backCard(),
                    );
                  },
                ),
              ),
              const SizedBox(
                height: 25,
              ),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: Colors.grey.shade300,
                ),
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Card Number',
                      style: TextStyle(fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextField(
                      onTap: () {},
                      keyboardType: TextInputType.number,
                      controller: cardNumberController,
                      onChanged: (value) {
                        setState(() {
                          cardNumberController.text;
                        });
                      },
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                      ),
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(16)
                      ],
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    const Text(
                      'Card Holder',
                      style: TextStyle(fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextField(
                      keyboardType: TextInputType.name,
                      controller: cardHolderController,
                      onChanged: (value) {
                        setState(() {
                          cardHolderController.text;
                        });
                      },
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Flexible(
                            flex: 5,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Expiry Date',
                                  style: TextStyle(fontWeight: FontWeight.w700),
                                ),
                                TextField(
                                  keyboardType: TextInputType.number,
                                  controller: cardExpiryDate,
                                  onChanged: (value) {
                                    setState(() {
                                      // cardExpiryDate.text;
                                      formatCardExpiryDate(value);
                                    });
                                  },
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                  ),
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly,
                                    LengthLimitingTextInputFormatter(4)
                                  ],
                                ),
                              ],
                            )),
                        const SizedBox(
                          width: 10,
                        ),
                        Flexible(
                            flex: 5,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'CVV',
                                  style: TextStyle(fontWeight: FontWeight.w700),
                                ),
                                TextField(
                                  onTap: () {
                                    _toggleCard();
                                  },
                                  controller: cvvController,
                                  keyboardType: TextInputType.number,
                                  onChanged: (value) {
                                    setState(() {
                                      cvvController.text;
                                    });
                                  },
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                  ),
                                ),
                              ],
                            ))
                      ],
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: 25,
              ),
              PaymentButton(
                enabled: true,
                width: screenSize.width - 20 * 2,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // front of the card
  Widget frontCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.blue, Colors.green],
        ),
      ),
      width: double.infinity,
      height: 230,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'business credit',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
              ),
              Image.asset('assets/temassiz.png')
            ],
          ),
          const SizedBox(
            height: 30,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                generateMaskedCardNumber(),
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              ),
              Image.asset('assets/cip.png')
            ],
          ),
          const Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'CARD HOLDER',
                    style: TextStyle(fontWeight: FontWeight.w500, fontSize: 15),
                  ),
                  Text(
                    cardHolderController.text.isEmpty
                        ? 'NAME ON CARD'
                        : cardHolderController.text.toUpperCase(),
                    style: const TextStyle(
                        fontWeight: FontWeight.w500, fontSize: 15),
                  )
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'EXPIRES',
                    style: TextStyle(fontWeight: FontWeight.w500, fontSize: 15),
                  ),
                  Text(
                    cardExpiryDate.text.isEmpty ? 'MM/YY' : cardExpiryDate.text,
                    style: const TextStyle(
                        fontWeight: FontWeight.w500, fontSize: 15),
                  )
                ],
              )
            ],
          )
        ],
      ),
    );
  }



  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.selection.baseOffset == 0) {
      return newValue;
    }
    String inputData = newValue.text;
    StringBuffer buffer = StringBuffer();

    for (var i = 0; i < inputData.length; i++) {
      buffer.write(inputData[i]);
      int index = i + 1;

      if (index % 4 == 0 && inputData.length != index) {
        buffer.write("  ");
      }
    }
    return TextEditingValue(
      text: buffer.toString(),
      selection: TextSelection.collapsed(
        offset: buffer.toString().length,
      ),
    );
  }




  // String generateMaskedCardNumber() {
  //   final String rawCardNumber = cardNumberController.text
  //       .replaceAll(RegExp(r'\D'), ''); // Remove non-numeric characters
  //   const int totalDigits = 16;

  //   if (rawCardNumber.length >= totalDigits) {
  //     return formatCardNumber(rawCardNumber);
  //   }

  //   final int enteredDigits = rawCardNumber.length;
  //   final int remainingDigits = totalDigits - enteredDigits;

  //   // Calculate the number of sets of 4 asterisks needed with a space between each set.
  //   final int setsOfAsterisks = (remainingDigits / 4).ceil();

  //   // Create a masked part with 4 asterisks and a space between each set.
  //   final String maskedPart = List.filled(setsOfAsterisks, '****').join(' ');

  //   // Extract the entered part of the card number.
  //   final String enteredPart = formatCardNumber(rawCardNumber);

  //   // Concatenate the entered part and the masked part to form the masked card number.
  //   return '$enteredPart $maskedPart';
  // }

// Function to format the card number in sets of 4
  // String formatCardNumber(String cardNumber) {
  //   return RegExp(r'.{1,4}')
  //       .allMatches(cardNumber)
  //       .map((match) => match.group(0)!)
  //       .join(' ');
  // }

  // String generateMaskedCardNumber() {
  //   final String rawCardNumber =
  //       cardNumberController.text.replaceAll(RegExp(r'\D'), '');
  //   const int totalDigits = 16;

  //   if (rawCardNumber.length >= totalDigits) {
  //     return rawCardNumber;
  //   }

  //   final int enteredDigits = rawCardNumber.length;
  //   final int remainingDigits = totalDigits - enteredDigits;
  //   final String maskedPart =
  //       '**** **** **** ****'.substring(0, remainingDigits);
  //   final String enteredPart = rawCardNumber.substring(0, enteredDigits);

  //   return '$enteredPart$maskedPart';
  // }

// back of the card
  Widget backCard() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.blue, Colors.green],
        ),
      ),
      width: double.infinity,
      height: 230,
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(top: 30),
            height: 50,
            width: double.infinity,
            color: Colors.black,
          ),
          Container(
            padding: const EdgeInsets.all(10),
            margin: const EdgeInsets.all(20),
            width: double.infinity,
            decoration: BoxDecoration(
                border: Border.all(color: Colors.white),
                borderRadius: BorderRadius.circular(10)),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
              const Text(
                'CVV',
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 15),
              ),
              const SizedBox(
                height: 5,
              ),
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(7),
                  color: Colors.white,
                ),
                height: 40,
                child: Center(
                  child: Text(cvvController.text),
                ),
              )
            ]),
          )
        ],
      ),
    );
  }

// format for the expiry date
  void formatCardExpiryDate(String input) {
    if (input.length >= 3) {
      cardExpiryDate.text =
          '${input.substring(0, 2)}/${input.substring(2, min(4, input.length))}';
      cardExpiryDate.selection = TextSelection.fromPosition(
        TextPosition(offset: cardExpiryDate.text.length),
      );
    }
  }
}
