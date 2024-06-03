import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quiz_app/notifiers_providers/quiz_notifier.dart';
import 'package:quiz_app/theme/colors.dart';
import 'package:http/http.dart' as http;


class CreateQuizDailog extends ConsumerWidget {
  CreateQuizDailog({super.key});
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController durationController = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AlertDialog.adaptive(
      title: const Text('Create a New Quiz'),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Name"),
            const SizedBox(
              height: 5,
            ),
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: AppColors.red),
                  ),
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Color.fromARGB(60, 185, 184, 184)))),
            ),
            const SizedBox(
              height: 30,
            ),
            const Text("Description"),
            const SizedBox(
              height: 5,
            ),
            TextField(
              controller: descriptionController,
              maxLines: 3,
              decoration: const InputDecoration(
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: AppColors.red),
                  ),
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Color.fromARGB(60, 185, 184, 184)))),
            ),
            const SizedBox(
              height: 30,
            ),
            const Text("Duration (minutes)"),
            const SizedBox(
              height: 5,
            ),
            TextField(
              controller: durationController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: AppColors.red),
                  ),
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Color.fromARGB(60, 185, 184, 184)))),
            ),
            const SizedBox(
              height: 40,
            ),
            ElevatedButton(
                onPressed: () async {
                  // Call for creation of quiz
                  var headers = {'Content-Type': 'application/json'};
                  var request = http.Request(
                      'POST',
                      Uri.parse(
                          'https://quiz-app-backend-s6uc.onrender.com/createQuiz'));
                  request.body = jsonEncode({
                    "name": nameController.text,
                    "description": descriptionController.text,
                    "author": "Me",
                    "duration": int.parse(durationController.text)
                  });
                  request.headers.addAll(headers);

                  http.StreamedResponse response = await request.send();

                  if (response.statusCode == 200) {
                    print(await response.stream.bytesToString());
                    Navigator.pop(context);
                    ref.read(asyncQuizzesProvider.notifier).refetchQuizzes();
                  } else {
                    print(response.reasonPhrase);
                  }
                },
                child: const Text(
                  "Create",
                  style: TextStyle(color: Colors.white),
                ))
          ],
        ),
      ),
    );
  }
}
