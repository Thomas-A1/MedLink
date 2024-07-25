import 'package:google_maps_flutter/google_maps_flutter.dart' as maps;
import 'package:myapp/Geofencing/dynamic_geofencing.dart'; // Import your dynamic geofencing class file
import 'package:myapp/Geofencing/pharmacy.dart'; // Import your pharmacy class file
import 'package:flutter_test/flutter_test.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

Future<Map<String, dynamic>> getDistanceUsingGoogleAPI(maps.LatLng origin, maps.LatLng destination, String apiKey) async {
  final url = Uri.parse(
      'https://maps.googleapis.com/maps/api/distancematrix/json?units=metric&origins=${origin.latitude},${origin.longitude}&destinations=${destination.latitude},${destination.longitude}&key=$apiKey');
  
  final response = await http.get(url);

  if (response.statusCode == 200) {
    final jsonResponse = json.decode(response.body);
    print('Google API Response: $jsonResponse'); // Debugging line

    if (jsonResponse['rows'].isNotEmpty &&
        jsonResponse['rows'][0]['elements'].isNotEmpty &&
        jsonResponse['rows'][0]['elements'][0]['status'] == 'OK') {
      final distance = jsonResponse['rows'][0]['elements'][0]['distance']['value']; // distance in meters
      final duration = jsonResponse['rows'][0]['elements'][0]['duration']['value']; // duration in seconds
      return {'distance': distance, 'duration': duration};
    } else {
      print('Google API Error: ${jsonResponse['rows'][0]['elements'][0]['status']}'); // Debugging line
      throw Exception('Google API Error: ${jsonResponse['rows'][0]['elements'][0]['status']}');
    }
  } else {
    print('HTTP Error: ${response.statusCode}'); // Debugging line
    throw Exception('Failed to load distance and duration');
  }
}

void main() {
  test('Find nearest pharmacy with required drug', () async {
    List<MPharmacy> pharmacies = [
      // Define your pharmacies here
      MPharmacy(
        name: 'Adom Pharmacy',
        location: maps.LatLng(5.586068508745964, -0.27841203851563756),
        drugs: [
          Drug(name: 'Paracetamol', quantity: 10),
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
    String requiredDrug = 'Paracetamol';

    // Create an instance of DynamicGeofencing
    DynamicGeofencing dynamicGeofencing = DynamicGeofencing();

    // List to hold pharmacies with zero quantity of the required drug
    List<MPharmacy> pharmaciesWithZeroQuantity = [];

    // Find the nearest pharmacy with the required drug
    MPharmacy? nearestPharmacy = dynamicGeofencing.findNearestPharmacyWithDrug(userLocation, requiredDrug, pharmacies, pharmaciesWithZeroQuantity);

    // Assertions to test your algorithm's correctness
    expect(nearestPharmacy, isNotNull);
    expect(nearestPharmacy!.hasDrug(requiredDrug), true);

    // Calculate distance and travel time using Google Maps API
    String apiKey = 'AIzaSyDHDXOGaF7jJC4nqvmGGLM0ltV7YqipHtk';
    Map<String, dynamic> distanceData = await getDistanceUsingGoogleAPI(userLocation, nearestPharmacy.location, apiKey);

    double distanceInKilometers = distanceData['distance'] / 1000.0;
    double travelTimeInMinutes = distanceData['duration'] / 60.0;

    // Print details including distance and travel time
    print('Nearest Pharmacy: ${nearestPharmacy.name}');
    print('Location: ${nearestPharmacy.location.latitude}, ${nearestPharmacy.location.longitude}');
    print('Drugs available: ${nearestPharmacy.drugs.map((drug) => drug.name).toList()}');
    print('Distance: ${distanceInKilometers.toStringAsFixed(2)} km');
    print('Travel Time: ${travelTimeInMinutes.toStringAsFixed(2)} minutes');

    // Print pharmacies with zero quantity of the required drug and their distances
    print('Pharmacies with $requiredDrug but zero quantity:');
    for (MPharmacy pharmacy in pharmaciesWithZeroQuantity) {
      double distance = dynamicGeofencing.kdTree.calculateDistance(userLocation.latitude, userLocation.longitude,
          pharmacy.location.latitude, pharmacy.location.longitude) / 1000.0; // Convert to kilometers
      print('Pharmacy: ${pharmacy.name}, Distance: ${distance.toStringAsFixed(2)} km');
    }
  });
}