import 'package:flutter/material.dart';
import 'package:flutter_gradient_animation_text/flutter_gradient_animation_text.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quiz_app/notifiers_providers/quiz_notifier.dart';
import 'package:quiz_app/theme/colors.dart';
import 'package:quiz_app/view/widgets/create_question_button.dart';
import 'package:quiz_app/view/widgets/question_widget.dart';
import 'package:quiz_app/view/widgets/submit_quiz_button.dart';

// ignore: must_be_immutable
class EditQuizScreen extends ConsumerWidget {
  const EditQuizScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

    String quizName = args["quiz_name"];
    Quiz quiz = ref.read(asyncQuizzesProvider.notifier).getQuizByName(quizName);
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  top: 60,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const GradientAnimationText(
                      text: Text(
                        'Edit, ',
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
              ),
              const SizedBox(
                height: 40,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Questions",
                    style: TextStyle(fontSize: 22),
                  ),
                  CreateNewQuestionButton(
                    quiz: quiz,
                  )
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              SizedBox(
                height: MediaQuery.sizeOf(context).height * 0.7,
                child: ListView(
                  children: [
                    for (final question in quiz.questions)
                      QuestionTile(
                        question: question,
                        quizName: quiz.name,
                      )
                  ],
                ),
              )
            ],
          ),
        ),
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(bottom: 10.0),
          child: SubmitQuizButton(
            quizName: quiz.name,
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      ),
    );
  }
}