import 'package:google_maps_flutter/google_maps_flutter.dart';

class Drug {
  String name;
  int quantity;

  Drug({required this.name, required this.quantity});
}

class MPharmacy {
  String name;
  LatLng location;
  List<Drug> drugs;

  MPharmacy({required this.name, required this.location, required this.drugs});

  bool hasDrug(String drugName) {
    return drugs.any((drug) => drug.name == drugName && drug.quantity > 0);
  }
}
