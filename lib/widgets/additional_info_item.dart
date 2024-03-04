import 'package:flutter/material.dart';

class AdditionalInfoItem extends StatelessWidget {
  final IconData lableIcon;
  final String lableText;
  final String lableValue;

  const AdditionalInfoItem(
      {super.key,
      required this.lableIcon,
      required this.lableText,
      required this.lableValue});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(
          lableIcon,
          size: 40,
        ),
        const SizedBox(
          height: 8.0,
        ),
        Text(
          lableText,
          style: const TextStyle(fontSize: 18),
        ),
        const SizedBox(
          height: 8.0,
        ),
        Text(
          lableValue,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
      ],
    );
  }
}
