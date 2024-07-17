import 'package:google_maps_flutter/google_maps_flutter.dart' as maps;
import 'package:myapp/Geofencing/custom_kdtree.dart';
import 'package:myapp/Geofencing/dynamic_geofencing.dart'; // Import your dynamic geofencing class file
import 'package:myapp/Geofencing/pharmacy.dart'; // Import your pharmacy class file
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Find nearest pharmacy with required drug', () {
    List<MPharmacy> pharmacies = [
      // Define your pharmacies here
      MPharmacy(
      name: 'Adom Pharmacy',
      location: maps.LatLng(5.586068508745964, -0.27841203851563756),
      drugs: [
        Drug(name: 'Paracetamol', quantity: 30),
        Drug(name: 'Aspirin', quantity: 5),
      ],
    ),
    MPharmacy(
      name: 'Prof. T pharmacy',
      location: maps.LatLng(5.730660624508987, -0.24190729114313758),
      drugs: [
        Drug(name: 'Paracetamol', quantity: 0),
        Drug(name: 'Amoxicillin', quantity: 0),
      ],
    ),
    MPharmacy(
      name: 'Tuffuor Pharmacy',
      location: maps.LatLng(5.762524385840229, -0.22366175248871314),
      drugs: [
        Drug(name: 'Aspirin', quantity: 3),
        Drug(name: 'Ibuprofen', quantity: 15),
      ],
    ),
    MPharmacy(
      name: 'Live Pharmacy',
      location: maps.LatLng(5.756285324668748, -0.1827800592144421),
      drugs: [
        Drug(name: 'Ibuprofen', quantity: 6),
        Drug(name: 'Amoxicillin', quantity: 10),
      ],
    ),
    MPharmacy(
      name: 'Bright Pharmacy',
      location: maps.LatLng(5.688488456294299, -0.20750979318988166),
      drugs: [
        Drug(name: 'Paracetamol', quantity: 0),
        Drug(name: 'Aspirin', quantity: 4),
      ],
    ),
    ];
  // User's current location
  maps.LatLng userLocation = maps.LatLng(5.7583804, -0.21917);

  // Required drug
  String requiredDrug = 'Amoxicillin';



  // Create an instance of DynamicGeofencing
  DynamicGeofencing dynamicGeofencing = DynamicGeofencing();

  // Find the nearest pharmacy with the required drug
  MPharmacy? nearestPharmacy = dynamicGeofencing.findNearestPharmacyWithDrug(userLocation as maps.LatLng, requiredDrug, pharmacies);

        // Calculate distance in kilometers
    double distanceInMeters = dynamicGeofencing.kdTree.calculateDistance(
      userLocation.latitude,
      userLocation.longitude,
      nearestPharmacy!.location.latitude,
      nearestPharmacy.location.longitude,
    );

    double distanceInKilometers = distanceInMeters / 1000.0;
  // Assertions to test your algorithm's correctness
    expect(nearestPharmacy, isNotNull);
    expect(nearestPharmacy!.hasDrug(requiredDrug), true);
    // expect(distanceInKilometers, closeTo(expectedDistance, tolerance));




    // Print details of the nearest pharmacy if found
    print('Nearest Pharmacy: ${nearestPharmacy.name}');
    print('Location: ${nearestPharmacy.location.latitude}, ${nearestPharmacy.location.longitude}');
    print('Distance: ${distanceInKilometers.toStringAsFixed(2)} km');
    print('Drugs available: ${nearestPharmacy.drugs.map((drug) => drug.name).toList()}');
    });
}
