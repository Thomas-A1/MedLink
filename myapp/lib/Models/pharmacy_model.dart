import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Pharmacy {
  final String id;
  final String name;
  final String phone;
  final String image;
  final Map<String, String> openingHours;
  final LatLng location;

  Pharmacy({
    required this.id,
    required this.name,
    required this.phone,
    required this.image,
    required this.openingHours,
    required this.location,
  });

  factory Pharmacy.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Pharmacy(
      id: doc.id,
      name: data['name'] ?? '',
      phone: data['phone'] ?? '',
      image: data['image'] ?? '',
      openingHours: Map<String, String>.from(data['Opening_hours'] ?? {}),
      location: _parseGeoPoint(data['location']),
    );
  }

  static LatLng _parseGeoPoint(GeoPoint geoPoint) {
    return LatLng(geoPoint.latitude, geoPoint.longitude);
  }
}
