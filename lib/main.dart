import 'package:bankcard_flip/home.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const FlipCard(),
    );
  }
}

// String generateMaskedCardNumber() {
//   final String rawCardNumber = cardNumberController.text;
//   final int totalDigits = 16;
//   final int enteredDigits = rawCardNumber.length;
//   final String maskedPart = '*' * (totalDigits - enteredDigits);

//   // If there are characters entered, replace asterisks one by one
//   final String visiblePart = rawCardNumber
//       .split('')
//       .take(totalDigits - maskedPart.length)
//       .join();

//   return '$maskedPart$visiblePart';
// }
