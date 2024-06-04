import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ResetPassword extends StatelessWidget {
  const ResetPassword({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            onPressed: () => Get.back(),
            icon: const Icon(CupertinoIcons.clear),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Column(
            children: [
              Image(
                image: const AssetImage("assets/images/delivered-email.png"),
                width: MediaQuery.of(Get.context!).size.width * 0.6,
              ),
              const SizedBox(
                height: 32,
              ),

              // Title & Subtitle
              Text(
                "Password Reset Email Sent",
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
                "Your account security is our priority! We've sent you a secure link to safely change your password and keep your account protected.",
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
                height: 50,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.blue, // Text color
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8), // Border radius
                    ),
                  ),
                  child: const Text(
                    "Done",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              SizedBox(
                width: double.infinity,
                child: TextButton(
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
