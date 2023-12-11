import 'package:flutter/material.dart';

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
                      child: _controller.value < 0.5
                          ? frontCard()
                          : backCard(Colors.grey.shade500),
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
                                      cardExpiryDate.text;
                                    });
                                  },
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                  ),
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
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5)),
                      backgroundColor: Colors.grey.shade600,
                      minimumSize: const Size(double.infinity, 50)),
                  onPressed: () {},
                  child: const Text(
                    'Checkout',
                    style: TextStyle(color: Colors.white),
                  ))
            ],
          ),
        ),
      ),
    );
  }

// front of the card
  // Widget frontCard() {
  //   return Container(
  //     padding: const EdgeInsets.all(20),
  //     decoration: BoxDecoration(
  //       borderRadius: BorderRadius.circular(8),
  //       gradient: const LinearGradient(
  //         begin: Alignment.topLeft,
  //         end: Alignment.bottomRight,
  //         colors: [Colors.blue, Colors.green],
  //       ),
  //     ),
  //     width: double.infinity,
  //     height: 230,
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         Row(
  //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //           children: [
  //             const Text(
  //               'business credit',
  //               style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
  //             ),
  //             Image.asset('assets/temassiz.png')
  //           ],
  //         ),
  //         const SizedBox(
  //           height: 30,
  //         ),
  //         Row(
  //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //           children: [
  //             Text(
  //               cardNumberController.text.isEmpty
  //                   ? '**** **** **** ****'
  //                   : cardNumberController.text,
  //               style:
  //                   const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
  //             ),
  //             Image.asset('assets/cip.png')
  //           ],
  //         ),
  //         const Spacer(),
  //         Row(
  //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //           children: [
  //             Column(
  //               crossAxisAlignment: CrossAxisAlignment.start,
  //               children: [
  //                 const Text(
  //                   'CARD HOLDER',
  //                   style: TextStyle(fontWeight: FontWeight.w500, fontSize: 15),
  //                 ),
  //                 Text(
  //                   cardHolderController.text.isEmpty
  //                       ? 'NAME ON CARD'
  //                       : cardHolderController.text.toUpperCase(),
  //                   style: const TextStyle(
  //                       fontWeight: FontWeight.w500, fontSize: 15),
  //                 )
  //               ],
  //             ),
  //             Column(
  //               crossAxisAlignment: CrossAxisAlignment.start,
  //               children: [
  //                 const Text(
  //                   'EXPIRES',
  //                   style: TextStyle(fontWeight: FontWeight.w500, fontSize: 15),
  //                 ),
  //                 Text(
  //                   cardExpiryDate.text.isEmpty ? 'MM/YY' : cardExpiryDate.text,
  //                   style: const TextStyle(
  //                       fontWeight: FontWeight.w500, fontSize: 15),
  //                 )
  //               ],
  //             )
  //           ],
  //         )
  //       ],
  //     ),
  //   );
  // }

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

  String generateMaskedCardNumber() {
    final String rawCardNumber = cardNumberController.text;
    const int totalDigits = 16;
    final int enteredDigits = rawCardNumber.length;
    final String maskedPart = '*' * (totalDigits - enteredDigits);

    return '$enteredDigits$maskedPart';
  }

// back of the card
  Widget backCard(Color color) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: color,
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
}
