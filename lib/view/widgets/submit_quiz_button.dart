import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quiz_app/notifiers_providers/quiz_notifier.dart';
import 'package:quiz_app/notifiers_providers/section_state_provider.dart';
import 'package:quiz_app/theme/colors.dart';
import 'package:http/http.dart' as http;
import 'package:quiz_app/utils/routes.dart';

class SubmitQuizButton extends ConsumerWidget {
  final String quizName;
  const SubmitQuizButton({super.key, required this.quizName});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return InkWell(
        splashColor: AppColors.red,
        borderRadius: BorderRadius.circular(100),
        onTap: () async {
          showAdaptiveDialog(
              context: context,
              builder: (context) => AlertDialog(
                    title: Text('You sure you want to submit $quizName?'),
                    actions: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextButton(
                            child: const Text("Yes"),
                            onPressed: () async {
                              var headers = {
                                'Content-Type': 'application/json'
                              };
                              var request = http.Request(
                                  'POST',
                                  Uri.parse(
                                      'https://quiz-app-backend-s6uc.onrender.com/submitQuiz'));
                              request.body =
                                  jsonEncode({"quiz_name": quizName});
                              request.headers.addAll(headers);

                              http.StreamedResponse response =
                                  await request.send();

                              if (response.statusCode == 200) {
                                print(await response.stream.bytesToString());
                                ref
                                    .read(sectionStateProvider.notifier)
                                    .update((state) => true);
                                Navigator.pushNamed(context, appRoutes.home);
                                ref
                                    .read(asyncQuizzesProvider.notifier)
                                    .refetchQuizzes();
                              } else {
                                print(response.reasonPhrase);
                              }
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
