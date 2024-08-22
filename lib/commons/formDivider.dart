import 'package:flutter/material.dart';

class formDivider extends StatelessWidget {
  final String text;
  const formDivider({
    super.key,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Flexible(
          child: Divider(
            color: Colors.grey,
            thickness: 0.5,
            indent: 60,
            endIndent: 5,
          ),
        ),
        Text(
          text,
        ),
        SizedBox(
          height: 60,
        ),
        Flexible(
          child: Divider(
            color: Colors.grey,
            thickness: 0.5,
            indent: 5,
            endIndent: 60,
          ),
        ),
      ],
    );
  }
}
