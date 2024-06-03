import 'package:flutter/material.dart';
import 'package:quiz_app/notifiers_providers/quiz_notifier.dart';
import 'package:quiz_app/theme/colors.dart';
import 'package:quiz_app/utils/routes.dart';

// ignore: must_be_immutable
class CreateNewQuestionButton extends StatelessWidget {
  Quiz quiz;
  CreateNewQuestionButton({super.key, required this.quiz});

  @override
  Widget build(BuildContext context) {
    return InkWell(
        splashColor: AppColors.red,
        borderRadius: BorderRadius.circular(100),
        onTap: () {
          Navigator.pushNamed(context, appRoutes.createQuestion,
              arguments: {"quiz_name": quiz.name});
        },
        child: Ink(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100),
              gradient: const LinearGradient(colors: [
                Color.fromARGB(218, 53, 39, 245),
                Color.fromARGB(198, 253, 72, 31),
              ], begin: Alignment.bottomLeft, end: Alignment.topRight)),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.all(5.0),
                child: Icon(
                  Icons.add_rounded,
                  color: Colors.white,
                  size: 22,
                ),
              ),
            ],
          ),
        ));
  }
}
