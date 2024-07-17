import 'dart:math';
import 'package:myapp/Geofencing/pharmacy.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';


// class LatLng {
//   final double latitude;
//   final double longitude;

//   LatLng(this.latitude, this.longitude);
// }

// class Pharmacy {
//   final String name;
//   final LatLng location;
//   final List<String> availableDrugs;

//   Pharmacy(this.name, this.location, this.availableDrugs);

//   bool hasDrug(String drug) {
//     return availableDrugs.contains(drug);
//   }
// }

class KDNode {
  final LatLng point;
  MPharmacy pharmacy;
  KDNode? left, right;

  KDNode(this.point, this.pharmacy);
}

class KDTree {
  KDNode? root;

  KDTree() {
    root = null;
  }

  void insert(MPharmacy pharmacy) {
    root = _insert(root, pharmacy, 0);
  }

  KDNode _insert(KDNode? node, MPharmacy pharmacy, int depth) {
    if (node == null) {
      return KDNode(pharmacy.location as LatLng, pharmacy);
    }

    int axis = depth % 2; // Alternates between latitude and longitude
    if (axis == 0) {
      if (pharmacy.location.latitude < node.point.latitude) {
        node.left = _insert(node.left, pharmacy, depth + 1);
      } else {
        node.right = _insert(node.right, pharmacy, depth + 1);
      }
    } else {
      if (pharmacy.location.longitude < node.point.longitude) {
        node.left = _insert(node.left, pharmacy, depth + 1);
      } else {
        node.right = _insert(node.right, pharmacy, depth + 1);
      }
    }

    return node;
  }

  List<MPharmacy> searchWithinRadius(LatLng userLocation, double radius, String requiredDrug) {
    List<MPharmacy> pharmaciesWithinRadius = [];
    _searchWithinRadius(root, userLocation, radius, requiredDrug, pharmaciesWithinRadius, 0);
    return pharmaciesWithinRadius;
  }

  void _searchWithinRadius(KDNode? node, LatLng target, double radius, String requiredDrug, List<MPharmacy> result, int depth) {
    if (node == null) return;

    double distance = calculateDistance(target.latitude, target.longitude, node.point.latitude, node.point.longitude);
    if (distance <= radius && node.pharmacy.hasDrug(requiredDrug)) {
      result.add(node.pharmacy);
    }

    int axis = depth % 2;
    double diff = axis == 0
        ? target.latitude - node.point.latitude
        : target.longitude - node.point.longitude;

    if (diff <= 0) {
      _searchWithinRadius(node.left, target, radius, requiredDrug, result, depth + 1);
      if (diff.abs() <= radius) _searchWithinRadius(node.right, target, radius, requiredDrug, result, depth + 1);
    } else {
      _searchWithinRadius(node.right, target, radius, requiredDrug, result, depth + 1);
      if (diff.abs() <= radius) _searchWithinRadius(node.left, target, radius, requiredDrug, result, depth + 1);
    }
  }

  double calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    const R = 6371.0; // Radius of the Earth in km
    double dLat = _toRadians(lat2 - lat1);
    double dLon = _toRadians(lon2 - lon1);
    double a = sin(dLat / 2) * sin(dLat / 2) +
               cos(_toRadians(lat1)) * cos(_toRadians(lat2)) *
               sin(dLon / 2) * sin(dLon / 2);
    double c = 2 * atan2(sqrt(a), sqrt(1 - a));
    double distance = R * c; // Distance in km
    return distance * 1000.0; // Convert to meters
  }

  double _toRadians(double degree) {
    return degree * pi / 180.0;
  }
}