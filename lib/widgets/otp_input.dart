
import 'package:flutter/material.dart';

/// Single OTP input slot
class OTPInputSlot extends StatelessWidget {
  final String char;
  final bool isActive;

  const OTPInputSlot({
    Key? key,
    required this.char,
    this.isActive = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Theme.of(context).inputDecorationTheme.fillColor,
        border: Border.all(
          color: isActive ? Theme.of(context).colorScheme.primary : Colors.grey,
          width: isActive ? 2 : 1,
        ),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        char,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
    );
  }
}

/// OTP input group
class OTPInputGroup extends StatelessWidget {
  final int length;
  final List<String> values;
  final Function(String, int)? onChanged;

  const OTPInputGroup({
    Key? key,
    required this.length,
    required this.values,
    this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(length, (index) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0),
          child: SizedBox(
            width: 40,
            height: 40,
            child: TextField(
              textAlign: TextAlign.center,
              maxLength: 1,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                counterText: '',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              onChanged: (val) {
                if (onChanged != null) onChanged!(val, index);
              },
              controller: TextEditingController(text: values[index]),
            ),
          ),
        );
      }),
    );
  }
}

/// Optional separator widget
class OTPSeparator extends StatelessWidget {
  final Widget? separator;

  const OTPSeparator({Key? key, this.separator}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return separator ??
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0),
          child: Text("-", style: Theme.of(context).textTheme.bodyMedium),
        );
  }
}
