import 'package:flutter/material.dart';
import 'package:flutter_gradient_animation_text/flutter_gradient_animation_text.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quiz_app/notifiers_providers/auth_provider.dart';
import 'package:quiz_app/notifiers_providers/quiz_notifier.dart';
import 'package:quiz_app/notifiers_providers/section_state_provider.dart';
import 'package:quiz_app/theme/colors.dart';
import 'package:quiz_app/utils/routes.dart';
import 'package:quiz_app/view/widgets/create_quiz_button.dart';
import 'package:quiz_app/view/widgets/quiz_widget.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncQuizzes = ref.watch(asyncQuizzesProvider);
    final isLive = ref.watch(sectionStateProvider);

    return RefreshIndicator(
      onRefresh: () => ref.refresh(asyncQuizzesProvider.future),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 60),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const GradientAnimationText(
                      text: Text(
                        'Quizzes',
                        style: TextStyle(
                          fontSize: 50,
                        ),
                      ),
                      colors: [AppColors.blue, AppColors.red],
                      duration: Duration(seconds: 2),
                    ),
                    GestureDetector(
                      onTap: () {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title:
                                    const Text("Do you wish to do with your account"),
                                actions: [
                                  TextButton(
                                      onPressed: () async {
                                        await auth0
                                            .webAuthentication(scheme: 'demo')
                                            .logout();
                                        Navigator.pushNamed(
                                            context, appRoutes.login);
                                      },
                                      child: const Text("Logout")),
                                  TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: const Text("Nothing"))
                                ],
                              );
                            });
                      },
                      child: CircleAvatar(
                        radius: 20,
                        backgroundImage: NetworkImage(
                            credential!.user.pictureUrl.toString()),
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton(
                      style: TextButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                              side: BorderSide(
                                  color: isLive
                                      ? const Color.fromARGB(24, 255, 255, 255)
                                      : const Color.fromARGB(
                                          59, 255, 255, 255)))),
                      onPressed: () {
                        ref
                            .read(sectionStateProvider.notifier)
                            .update((state) => true);
                      },
                      child: Text(
                        "Live",
                        style: isLive
                            ? null
                            : const TextStyle(color: AppColors.neutralGrey),
                      )),
                  TextButton(
                      style: TextButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                              side: BorderSide(
                                  color: isLive
                                      ? const Color.fromARGB(59, 255, 255, 255)
                                      : const Color.fromARGB(
                                          24, 255, 255, 255)))),
                      onPressed: () {
                        ref
                            .read(sectionStateProvider.notifier)
                            .update((state) => false);
                      },
                      child: Text(
                        "Drafts",
                        style: isLive
                            ? const TextStyle(color: AppColors.neutralGrey)
                            : null,
                      )),
                ],
              ),
              const SizedBox(
                height: 2,
              ),
              SizedBox(
                  height: MediaQuery.sizeOf(context).height * 0.7,
                  child: switch (asyncQuizzes) {
                    AsyncData(:final value) => ListView(
                        children: [
                          for (final quiz in value)
                            isLive
                                ? quiz.isComplete
                                    ? QuizTile(quiz: quiz)
                                    : const SizedBox() // Empty widget for spacing (optional)
                                : !quiz.isComplete
                                    ? QuizTile(quiz: quiz)
                                    : const SizedBox(),
                        ],
                      ),
                    AsyncError(:final error) => Text('Error: $error'),
                    _ => const Center(child: CircularProgressIndicator()),
                  }),
            ],
          ),
        ),
        floatingActionButton: const Padding(
          padding: EdgeInsets.only(bottom: 10.0),
          child: CreateNewQuizButton(),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      ),
    );
  }
}
