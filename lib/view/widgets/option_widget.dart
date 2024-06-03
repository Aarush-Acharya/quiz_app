import 'package:flutter/material.dart';
import 'package:quiz_app/theme/colors.dart';
import 'package:quiz_app/utils/options_enum.dart';

class OptionTile extends StatelessWidget {
  final Options option;
  final TextEditingController optionController;
  const OptionTile({super.key, required this.option, required this.optionController});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Text(option.name),
            const SizedBox(
              width: 10,
            ),
            Expanded(
              child: TextField(
                style: const TextStyle(fontSize: 16),
                controller: optionController,
                decoration: const InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: AppColors.red),
                    ),
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Color.fromARGB(60, 185, 184, 184)))),
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 10,
        )
      ],
    );
  }
}
