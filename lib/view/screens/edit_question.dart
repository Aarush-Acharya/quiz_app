import 'dart:convert';

import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quiz_app/notifiers_providers/quiz_notifier.dart';
import 'package:quiz_app/theme/colors.dart';
import 'package:quiz_app/utils/options_enum.dart';
import 'package:http/http.dart' as http;
import 'package:quiz_app/utils/routes.dart';
import 'package:quiz_app/view/widgets/create_question_section.dart';
import 'package:quiz_app/view/widgets/option_widget.dart';

class EditQuestionScreen extends ConsumerWidget {
  const EditQuestionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    String quizName = args["quiz_name"];
    Question question = args["question"];
    TextEditingController questionController =
        TextEditingController(text: question.question);
    TextEditingController optionAController =
        TextEditingController(text: question.options[0]);
    TextEditingController optionBController =
        TextEditingController(text: question.options[1]);
    TextEditingController optionCController =
        TextEditingController(text: question.options[2]);
    TextEditingController optionDController =
        TextEditingController(text: question.options[3]);
    TextEditingController marksController =
        TextEditingController(text: question.marks.toString());
    List<TextEditingController> optionsController = [
      optionAController,
      optionBController,
      optionCController,
      optionDController
    ];

    SingleValueDropDownController dropDownController =
        SingleValueDropDownController(
            data: DropDownValueModel(name: question.ans, value: question.ans));

    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.only(
                    top: 60,
                  ),
                  child: Text(
                    "Edit the Question",
                    style: TextStyle(
                      fontSize: 35,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 40,
                ),
                Section(
                  name: "Question",
                  child: TextField(
                    style: const TextStyle(fontSize: 16),
                    maxLines: 3,
                    controller: questionController,
                    decoration: const InputDecoration(
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: AppColors.red),
                        ),
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Color.fromARGB(60, 185, 184, 184)))),
                  ),
                ),
                Section(
                    name: "Options",
                    child: Column(
                      children: Options.values
                          .where((option) => option != Options.empty)
                          .map((option) => OptionTile(
                              option: option,
                              optionController:
                                  optionsController[option.index]))
                          .toList(),
                    )),
                Section(
                    name: "Answer",
                    child: DropDownTextField(
                      controller: dropDownController,
                      listTextStyle:
                          const TextStyle(color: Colors.black, fontSize: 16),
                      textFieldDecoration: const InputDecoration(
                          labelStyle: TextStyle(fontSize: 14),
                          labelText: "Choose the correct option",
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: AppColors.red),
                          ),
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color.fromARGB(60, 185, 184, 184)))),
                      textStyle: const TextStyle(fontSize: 18),
                      dropDownList:Options.values
                          .where((option) => option != Options.empty).map((option) {
                        return DropDownValueModel(
                            value: option.name, name: option.name);
                      }).toList(),
                    )),
                Section(
                    name: "Marks",
                    child: TextField(
                      style: const TextStyle(fontSize: 16),
                      controller: marksController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: AppColors.red),
                          ),
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color.fromARGB(60, 185, 184, 184)))),
                    )),
                const SizedBox(
                  height: 40,
                ),
                ElevatedButton(
                    onPressed: () async {
                      var headers = {'Content-Type': 'application/json'};
                      var request = http.Request(
                          'POST',
                          Uri.parse(
                              'https://quiz-app-backend-s6uc.onrender.com/editQuestion'));
                      request.body = jsonEncode({
                        "question": questionController.text,
                        "quiz_name": quizName,
                        "options": [
                          optionAController.text,
                          optionBController.text,
                          optionCController.text,
                          optionDController.text
                        ],
                        "ans": dropDownController.dropDownValue!.name,
                        "ques_id": question.id,
                        "marks": int.parse(marksController.text)
                      });
                      request.headers.addAll(headers);

                      http.StreamedResponse response = await request.send();

                      if (response.statusCode == 200) {
                        print(await response.stream.bytesToString());
                        await ref
                            .read(asyncQuizzesProvider.notifier)
                            .refetchQuizzes();
                        Navigator.pop(context);
                      } else {
                        print(response.reasonPhrase);
                      }
                    },
                    child: const Text(
                      "Edit",
                      style: TextStyle(color: Colors.white),
                    )),
                const SizedBox(
                  height: 10,
                ),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        side: const BorderSide(color: AppColors.red)),
                    onPressed: () async {
                      showAdaptiveDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                                title: const Text(
                                    'You sure you want to Delete this question'),
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
                                                  'https://quiz-app-backend-s6uc.onrender.com/deleteQuestion'));
                                          request.body = jsonEncode({
                                            "quiz_name": quizName,
                                            "ques_id": question.id,
                                          });
                                          request.headers.addAll(headers);

                                          http.StreamedResponse response =
                                              await request.send();

                                          if (response.statusCode == 200) {
                                            print(await response.stream
                                                .bytesToString());

                                            await ref
                                                .read(asyncQuizzesProvider
                                                    .notifier)
                                                .refetchQuizzes();
                                            print("Refecthed ");
                                            Navigator.popUntil(
                                                context,
                                                (route) =>
                                                    route.settings.name ==
                                                    appRoutes.editQuiz);
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
                    },
                    child: const Text(
                      "Delete",
                      style: TextStyle(color: Colors.white),
                    ))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
