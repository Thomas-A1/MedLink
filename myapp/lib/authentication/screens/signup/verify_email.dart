import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myapp/authentication/screens/login/login.dart';
import 'package:myapp/authentication/screens/signup/success_screen.dart';

class VerifyEmailScreen extends StatelessWidget {
  const VerifyEmailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // removing back button
        automaticallyImplyLeading: false,

        actions: [
          IconButton(
              onPressed: () => Get.offAll(() => const LoginScreen()),
              icon: const Icon(CupertinoIcons.clear))
        ],
      ),
      body: SingleChildScrollView(
        //MediaQuery.of(Get.Context!).size.width
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Column(
            children: [
              // Image
              Image(
                image: AssetImage("assets/images/verify_email.gif"),
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
                'support@medlink.com',
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
                  onPressed: () => Get.to(
                    () => SuccessScreen(
                      image: "assets/images/welcome.png",
                      title: "Your account successfully created!",
                      subTitle:
                          "Welcome to MedLink: Unleash the joy of a hassle-free search for the pharmacies stocked with the medications you need!",
                      onPressed: () => Get.to(() => const LoginScreen()),
                    ),
                  ),
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
                  onPressed: () {},
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
