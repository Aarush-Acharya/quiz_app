import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gradient_borders/box_borders/gradient_box_border.dart';
import 'package:quiz_app/notifiers_providers/quiz_notifier.dart';
import 'package:quiz_app/notifiers_providers/user_answers_provider.dart';
import 'package:quiz_app/theme/colors.dart';
import 'package:http/http.dart' as http;
import 'package:quiz_app/utils/routes.dart';

class QuizTile extends ConsumerWidget {
  final Quiz quiz;
  const QuizTile({super.key, required this.quiz});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.only(left: 20, right: 20, top: 15),
          decoration: BoxDecoration(
            color: const Color.fromARGB(81, 34, 34, 34),
            borderRadius: BorderRadius.circular(10),
            border: const GradientBoxBorder(
              gradient: LinearGradient(colors: [AppColors.blue, AppColors.red]),
              width: 1,
            ),
          ),
          height: 140,
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    quiz.name,
                    style: const TextStyle(
                        color: AppColors.headingWhite, fontSize: 22),
                  ),
                  Text(
                    '${quiz.duration.toString()} min',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 20),
                  )
                ],
              ),
              const SizedBox(
                height: 15,
              ),
              Text(
                quiz.description,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 16),
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: Material(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      InkWell(
                        borderRadius: BorderRadius.circular(100),
                        splashColor: AppColors.red,
                        onTap: () async {
                          showAdaptiveDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                    title: Text(
                                        'You sure you want to delete ${quiz.name}?'),
                                    actions: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          TextButton(
                                            child: const Text("Yes"),
                                            onPressed: () async {
                                              var headers = {
                                                'Content-Type':
                                                    'application/json'
                                              };
                                              var request = http.Request(
                                                  'POST',
                                                  Uri.parse(
                                                      'https://quiz-app-backend-s6uc.onrender.com/deleteQuiz'));
                                              request.body = jsonEncode(
                                                  {"quiz_name": quiz.name});
                                              request.headers.addAll(headers);

                                              http.StreamedResponse response =
                                                  await request.send();

                                              if (response.statusCode == 200) {
                                                print(await response.stream
                                                    .bytesToString());
                                                ref
                                                    .watch(asyncQuizzesProvider
                                                        .notifier)
                                                    .refetchQuizzes();
                                                Navigator.pop(context);
                                              } else {
                                                print(response.reasonPhrase);
                                              }
                                            },
                                          ),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
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
                        },
                        child: Ink(
                          height: 34,
                          width: 34,
                          decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    Color.fromARGB(255, 62, 48, 250),
                                    Color.fromARGB(255, 255, 95, 59)
                                  ])),
                          child: const Center(
                            child: Icon(
                              Icons.delete_rounded,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 15,
                      ),
                      InkWell(
                        borderRadius: BorderRadius.circular(100),
                        splashColor: AppColors.red,
                        onTap: () {
                          if (!quiz.isComplete) {
                            Navigator.pushNamed(context, appRoutes.editQuiz,
                                arguments: {"quiz_name": quiz.name});
                          } else {
                            initialiseAnswerSheet(quiz.questions.length);
                            Navigator.pushNamed(context, appRoutes.giveQuiz,
                                arguments: {"quiz_name": quiz.name,});
                          }
                        },
                        child: Ink(
                          height: 34,
                          width: 34,
                          decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    Color.fromARGB(255, 62, 48, 250),
                                    Color.fromARGB(255, 255, 95, 59)
                                  ])),
                          child: Center(
                            child: Icon(
                              quiz.isComplete
                                  ? Icons.play_arrow_rounded
                                  : Icons.mode_edit_outline_rounded,
                              color: Colors.white,
                              size: quiz.isComplete ? null : 20,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
        const SizedBox(
          height: 30,
        )
      ],
    );
  }
}
