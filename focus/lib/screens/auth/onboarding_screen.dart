import 'package:flutter/material.dart';

import '/app/constants.dart';
import '/widgets/custom_buttom.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  void _goToLogin(BuildContext context) {
    Navigator.of(context).pushReplacementNamed(AppRoutes.login);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: defaultScreenPadding,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Welcome to FocusNFlow',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
            ),
            const SizedBox(height: 12),
            Text(
              'Study smarter with shared timers, group chats, and live room availability.',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 32),
            CustomButton(
              label: 'Get Started',
              onPressed: () => _goToLogin(context),
            ),
          ],
        ),
      ),
    );
  }
}
