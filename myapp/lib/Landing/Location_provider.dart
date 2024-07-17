import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationController extends GetxController {
  Rx<LatLng?> currentPosition = Rx<LatLng?>(null);

  void updatePosition(LatLng position) {
    currentPosition.value = position;
    print(currentPosition.value);
  }
}
