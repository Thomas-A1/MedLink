import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:myapp/authentication/controllers.onboarding/onboarding_controller.dart';

class OnBoardingNextButton extends StatelessWidget {
  const OnBoardingNextButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      // Default
      right: 24,
      bottom: kBottomNavigationBarHeight,
      child: ElevatedButton(
        onPressed: () => OnBoardingController.instance.nextPage(),
        style: ElevatedButton.styleFrom(
          shape: const CircleBorder(),
          backgroundColor: const Color.fromARGB(255, 39, 38, 38),
          minimumSize: const Size(60, 60),
        ),
        child: const Icon(
          Iconsax.arrow_right_3,
          color: Colors.white, // Set the arrow color to white
        ),
      ),
    );
  }
}
