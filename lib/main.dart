import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quiz_app/theme/themes.dart';
import 'package:quiz_app/utils/routes.dart';
import 'package:quiz_app/view/screens/create_question.dart';
import 'package:quiz_app/view/screens/edit_question.dart';
import 'package:quiz_app/view/screens/edit_quiz.dart';
import 'package:quiz_app/view/screens/give_quiz.dart';
import 'package:quiz_app/view/screens/home.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quiz App',
      darkTheme: Themes.getDarkTheme(),
      themeMode: ThemeMode.dark,
      initialRoute: appRoutes.home,
      routes: {
        appRoutes.home: (context) => const HomeScreen(),
        appRoutes.editQuiz: (context) => const EditQuizScreen(),
        appRoutes.createQuestion: (context) => const CreateQuestionScreen(),
        appRoutes.editQuestion: (context) => const EditQuestionScreen(),
        appRoutes.giveQuiz: (context) => const GiveQuiz(),
      },
    );
  }
}
