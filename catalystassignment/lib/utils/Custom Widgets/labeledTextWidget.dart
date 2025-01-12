import 'package:flutter/material.dart';

class LabeledText extends StatelessWidget {
  final String label;
  final String value;
  final TextStyle? labelStyle;
  final TextStyle? valueStyle;

  const LabeledText({
    Key? key,
    required this.label,
    required this.value,
    this.labelStyle,
    this.valueStyle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: '$label: ',
            style: labelStyle ??
                const TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                  fontWeight: FontWeight.bold, // Bold label
                ),
          ),
          TextSpan(
            text: value,
            style: valueStyle ??
                const TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                  fontWeight: FontWeight.normal, // Normal value
                ),
          ),
        ],
      ),
    );
  }
}
