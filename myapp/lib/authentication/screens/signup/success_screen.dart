import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SuccessScreen extends StatelessWidget {
  const SuccessScreen(
      {super.key,
      required this.image,
      required this.title,
      required this.subTitle,
      required this.onPressed});

  final String image, title, subTitle;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(
            top: 56 * 2,
            left: 24 * 2,
            bottom: 24 * 2,
            right: 24 * 2,
          ),
          child: Column(
            children: [
              // Image
              Image(
                image: AssetImage(image),
                width: MediaQuery.of(Get.context!).size.width * 0.6,
              ),
              const SizedBox(
                height: 32,
              ),

              // Title & Subtitle
              Text(
                title,
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
                subTitle,
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
                  onPressed: onPressed,
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
            ],
          ),
        ),
      ),
    );
  }
}
