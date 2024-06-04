import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:myapp/authentication/screens/signup/signup.dart';
import 'package:myapp/password_configuration/forget_password.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(
            // AppBarHeight: 56
            top: 56,
            left: 24,
            bottom: 24,
            right: 24,
          ),
          child: Column(
            children: [
              // Spacer(),
              // Logo, Title & Sub-Title
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Image(
                    height: 120,
                    image: AssetImage("assets/images/med_final.png"),
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  Text(
                    "Welcome back,",
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Discover closest pharmacies with drugs at an Unmatched Convenience",
                    style: Theme.of(context).textTheme.bodyMedium,
                  )
                ],
              ),

              // Form
              Form(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 32),
                  child: Column(
                    children: [
                      // Email
                      TextFormField(
                        decoration: const InputDecoration(
                          prefixIcon: Icon(Iconsax.direct_right),
                          labelText: "Email",
                        ),
                      ),
                      // SpaceBtwInputFields = 16
                      const SizedBox(
                        height: 16,
                      ),

                      // Password
                      TextFormField(
                        decoration: const InputDecoration(
                          prefixIcon: Icon(Iconsax.password_check),
                          labelText: "Password",
                          suffixIcon: Icon(Iconsax.eye_slash),
                        ),
                      ),
                      const SizedBox(
                        height: 8,
                      ),

                      // Remember Me & Forgot Password
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Remember Me
                          Row(
                            children: [
                              Checkbox(value: true, onChanged: (value) {}),
                              const Text("Remember Me")
                            ],
                          ),

                          // Forgot Password
                          TextButton(
                            onPressed: () =>
                                Get.to(() => const ForgetPassword()),
                            child: const Text("Forgot Password?"),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 32,
                      ),

                      // Sign In Button
                      SizedBox(
                        width: double.infinity,
                        height: 45,
                        child: ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: Colors.blue, // Text color
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(8), // Border radius
                            ),
                          ),
                          child: const Text(
                            "Sign In",
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

                      // Create Account Button
                      SizedBox(
                        width: double.infinity,
                        height: 45,
                        child: OutlinedButton(
                          onPressed: () => Get.to(
                            () => const SignupScreen(),
                          ),
                          style: ElevatedButton.styleFrom(
                            foregroundColor:
                                const Color.fromARGB(255, 10, 0, 0),
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(8), // Border radius
                            ),
                          ),
                          child: const Text(
                            "Create Account",
                            style: TextStyle(
                              color: Color.fromARGB(255, 10, 10, 10),
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Divider
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Flexible(
                    child: Divider(
                      color: Color.fromARGB(255, 46, 46, 46),
                      thickness: 0.5,
                      indent: 60,
                      endIndent: 5,
                    ),
                  ),
                  Text(
                    "or sign in with".capitalize!,
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                          color: Colors.grey,
                        ),
                  ),
                  const Flexible(
                    child: Divider(
                      color: Color.fromARGB(255, 46, 46, 46),
                      thickness: 0.5,
                      indent: 5,
                      endIndent: 60,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 16,
              ),
              // Footer
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: IconButton(
                      onPressed: () {},
                      icon: const Image(
                        width: 24,
                        height: 24,
                        image: AssetImage("assets/images/google.png"),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 16,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: IconButton(
                      onPressed: () {},
                      icon: const Image(
                        width: 24,
                        height: 24,
                        image: AssetImage("assets/images/facebook-logo.png"),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
