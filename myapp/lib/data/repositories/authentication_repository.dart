import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:myapp/authentication/screens/login/login.dart';
import 'package:myapp/authentication/screens/onboarding/onboarding.dart';

class AuthenticationRepository extends GetxController {
  static AuthenticationRepository get instance => Get.find();

  // Variables
  final deviceStorage = GetStorage();
  final _auth = FirebaseAuth.instance;

  // Calling this from main.dart on app launch
  @override
  void onReady() {
    FlutterNativeSplash.remove();
    screenRedirect();
  }

  // Functions to show relevant Screen based on authentication
  screenRedirect() async {
    // Local Storage
    deviceStorage.writeIfNull('isFirstTime', true);
    // If it is the first time for the user, we visit the onboardingscreen else the LoginScreen
    deviceStorage.read('isFirstTime') != true
        ? Get.offAll(() => const LoginScreen())
        : Get.offAll(const onBoardingScreen());
  }

  /*---- Email & Password Sign-in */

  // EmailAuthentication - SignIn

  // EmailAuthentication - Register
  Future<UserCredential> registerWithEmailAndPassword(String email, String password) async {
    return await _auth.createUserWithEmailAndPassword(email: email, password: password);
  }

  // ReAuthenticate - Reauthenticate user

  // EmailVerification

  // EmailAuthentication - Forgot Password

  /*--- Federated Identity & Social Sign In */

  // GoogleAuthentication

  // FacebookAuthentication

  /*--- End of Federated Identity & Social Sign In */

  //LogoutUser - Valid for any authentication

  // Delete User - Remove User Auth and Firestore account
}
