import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';


// Obtaining the address of pharmacies from the marker on Google Maps
Future<String> getAddressFromLatLng(LatLng latLng) async {
  try {
    List<Placemark> placemarks =
        await placemarkFromCoordinates(latLng.latitude, latLng.longitude);
    Placemark place = placemarks[0];
    return "${place.street}, ${place.locality}, ${place.country}";
  } catch (e) {
    print(e);
    return "No address available";
  }
}
