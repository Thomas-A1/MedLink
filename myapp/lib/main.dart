import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
// import 'package:myapp/authentication/screens/onboarding/onboarding.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:myapp/bindings/general_bindings.dart';
import 'package:myapp/data/repositories/authentication_repository.dart';
import 'package:myapp/data/repositories/pharmacies/pharmacy_repository.dart';
import 'package:myapp/firebase_options.dart';
import 'package:myapp/Landing/Location_provider.dart';
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
      .then((FirebaseApp value) {
    Get.put(AuthenticationRepository());
    Get.put(PharmacyRepository());
    Get.put(LocationController()); 
  });
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





//Main Method to update the pharmacy with drugs data
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:get_storage/get_storage.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter/services.dart' show rootBundle;
// import 'package:myapp/bindings/general_bindings.dart';
// import 'package:myapp/data/repositories/authentication_repository.dart';
// import 'package:myapp/data/repositories/pharmacies/pharmacy_repository.dart';
// import 'package:myapp/firebase_options.dart';
// import 'package:flutter_native_splash/flutter_native_splash.dart';
// import 'package:csv/csv.dart';

// Future<void> main() async {
//   // Ensure that plugin services are initialized so they can be used before runApp()
//   final WidgetsBinding widgetsBinding =
//       WidgetsFlutterBinding.ensureInitialized();

//   // Preserve splash screen until initialization is complete
//   FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

//   // Initialize Firebase
//   await Firebase.initializeApp(
//     options: DefaultFirebaseOptions.currentPlatform,
//   );

//   // Adding Local Storage
//   await GetStorage.init();

//   // Put your repositories
//   Get.put(AuthenticationRepository());
//   Get.put(PharmacyRepository());

//   // Parse and distribute drugs (moved inside main to ensure Firebase is initialized first)
//   await loadAndDistributeDrugs();

//   runApp(const MyApp());
// }

// Future<void> loadAndDistributeDrugs() async {
//   try {
//     // Path to file
//     String filePath = 'assets/drugbank.csv';

//     // Parsing the CSV file
//     List<Map<String, dynamic>> drugs = await parseCsv(filePath);

//     // Distribute drugs
//     int pharmacyCount =6;
//     List<Map<String, dynamic>> pharmacies =
//         distributeDrugs(drugs, pharmacyCount);

//     // Update Firestore
//     await Get.find<PharmacyRepository>().updatePharmacy(pharmacies);

//     print('Successfully updated pharmacies with drugs');
//   } catch (e) {
//     print('Error loading and distributing drugs: $e');
//   }
// }

// // Loading data from CSV file
// Future<List<Map<String, dynamic>>> parseCsv(String filePath) async {
//   try {
//     final csvData = await rootBundle.loadString(filePath);
//     List<List<dynamic>> rowsAsListOfValues =
//         const CsvToListConverter().convert(csvData);

//     List<Map<String, dynamic>> drugs = [];

//     for (var row in rowsAsListOfValues.skip(1)) {
//       // Skip header row
//       drugs.add({
//         'DrugBank ID': row[0]?.toString() ?? '',
//         'Common name': row[2]?.toString() ?? '',
//         'Synonyms': row[5]?.toString() ?? '',
//       });
//     }

//     return drugs;
//   } catch (e) {
//     print('Error parsing CSV: $e');
//     return [];
//   }
// }

// List<Map<String, dynamic>> distributeDrugs(
//     List<Map<String, dynamic>> drugs, int pharmacyCount) {
//   List<Map<String, dynamic>> pharmacies = List.generate(pharmacyCount, (index) {
//     return {
//       'id': 'pharmacy_${index + 1}',
//       'drugs': [],
//     };
//   });

//   int drugIndex = 0;

//   for (int i = 0; i < pharmacyCount; i++) {
//     for (int j = 0; j < 35 && drugIndex < drugs.length; j++, drugIndex++) {
//       pharmacies[i]['drugs'].add(drugs[drugIndex]);
//     }
//   }

//   return pharmacies;
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return GetMaterialApp(
//       debugShowCheckedModeBanner: false,
//       // Showing a Loader or Circular Progress while authentication decides to show relevant pages
//       initialBinding: GeneralBindings(),
//       home: const Scaffold(
//         backgroundColor: Colors.blue,
//         body: Center(
//           child: CircularProgressIndicator(
//             color: Colors.white,
//           ),
//         ),
//       ),
//       // home: onBoardingScreen(),
//     );
//   }
// }

