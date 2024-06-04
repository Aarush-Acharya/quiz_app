import 'package:flutter/material.dart';
import 'package:flutter_gradient_animation_text/flutter_gradient_animation_text.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quiz_app/notifiers_providers/auth_provider.dart';
import 'package:quiz_app/theme/colors.dart';
import 'package:quiz_app/utils/routes.dart';
import 'package:sign_button/sign_button.dart';

class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 250,
            ),
            const GradientAnimationText(
              text: Text(
                'Welcome,',
                style: TextStyle(
                  fontSize: 50,
                ),
              ),
              colors: [AppColors.blue, AppColors.red],
              duration: Duration(seconds: 2),
            ),
            const SizedBox(
              height: 5,
            ),
            const Text(
              "to Quiz App",
              style: TextStyle(fontSize: 45),
            ),
            const SizedBox(
              height: 100,
            ),
            SignInButton(
                buttonSize: ButtonSize.medium,
                buttonType: ButtonType.google,
                onPressed: () async {
                  credential = await auth0
                      .webAuthentication(scheme: 'demo')
                      .login(parameters: {'connection': 'google-oauth2'});
                  Navigator.pushNamed(context, appRoutes.home);
                })
          ],
        ),
      ),
    );
  }
}
