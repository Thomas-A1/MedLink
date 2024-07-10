import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:myapp/models/pharmacy_model.dart';

class PharmacyRepository extends GetxController {
  static PharmacyRepository get instance => Get.find();

  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Function to fetch all pharmacies
  Future<List<Pharmacy>> getPharmacies() async {
    try {
      QuerySnapshot snapshot = await _db.collection("pharmaciees").get();
      return snapshot.docs.map((doc) => Pharmacy.fromFirestore(doc)).toList();
    } catch (e) {
      print('Error fetching pharmacies: $e');
      return [];
    }
  }

  // Update pharmacy data with drugs
  Future<void> updatePharmacy(List<Map<String, dynamic>> pharmacies) async {
    for (var pharmacy in pharmacies) {
      var pharmacyId = pharmacy['id'];

      // Reference to the pharmacy document
      var docRef = _db.collection('pharmaciees').doc(pharmacyId);

      try {
        // Check if the pharmacy document exists
        var doc = await docRef.get();

        if (doc.exists) {
          // If the document exists, update it with the new drugs list
          await docRef.update({
            'drugs': FieldValue.arrayUnion(pharmacy['drugs']),
          });
        } else {
          // If the document does not exist, create it
          await docRef.set({
            'drugs': pharmacy['drugs'],
          });
        }
      } catch (e) {
        print('Error updating pharmacy: $e');
      }
    }
  }
}
