import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:myapp/authentication/controllers/signup/signup_controller.dart';
import 'package:myapp/validators/FormValidation.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SignUpController());
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Padding(
          //Default space 24
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title
              Text(
                "Let's create your account",
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(
                height: 32,
              ),

              // Form
              Form(
                key: controller.signupFormKey,
                child: Column(
                  children: [
                    Row(
                      children: [
                        // Without wrapping the TextFormField with a widget (i.e., Expanded, we get an error)
                        // saying that An InputDecorator created by TextField cannot have an unbounded width.
                        Expanded(
                          child: TextFormField(
                            controller: controller.firstname,
                            validator: (value) =>
                                FormValidation.validateEmptyText(
                                    'First name', value),
                            expands: false,
                            decoration: InputDecoration(
                              labelText: "Firstname",
                              prefixIcon: const Icon(Iconsax.user),
                              border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.circular(8), // Border radius
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(
                                    8), // Border radius for enabled state
                                borderSide: const BorderSide(
                                  color: Colors
                                      .grey, // Border color for enabled state
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(
                                    8), // Border radius for focused state
                                borderSide: const BorderSide(
                                  color: Colors
                                      .blue, // Border color for focused state
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 16,
                        ),
                        Expanded(
                          child: TextFormField(
                            controller: controller.lastname,
                            validator: (value) =>
                                FormValidation.validateEmptyText(
                                    'Last name', value),
                            expands: false,
                            decoration: InputDecoration(
                              labelText: "Lastname",
                              prefixIcon: const Icon(Iconsax.user),
                              border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.circular(8), // Border radius
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(
                                    8), // Border radius for enabled state
                                borderSide: const BorderSide(
                                  color: Colors
                                      .grey, // Border color for enabled state
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(
                                    8), // Border radius for focused state
                                borderSide: const BorderSide(
                                  color: Colors
                                      .blue, // Border color for focused state
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 16,
                    ),

                    // Username
                    TextFormField(
                      controller: controller.username,
                      validator: (value) =>
                          FormValidation.validateEmptyText('Username', value),
                      expands: false,
                      decoration: InputDecoration(
                        labelText: "Username",
                        prefixIcon: const Icon(Iconsax.user_edit),
                        border: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(8), // Border radius
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                              8), // Border radius for enabled state
                          borderSide: const BorderSide(
                            color:
                                Colors.grey, // Border color for enabled state
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                              8), // Border radius for focused state
                          borderSide: const BorderSide(
                            color:
                                Colors.blue, // Border color for focused state
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    // Email
                    TextFormField(
                      controller: controller.email,
                      validator: (value) => FormValidation.validateEmail(value),
                      expands: false,
                      decoration: InputDecoration(
                        labelText: "Email",
                        prefixIcon: const Icon(Iconsax.direct),
                        border: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(8), // Border radius
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                              8), // Border radius for enabled state
                          borderSide: const BorderSide(
                            color:
                                Colors.grey, // Border color for enabled state
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                              8), // Border radius for focused state
                          borderSide: const BorderSide(
                            color:
                                Colors.blue, // Border color for focused state
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 16,
                    ),

                    //Phone Number
                    TextFormField(
                      controller: controller.phoneNumber,
                      validator: (value) =>
                          FormValidation.validatecontact(value),
                      expands: false,
                      decoration: InputDecoration(
                        labelText: "Contact",
                        prefixIcon: const Icon(Iconsax.call),
                        border: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(8), // Border radius
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                              8), // Border radius for enabled state
                          borderSide: const BorderSide(
                            color:
                                Colors.grey, // Border color for enabled state
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                              8), // Border radius for focused state
                          borderSide: const BorderSide(
                            color:
                                Colors.blue, // Border color for focused state
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 16,
                    ),

                    // Password

                    // Observe values using .obx
                    Obx(
                      () => TextFormField(
                        // Toggling password hidden/shown
                        obscureText: controller.hidePassword.value,
                        controller: controller.password,
                        validator: (value) =>
                            FormValidation.validatePassword(value),
                        expands: false,
                        decoration: InputDecoration(
                          labelText: "Password",
                          prefixIcon: const Icon(Iconsax.password_check),
                          suffixIcon: IconButton(
                            onPressed: () => controller.hidePassword.value =
                                !controller.hidePassword.value,
                            icon: Icon(
                              controller.hidePassword.value
                                  ? Iconsax.eye_slash
                                  : Iconsax.eye,
                            ),
                          ),
                          border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(8), // Border radius
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(
                                8), // Border radius for enabled state
                            borderSide: const BorderSide(
                              color:
                                  Colors.grey, // Border color for enabled state
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(
                                8), // Border radius for focused state
                            borderSide: const BorderSide(
                              color:
                                  Colors.blue, // Border color for focused state
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 32,
                    ),

                    // Terms and Conditions Check
                    Row(
                      children: [
                        SizedBox(
                          width: 24,
                          height: 24,
                          child: Obx(() => Checkbox(
                              value: controller.privacypolicy.value,
                              onChanged: (value) => controller.privacypolicy
                                  .value = !controller.privacypolicy.value)),
                        ),
                        const SizedBox(
                          width: 12,
                        ),
                        Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                  text: "I agree to ",
                                  style: Theme.of(context).textTheme.bodySmall),
                              TextSpan(
                                text: "Privacy Policy ",
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .apply(
                                      decoration: TextDecoration.underline,
                                      color: Colors.blue,
                                    ),
                              ),
                              TextSpan(
                                  text: "and ",
                                  style: Theme.of(context).textTheme.bodySmall),
                              TextSpan(
                                text: "Terms of use ",
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .apply(
                                      decoration: TextDecoration.underline,
                                      color: Colors.blue,
                                    ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 32,
                    ),
                    // Sign Up Button
                    SizedBox(
                      width: double.infinity,
                      height: 45,
                      child: ElevatedButton(
                        onPressed: () => controller.signUp(),
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.blue, // Text color
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(8), // Border radius
                          ),
                        ),
                        child: const Text(
                          "Create Account",
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
              const SizedBox(
                height: 16,
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
                    "or sign up with".capitalize!,
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
