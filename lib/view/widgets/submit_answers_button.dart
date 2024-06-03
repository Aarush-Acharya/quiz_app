import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quiz_app/notifiers_providers/quiz_notifier.dart';
import 'package:quiz_app/notifiers_providers/user_answers_provider.dart';
import 'package:quiz_app/theme/colors.dart';
import 'package:quiz_app/utils/routes.dart';

class SubmitAnswersButton extends ConsumerWidget {
  final List<Question> questions;
  const SubmitAnswersButton({super.key, required this.questions});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var answersToCheck = ref.watch(userAnswers);
    return InkWell(
        splashColor: AppColors.red,
        borderRadius: BorderRadius.circular(100),
        onTap: () async {
          showAdaptiveDialog(
              context: context,
              builder: (context) => AlertDialog(
                    title:
                        const Text('You sure you want to submit your Answers?'),
                    actions: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextButton(
                            child: const Text("Yes"),
                            onPressed: () async {
                              // Submit code
                              List<String> correctAnswers =
                                  questions.map((ques) => ques.ans).toList();

                              int totalMarks = questions.fold(
                                  0, (sum, question) => sum + question.marks);

                              int score = 0;
                              for (int i = 0; i < correctAnswers.length; i++) {
                                if (correctAnswers[i] ==
                                    answersToCheck[i].name) {
                                  score = score + questions[i].marks;
                                }
                              }
                              showAdaptiveDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                        title: const Text(
                                          'Congratulations 🥳, your score is',
                                          style: TextStyle(
                                              color: AppColors.headingWhite),
                                        ),
                                        content: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Text(
                                              '$score/$totalMarks',
                                              style:
                                                  const TextStyle(fontSize: 20),
                                            ),
                                          ],
                                        ),
                                        actions: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              TextButton(
                                                child: const Text(
                                                    "Proceed To Home"),
                                                onPressed: () {
                                                  Navigator.popUntil(
                                                      context,
                                                      (route) =>
                                                          route.settings.name ==
                                                          appRoutes.home);
                                                },
                                              ),
                                            ],
                                          )
                                        ],
                                      ));
                            },
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextButton(
                            child: const Text("No"),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                        ],
                      )
                    ],
                  ));
          // Submit Quiz
        },
        child: Ink(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100),
              gradient: const LinearGradient(colors: [
                Color.fromARGB(197, 53, 39, 245),
                Color.fromARGB(132, 253, 72, 31),
              ], begin: Alignment.bottomLeft, end: Alignment.topRight)),
          height: 40,
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 15.0),
                child: Text(
                  "Submit",
                  style: TextStyle(color: Colors.white),
                ),
              )
            ],
          ),
        ));
  }
}
