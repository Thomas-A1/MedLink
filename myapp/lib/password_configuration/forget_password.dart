import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:myapp/password_configuration/reset_password.dart';

class ForgetPassword extends StatelessWidget {
  const ForgetPassword({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Headings
            Text(
              "Forget Password",
              style: Theme.of(context)
                  .textTheme
                  .headlineMedium
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 16,
            ),
            Text(
              "Don't worry sometimes people can forget too. Enter your email and we will send you a password reset link",
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: Color.fromARGB(255, 147, 147, 147),
                    fontSize: 14,
                  ),
            ),
            const SizedBox(
              height: 64,
            ),

            // Text Field
            TextFormField(
              expands: false,
              decoration: InputDecoration(
                labelText: "Email",
                prefixIcon: const Icon(Iconsax.direct_right),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8), // Border radius
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(
                      8), // Border radius for enabled state
                  borderSide: const BorderSide(
                    color: Colors.grey, // Border color for enabled state
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(
                      8), // Border radius for focused state
                  borderSide: const BorderSide(
                    color: Colors.blue, // Border color for focused state
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 32,
            ),

            // Submit Buttons
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () => Get.off(() => const ResetPassword()),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor:
                      Color.fromARGB(255, 13, 141, 246), // Text color
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8), // Border radius
                  ),
                ),
                child: const Text(
                  "Submit",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
