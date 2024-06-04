import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quiz_app/notifiers_providers/auth_provider.dart';
import 'package:quiz_app/theme/themes.dart';
import 'package:quiz_app/utils/routes.dart';
import 'package:quiz_app/view/screens/create_question.dart';
import 'package:quiz_app/view/screens/edit_question.dart';
import 'package:quiz_app/view/screens/edit_quiz.dart';
import 'package:quiz_app/view/screens/give_quiz.dart';
import 'package:quiz_app/view/screens/home.dart';
import 'package:quiz_app/view/screens/login.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  auth0.credentialsManager.hasValidCredentials().then((value) async {
    if (value) {
      credential = await auth0.credentialsManager.credentials();
    }
    runApp(ProviderScope(
        child: MyApp(
      isLoggedIn: value,
    )));
  });
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;
  const MyApp({super.key, required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quiz App',
      darkTheme: Themes.getDarkTheme(),
      themeMode: ThemeMode.dark,
      initialRoute: isLoggedIn ? appRoutes.home : appRoutes.login,
      routes: {
        appRoutes.login: (context) => const LoginScreen(),
        appRoutes.home: (context) => const HomeScreen(),
        appRoutes.editQuiz: (context) => const EditQuizScreen(),
        appRoutes.createQuestion: (context) => const CreateQuestionScreen(),
        appRoutes.editQuestion: (context) => const EditQuestionScreen(),
        appRoutes.giveQuiz: (context) => const GiveQuiz(),
      },
    );
  }
}
