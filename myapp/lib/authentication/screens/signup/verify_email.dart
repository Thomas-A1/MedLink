import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myapp/authentication/controllers/signup/verify_email_controller.dart';
// import 'package:myapp/authentication/screens/login/login.dart';
// import 'package:myapp/authentication/screens/signup/success_screen.dart';
import 'package:myapp/data/repositories/authentication_repository.dart';

class VerifyEmailScreen extends StatelessWidget {
  const VerifyEmailScreen({super.key, this.email});

  final String? email;

  @override
  Widget build(BuildContext context) {
    // Create instance for the first time, unlike Get.find which creates the instance at all times
    final controller = Get.put(VerifyEmailController());
    return Scaffold(
      appBar: AppBar(
        // removing back button
        automaticallyImplyLeading: false,

        actions: [
          IconButton(
              onPressed: () => AuthenticationRepository.instance.logout(),
              icon: const Icon(CupertinoIcons.clear))
        ],
      ),
      body: SingleChildScrollView(
        //MediaQuery.of(Get.Context!).size.width
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              // Image
              Image(
                image: const AssetImage("assets/images/verify_email.gif"),
                width: MediaQuery.of(Get.context!).size.width * 0.6,
              ),
              const SizedBox(
                height: 32,
              ),

              // Title & Subtitle
              Text(
                "Verify your Email Address!",
                style: Theme.of(context)
                    .textTheme
                    .headlineMedium
                    ?.copyWith(fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 16,
              ),
              Text(
                email ?? '',
                style: Theme.of(context).textTheme.labelLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 16,
              ),
              Text(
                "Congratulations! Your Account Awaits: Verify your Email to start your journey with MedLink!",
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: Colors.grey,
                      fontSize: 15,
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 34,
              ),

              // Buttons
              SizedBox(
                width: double.infinity,
                height: 45,
                child: ElevatedButton(
                  // Success screen
                  onPressed: () => controller.checkEmailVerificationStatus(),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.blue, // Text color
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8), // Border radius
                    ),
                  ),
                  child: const Text(
                    "Continue",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => controller.sendEmailVerification(),
                  child: const Text(
                    "Resend Email",
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
