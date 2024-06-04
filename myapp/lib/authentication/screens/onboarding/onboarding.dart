import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myapp/authentication/controllers.onboarding/onboarding_controller.dart';
import 'package:myapp/authentication/screens/onboarding/widgets/onboarding_dot_navigation.dart';
import 'package:myapp/authentication/screens/onboarding/widgets/onboarding_next_button.dart';
import 'package:myapp/authentication/screens/onboarding/widgets/onboarding_page.dart';
import 'package:myapp/authentication/screens/onboarding/widgets/onboarding_skip.dart';


class onBoardingScreen extends StatelessWidget {
  const onBoardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Create new instance of OnBoarding Controller
    final controller = Get.put(OnBoardingController());
    return Scaffold(
      body: Stack(children: [
        /// Horizontal Scrollable Button
        PageView(
          controller: controller.pageController,
          onPageChanged: controller.updatePageIndicator,
          children: const [
            OnBoardingPage(
              image: "assets/images/onboarding_images/FindPharmacy.jpg",
              title: "Find Closest Pharmacy To You",
              subTitle:
                  "Find all pharmacies closest to you - Best Medical Care Awaits!.",
            ),
            OnBoardingPage(
              image: "assets/images/onboarding_images/Drugs.jpg",
              title: "Obtain Right Medication From Pharmacy",
              subTitle:
                  "Get to know all the pharmacies near you that have the specific medication you need during emergency",
            ),
            OnBoardingPage(
              image: "assets/images/onboarding_images/SearchPharmacy.gif",
              title: "Interact with Pharmacy Heads",
              subTitle:
                  "Interact with the right health professionals in pharmacies near you!",
            ),
            OnBoardingPage(
              image: "assets/images/onboarding_images/SaveLives.jpg",
              title: "Avoid Delays to Save Lives",
              subTitle:
                  "Get the right medication on time to avoid delays leading to death in most emergency situations",
            ),
          ],
        ),

        /// Skip Button
        const OnBoardingSkip(),

        /// Dot Navigation SmoothPageIndicator
        const OnBoardingDotNavigation(),

        /// Circular Button
        const OnBoardingNextButton(),
      ]),
    );
  }
}


