import 'package:flutter/material.dart';

class Section extends StatelessWidget {
  final String name;
  final Widget child;
  const Section({super.key, required this.child, required this.name});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(name),
        const SizedBox(
          height: 5,
        ),
        child,
        const SizedBox(
          height: 30,
        )
      ],
    );
  }
}
