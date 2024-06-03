import 'package:flutter/material.dart';
import 'package:quiz_app/theme/colors.dart';
import 'package:quiz_app/view/widgets/create_quiz_dialog.dart';

class CreateNewQuizButton extends StatelessWidget {
  const CreateNewQuizButton({super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
        splashColor: AppColors.red,
        borderRadius: BorderRadius.circular(100),
        onTap: () {
          showAdaptiveDialog(
              context: context, builder: (context) => CreateQuizDailog());
        },
        child: Ink(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100),
              gradient: const LinearGradient(colors: [
                Color.fromARGB(119, 64, 51, 247),
                Color.fromARGB(116, 252, 89, 53),
              ], begin: Alignment.bottomLeft, end: Alignment.topRight)),
          width: 140,
          height: 40,
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.addchart_rounded,
                color: Colors.white,
              ),
              SizedBox(
                width: 5,
              ),
              Text(
                "New Quiz",
                style: TextStyle(color: Colors.white),
              )
            ],
          ),
        ));
  }
}
