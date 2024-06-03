import 'dart:async';

import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gradient_animation_text/flutter_gradient_animation_text.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quiz_app/notifiers_providers/quiz_notifier.dart';
import 'package:quiz_app/notifiers_providers/user_answers_provider.dart';
import 'package:quiz_app/theme/colors.dart';
import 'package:quiz_app/utils/options_enum.dart';
import 'package:quiz_app/view/widgets/submit_answers_button.dart';

class GiveQuiz extends ConsumerWidget {
  const GiveQuiz({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    String quizName = args["quiz_name"];
    Quiz quiz = ref.read(asyncQuizzesProvider.notifier).getQuizByName(quizName);
    return Scaffold(
      body: SingleChildScrollView(
          child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(
                top: 60,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const GradientAnimationText(
                        text: Text(
                          'Give, ',
                          style: TextStyle(
                            fontSize: 40,
                          ),
                        ),
                        colors: [AppColors.blue, AppColors.red],
                        duration: Duration(seconds: 2),
                      ),
                      Text(
                        quiz.name,
                        style: const TextStyle(
                          fontSize: 35,
                        ),
                      )
                    ],
                  ),
                  CircularCountDownTimer(
                    width: 30,
                    height: 30,
                    textFormat: '',
                    isTimerTextShown: false,
                    duration: quiz.duration * 60,
                    isReverse: true,
                    isReverseAnimation: true,
                    controller: CountDownController(),
                    ringColor: Colors.grey[300]!,
                    fillColor: Colors.transparent,
                    fillGradient:
                        LinearGradient(colors: [AppColors.blue, AppColors.red]),
                    backgroundColor: Colors.black,
                    strokeWidth: 2.0,
                    onComplete: () {
                      Navigator.pop(context);
                      showDialog(
                          context: context,
                          builder: (context) => AlertDialog.adaptive(
                                title:
                                    Text("Oops Seems like you ran out of Time"),
                                actions: [
                                  TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: Text("Continue"))
                                ],
                              ));
                    },
                  )
                ],
              ),
            ),
            const SizedBox(
              height: 40,
            ),
            Text(
              quiz.description,
              style: const TextStyle(color: Color.fromARGB(128, 124, 124, 124)),
            ),
            const SizedBox(
              height: 60,
            ),
            SizedBox(
              height: 500,
              child: PageView(
                children: quiz.questions.map((ques) {
                  int index = quiz.questions.indexOf(ques);
                  Options groupValue = ref.watch(userAnswers)[index];
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        ques.question,
                        style: const TextStyle(color: AppColors.headingWhite),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text('${ques.marks.toString()} Marks'),
                      const SizedBox(
                        height: 20,
                      ),
                      Column(
                        children: ques.options.map((option) {
                          Options optionValue =
                              Options.values[ques.options.indexOf(option)];
                          return ListTile(
                            title: Text(option),
                            leading: Radio(
                              value: optionValue,
                              groupValue: groupValue,
                              onChanged: (value) {
                                ref.read(userAnswers.notifier).update((state) {
                                  final updatedAnswers = [...state];
                                  updatedAnswers[index] = value!;
                                  return updatedAnswers;
                                });
                                // groupValue = option_value;
                              },
                            ),
                          );
                        }).toList(),
                      )
                    ],
                  );
                }).toList(),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: SubmitAnswersButton(questions: quiz.questions),
            )
          ],
        ),
      )),
    );
  }
}
