import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gradient_borders/box_borders/gradient_box_border.dart';
import 'package:quiz_app/notifiers_providers/quiz_notifier.dart';
import 'package:quiz_app/theme/colors.dart';
import 'package:quiz_app/utils/routes.dart';

class QuestionTile extends ConsumerWidget {
  final Question question;
  final String quizName;
  const QuestionTile(
      {super.key, required this.question, required this.quizName});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        Material(
          child: InkWell(
            onTap: () {
              Navigator.pushNamed(context, appRoutes.editQuestion,
                  arguments: {"quiz_name": quizName, "question": question});
            },
            child: Ink(
              padding: const EdgeInsets.only(
                  left: 20, right: 20, top: 15, bottom: 15),
              decoration: BoxDecoration(
                color: const Color.fromARGB(81, 34, 34, 34),
                borderRadius: BorderRadius.circular(10),
                border: const GradientBoxBorder(
                  gradient:
                      LinearGradient(colors: [AppColors.blue, AppColors.red]),
                  width: 1,
                ),
              ),
              height: 140,
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    question.question,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        color: AppColors.headingWhite, fontSize: 18),
                  ),
                  Expanded(
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Answer ${question.ans}'),
                          Text('${question.marks} marks')
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
        const SizedBox(
          height: 30,
        )
      ],
    );
  }
}
