import 'package:flutter/material.dart';

class Login extends StatelessWidget {
  const Login({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[900],
      body: Column(
        children: [
          const Text(
            "Hello, welcome back!",
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(
            height: 16,
          ),
          const Text(
            "Login to continue",
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          TextField(
            decoration: InputDecoration(
              hintText: 'Username',
              border: const OutlineInputBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(12),
                ),
              ),
              filled: true,
              fillColor: Colors.white.withOpacity(0.5),
            ),
          ),
          const SizedBox(
            height: 16,
          ),
          TextField(
            decoration: InputDecoration(
              hintText: 'Password',
              border: const OutlineInputBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(12),
                ),
              ),
              filled: true,
              fillColor: Colors.white.withOpacity(0.5),
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () {
                print("clicked");
              },
              style: TextButton.styleFrom(
                foregroundColor: Colors.white,
              ),
              child: const Text('Forgot Password?'),
            ),
          ),
          SizedBox(
            width: 250,
            child: ElevatedButton(
              onPressed: () {
                print("Login is clicked!");
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 135, 220, 143),
                foregroundColor: Colors.black,
              ),
              child: const Text(
                "Log In",
              ),
            ),
          ),
          const SizedBox(
            height: 62,
          ),
          const Text(
            "or sign in with",
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          const SizedBox(
            height: 16,
          ),
          ElevatedButton(
            onPressed: () {
              print("Google is clicked!");
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(50),
                ),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/google.png',
                  width: 24,
                  height: 24,
                ),
                const SizedBox(
                  width: 10,
                ),
                const Text('Login with Google'),
              ],
            ),
          ),
          Row(
            children: [
              const Text(
                "Don't have an account? ",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              TextButton(
                onPressed: () {},
                style: TextButton.styleFrom(
                  foregroundColor: Colors.amber,
                ),
                child: const Text(
                  "Sign Up",
                  style: TextStyle(
                    decoration: TextDecoration.underline,
                  ),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
