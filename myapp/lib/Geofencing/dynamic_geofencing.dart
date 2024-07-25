import 'package:myapp/Geofencing/custom_kdtree.dart';
import 'package:myapp/Geofencing/pharmacy.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';


class DynamicGeofencing {
  late KDTree kdTree;

  DynamicGeofencing() {
    kdTree = KDTree();
  }


//   MPharmacy? findNearestPharmacyWithDrug(LatLng userLocation, String requiredDrug, List<MPharmacy> allPharmacies) {
//     double initialRadius = 50.0; // Initial radius in meters
//     double radius = initialRadius;
//     List<MPharmacy> pharmaciesWithinRadius = [];

//     while (pharmaciesWithinRadius.isEmpty) {
//       pharmaciesWithinRadius = kdTree.searchWithinRadius(userLocation, radius, requiredDrug);
//       radius += 50.0; // Increase radius by 1000 meters (adjust as needed)

//       // Dynamically add pharmacies to KDTree within the new radius
//       for (MPharmacy pharmacy in allPharmacies) {
//         double distance = kdTree.calculateDistance(userLocation.latitude, userLocation.longitude,
//                                                     pharmacy.location.latitude, pharmacy.location.longitude);
//         if (distance <= radius) {
//           kdTree.insert(pharmacy);
//         }
//       }
//     }

//     // Process and return the nearest pharmacy with the required drug
//     MPharmacy? nearestPharmacy;
//     double shortestDistance = double.infinity;

//     for (MPharmacy pharmacy in pharmaciesWithinRadius) {
//       double distance = kdTree.calculateDistance(userLocation.latitude, userLocation.longitude,
//                                                   pharmacy.location.latitude, pharmacy.location.longitude);
//       if (pharmacy.hasDrug(requiredDrug) && distance < shortestDistance) {
//         nearestPharmacy = pharmacy;
//         shortestDistance = distance;
//       }
//     }

//     return nearestPharmacy;
//   }
// }

 MPharmacy? findNearestPharmacyWithDrug(LatLng userLocation, String requiredDrug, List<MPharmacy> allPharmacies, List<MPharmacy> pharmaciesWithZeroQuantity) {
    double initialRadius = 50.0; // Initial radius in meters
    double radius = initialRadius;
    MPharmacy? nearestPharmacyWithQuantity;
    pharmaciesWithZeroQuantity.clear(); // Clear the list before starting the search

    while (nearestPharmacyWithQuantity == null) {
      List<MPharmacy> pharmaciesWithinRadius = kdTree.searchWithinRadius(userLocation, radius, requiredDrug);

      // Dynamically add pharmacies to KDTree within the new radius
      for (MPharmacy pharmacy in allPharmacies) {
        double distance = kdTree.calculateDistance(userLocation.latitude, userLocation.longitude,
                                                    pharmacy.location.latitude, pharmacy.location.longitude);
        if (distance <= radius) {
          kdTree.insert(pharmacy);
        }
      }

      // Process pharmacies within the current radius
      for (MPharmacy pharmacy in pharmaciesWithinRadius) {
        double distance = kdTree.calculateDistance(userLocation.latitude, userLocation.longitude,
                                                    pharmacy.location.latitude, pharmacy.location.longitude);
        if (pharmacy.hasDrug(requiredDrug)) {
          if (pharmacy.drugs.any((drug) => drug.name == requiredDrug && drug.quantity > 0)) {
            nearestPharmacyWithQuantity = pharmacy;
            break;
          } else {
            // Check if the pharmacy is already in pharmaciesWithZeroQuantity to avoid duplicates
            if (!pharmaciesWithZeroQuantity.contains(pharmacy)) {
              pharmaciesWithZeroQuantity.add(pharmacy);
            }
          }
        }
      }

      radius += 50.0; // Increase radius by 50 meters (adjust as needed)
    }
    // If no pharmacy with the required drug was found, handle appropriately
    // if (nearestPharmacyWithQuantity == null) {
    //   throw Exception('Pharmacy with drug $requiredDrug not found.');
    // }
    return nearestPharmacyWithQuantity;
  }
}