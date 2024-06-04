import 'package:flutter/material.dart';
import 'package:myapp/authentication/controllers.onboarding/onboarding_controller.dart';

class OnBoardingSkip extends StatelessWidget {
  const OnBoardingSkip({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: kToolbarHeight,
      right: 16,
      child: TextButton(
        onPressed: () => OnBoardingController.instance.skipPage(),
        child: const Text('Skip'),
      ),
    );
  }
}
