import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
// import 'package:myapp/authentication/screens/onboarding/onboarding.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:myapp/bindings/general_bindings.dart';
import 'package:myapp/data/repositories/authentication_repository.dart';
import 'package:myapp/firebase_options.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

Future<void> main() async {
  // Adding Widgets binding
  final WidgetsBinding widgetsBinding =
      WidgetsFlutterBinding.ensureInitialized();

  // Adding Local Storage
  await GetStorage.init();

  // Awaiting Splashscreen until other items are loaded
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  // Initializing Firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform)
      .then((FirebaseApp value) => Get.put(AuthenticationRepository()));

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Changed MaterialApp to GetMaterialApp
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      // Showing a Loader or Circular Progress while authentication decides to show relevant pages
      initialBinding: GeneralBindings(),
      home: const Scaffold(
        backgroundColor: Colors.blue,
        body: Center(
          child: CircularProgressIndicator(
            color: Colors.white,
          ),
        ),
      ),
      // home: onBoardingScreen(),
    );
  }
}
