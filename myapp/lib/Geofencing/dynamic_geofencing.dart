import 'package:myapp/Geofencing/custom_kdtree.dart';
import 'package:myapp/Geofencing/pharmacy.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';


class DynamicGeofencing {
  late KDTree kdTree;

  DynamicGeofencing() {
    kdTree = KDTree();
  }


  MPharmacy? findNearestPharmacyWithDrug(LatLng userLocation, String requiredDrug, List<MPharmacy> allPharmacies) {
    double initialRadius = 50.0; // Initial radius in meters
    double radius = initialRadius;
    List<MPharmacy> pharmaciesWithinRadius = [];

    while (pharmaciesWithinRadius.isEmpty) {
      pharmaciesWithinRadius = kdTree.searchWithinRadius(userLocation, radius, requiredDrug);
      radius += 50.0; // Increase radius by 1000 meters (adjust as needed)

      // Dynamically add pharmacies to KDTree within the new radius
      for (MPharmacy pharmacy in allPharmacies) {
        double distance = kdTree.calculateDistance(userLocation.latitude, userLocation.longitude,
                                                    pharmacy.location.latitude, pharmacy.location.longitude);
        if (distance <= radius) {
          kdTree.insert(pharmacy);
        }
      }
    }

    // Process and return the nearest pharmacy with the required drug
    MPharmacy? nearestPharmacy;
    double shortestDistance = double.infinity;

    for (MPharmacy pharmacy in pharmaciesWithinRadius) {
      double distance = kdTree.calculateDistance(userLocation.latitude, userLocation.longitude,
                                                  pharmacy.location.latitude, pharmacy.location.longitude);
      if (pharmacy.hasDrug(requiredDrug) && distance < shortestDistance) {
        nearestPharmacy = pharmacy;
        shortestDistance = distance;
      }
    }

    return nearestPharmacy;
  }
}
