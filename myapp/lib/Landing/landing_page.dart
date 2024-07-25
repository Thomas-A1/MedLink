import 'dart:ui' as ui;
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:myapp/authentication/controllers/RecentSearch/recentSearch_Controller.dart';
import 'package:myapp/authentication/screens/profile/user_profile.dart';
import 'package:myapp/data/repositories/pharmacies/pharmacy_repository.dart';
import 'package:myapp/models/pharmacy_model.dart';
import 'package:myapp/utils/loaders/loaders.dart';
import 'package:myapp/widgets/CustomInfoWindow.dart';
import 'package:custom_info_window/custom_info_window.dart';
import 'package:myapp/Landing/Location_provider.dart';
import 'package:myapp/authentication/screens/DrugSearch/drugsearch.dart';
import 'package:myapp/widgets/search_ripple.dart';

class LandingPage extends StatefulWidget {
  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
final LocationController _LocationController = Get.find();

  Location _locationController = new Location();
  GoogleMapController? _mapController;
  final LatLng _initialPosition = const LatLng(5.7583804, -0.21917);
  Map<String, Marker> _markers = {};
  late Future<List<Pharmacy>> _pharmacies;
  LatLng? current_position = null;
  Pharmacy? _selectedPharmacy;
  LatLng? _selectedPharmacyPosition;
  Offset? _infoWindowPosition;
  Set<String> _pharmacyMarkers = Set<String>();
  CustomInfoWindowController _customInfoWindowController = CustomInfoWindowController();
  final RecentSearchesController _recentSearchesController = Get.put(RecentSearchesController());
  double _initialGeofenceRadius = 50.0; // Initial Radius of geofence in meters
  Circle? _geofenceCircle;
  double _currentZoom = 14.0;


  @override
  void initState() {
    super.initState();
    getLocationUpdates();
    _pharmacies = PharmacyRepository.instance.getPharmacies();
    fetchPharmacies();
  }

  bool _isSidebarOpen = false;

  void _toggleSidebar() {
    setState(() {
      _isSidebarOpen = !_isSidebarOpen;
    });
  }

  Future<void> getLocationUpdates() async {
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    _serviceEnabled = await _locationController.serviceEnabled();
    if (_serviceEnabled) {
      _serviceEnabled = await _locationController.requestService();
    } else {
      return;
    }
    _permissionGranted = await _locationController.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await _locationController.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        Loaders.warningSnackBar(
          title: 'Ooops...',
          message: "Permission to access device location was denied",
        );
        return;
      }
    }
    _locationController.onLocationChanged
        .listen((LocationData currentLocation) {
      if (currentLocation.latitude != null &&
          currentLocation.longitude != null) {
        setState(() {
          current_position =
              LatLng(currentLocation.latitude!, currentLocation.longitude!);
              _LocationController.updatePosition(current_position!);
          _updateCurrentLocationMarker("_currentLocation", current_position!);
          _addGeofenceCircle(current_position!);
          // Do not move the camera here to allow free map movement
        });
      }
    });
  }

  void _closeSidebar() {
    setState(() {
      _isSidebarOpen = false;
    });
  }

  void _moveToCurrentPosition() {
    LatLng? currentPosition = _LocationController.currentPosition.value;
    if (current_position != null) {
      _mapController?.animateCamera(CameraUpdate.newLatLng(current_position!));
    } else {
      Loaders.warningSnackBar(
        title: 'Ooops...',
        message: "Current location not available. Turn on Location on device",
      );
    }
  }

  // Geofence circle
  void _addGeofenceCircle(LatLng location) {
    setState(() {
      _geofenceCircle = Circle(
      circleId: CircleId("geofence"),
      center: location,
      radius: _initialGeofenceRadius,
      fillColor: ui.Color.fromARGB(255, 202, 211, 220).withOpacity(0.6),
      strokeColor: ui.Color.fromARGB(255, 202, 211, 220),
      strokeWidth: 2,
    );
    });
  }

  Future<void> _updateCurrentLocationMarker(String id, LatLng location) async {
    var customMarkerIcon = await _createCustomMarkerIconWithHighlight(
        'assets/images/man.png', 50, 50, 65, Colors.blue, Colors.blue);
    var marker = Marker(
      markerId: MarkerId(id),
      position: location,
      icon: customMarkerIcon,
      infoWindow: const InfoWindow(title: 'Current Location'),
    );
    _markers[id] = marker;
    setState(() {});
  }

  Future<BitmapDescriptor> _createCustomMarkerIconWithHighlight(
      String imagePath,
      int width,
      int height,
      double radius,
      Color shadowColor,
      Color circleColor) async {
    ByteData data = await rootBundle.load(imagePath);
    Uint8List bytes = data.buffer.asUint8List();
    ui.Codec codec = await ui.instantiateImageCodec(bytes,
        targetWidth: width, targetHeight: height);
    ui.FrameInfo frameInfo = await codec.getNextFrame();
    ui.Image image = frameInfo.image;

    // Radius of the custom marker
    final double size = radius;

    // Create a picture recorder to record the drawing commands
    final ui.PictureRecorder pictureRecorder = ui.PictureRecorder();
    final Canvas canvas = Canvas(pictureRecorder);

    // Draw the shadow circle
    final Paint shadowPaint = Paint()
      ..color = shadowColor.withOpacity(0.4)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(size / 2, size / 2 + 4), size / 2 + 10,
        shadowPaint); // Offset for shadow effect and increase glow size

    // Draw the blue circle
    final Paint circlePaint = Paint()
      ..color = circleColor
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(size / 2, size / 2), size / 2, circlePaint);

    // Draw the white circle inside the blue circle to create a border effect
    final Paint whiteCirclePaint = Paint()
      ..color = const ui.Color.fromARGB(255, 235, 233, 233)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(
        Offset(size / 2, size / 2), (size / 2) - 4, whiteCirclePaint);

    // Draw the resized image in the center of the circle
    final double imageOffset = (size - width) / 2;
    canvas.drawImage(image, Offset(imageOffset, imageOffset), Paint());

    // Convert the recorded picture into an image
    final ui.Picture picture = pictureRecorder.endRecording();
    final ui.Image markerImage =
        await picture.toImage(size.toInt(), size.toInt());

    // Convert the image to byte data
    final ByteData? byteData =
        await markerImage.toByteData(format: ui.ImageByteFormat.png);
    final Uint8List markerBytes = byteData!.buffer.asUint8List();

    return BitmapDescriptor.fromBytes(markerBytes);
  }

  // Have the pharmacy markers applied on all the pharmacies from the database
  void fetchPharmacies() async {
    List<Pharmacy> pharmacies = await _pharmacies;
    for (Pharmacy pharmacy in pharmacies) {
      _addPharmacyMarker(pharmacy);
    }
  }

  // Custom Pharmacy Marker
  void _addPharmacyMarker(Pharmacy pharmacy) async {
  var customMarkerIcon = await _createCustomMarkerIconWithHighlight(
      'assets/images/drugstore.png',
      40,
      40,
      55,
      ui.Color.fromARGB(255, 227, 60, 60),
      ui.Color.fromARGB(255, 227, 60, 60));

  var marker = Marker(
    markerId: MarkerId(pharmacy.id),
    position: pharmacy.location,
    icon: customMarkerIcon,
    // Set visibility based on the zoom level
    visible: _currentZoom >= 14.0, // Adjusted based on your requirement
    onTap: () {
      _customInfoWindowController.addInfoWindow!(
        MCustomInfoWindow(
          pharmacy: pharmacy,
        ),
        pharmacy.location,
      );

      // Update the selected pharmacy and its position
      setState(() {
        _selectedPharmacy = pharmacy;
        _selectedPharmacyPosition = pharmacy.location;
      });
    },
  );

  setState(() {
    _markers[pharmacy.id] = marker;
    _pharmacyMarkers.add(pharmacy.id);
  });
}


  void _onMapTap(LatLng position) {
    setState(() {
      _selectedPharmacy = null;
      _selectedPharmacyPosition = null;
    });
  }

// Function to decide the visibility of the pharmacy markers based on the zoom level
void _updateMarkerVisibility() {
  setState(() {
    _markers.forEach((id, marker) {
      // Check if the marker corresponds to a pharmacy
      if (_pharmacyMarkers.contains(id)) {
        _markers[id] = marker.copyWith(
          visibleParam: _currentZoom >= 14.0,
        );
      }
    });

    // Update visibility of geofence circle
    if (_currentZoom > 19.0) {
      _geofenceCircle = Circle(
        circleId: CircleId("geofence"),
        center: current_position!,
        radius: _initialGeofenceRadius,
        fillColor: ui.Color.fromARGB(255, 202, 211, 220).withOpacity(0.6),
        strokeColor: ui.Color.fromARGB(255, 202, 211, 220),
        strokeWidth: 2,
      );
    } else {
      _geofenceCircle = null;
    }
  });
}


  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final sidebarWidth = screenWidth * 0.75;

    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: _initialPosition,
              zoom: 18.0,
            ),
            onMapCreated: (controller) {
              _mapController = controller;
              _customInfoWindowController.googleMapController = controller;
              if (current_position != null) {
                _updateCurrentLocationMarker(
                    "_currentLocation", current_position!);
                _addGeofenceCircle(current_position!);
              }
            },
            markers: Set<Marker>.of(_markers.values),
            circles: _geofenceCircle != null ? Set<Circle>.of([_geofenceCircle!]) : Set<Circle>(),
            onTap: (position) {
              _customInfoWindowController.hideInfoWindow!();
              setState(() {
                _selectedPharmacy = null;
                _selectedPharmacyPosition = null;
              });
            },
            onCameraMove: (position) {
              _customInfoWindowController.onCameraMove!();
              setState(() {
                _currentZoom = position.zoom;
              });
              _updateMarkerVisibility();
            },
          ),
          CustomInfoWindow(
            controller: _customInfoWindowController,
            height: 180,
            width: 260,
            offset: 40,
          ),
          if (current_position != null)
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              bottom: 0,
              child: RippleAnimationWidget(position: current_position!),
            ),
          Positioned(
            top: 50,
            left: 20,
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 5,
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: IconButton(
                icon: const Icon(Icons.menu),
                onPressed: _toggleSidebar,
              ),
            ),
          ),
          // Location Button
          Positioned(
            bottom: 380,
            right: 20,
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 5,
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: IconButton(
                icon: const Icon(Icons.my_location),
                onPressed: _moveToCurrentPosition,
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              padding: const EdgeInsets.all(16.0),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 10,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Grey Rectangular Box
                  Center(
                    child: Container(
                      height: 3,
                      width: 60,
                      decoration: BoxDecoration(
                        color: Colors.grey[400],
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),
                  // Search Bar
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => DrugSearch()),
                      );
                    },
                    child: Container(
                      height: 60, // Set the desired height here
                      decoration: BoxDecoration(
                        color: ui.Color.fromARGB(240, 224, 224, 224),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: const BoxDecoration(
                                color: ui.Color.fromARGB(255, 238, 238, 238),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.search, size: 24),
                            ),
                          ),
                          const Text(
                            'Search for a drug',
                            style:
                                TextStyle(fontSize: 16, color: Colors.black54),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),
                  const Padding(
                    padding: EdgeInsets.only(left: 2),
                    child: Text(
                      'Recently Searched',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16), // Adjust spacing here
                  SizedBox(
                    height: 200, // Set a fixed height for the container
                    child: Obx(
                      () {
                        final recentSearches =
                            _recentSearchesController.recentSearches;
                        final recentSearchesToShow = recentSearches.length > 3
                            ? recentSearches.sublist(0, 3)
                            : recentSearches;
                        return ListView.builder(
                          shrinkWrap: true,
                          padding: EdgeInsets.zero,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: recentSearchesToShow.length,
                          itemBuilder: (context, index) {
                            String search = recentSearchesToShow[index];
                            return ListTile(
                              contentPadding: EdgeInsets.zero,
                              leading: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.grey[300],
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Icon(Icons.access_time,
                                    color: Colors.black),
                              ),
                              title: Text(search),
                              onTap: () {
                                // Navigate to DrugSearch page and populate search input
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => DrugSearch(
                                      initialSearch: search,
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (_isSidebarOpen) ...[
            GestureDetector(
              onTap: _closeSidebar,
              child: Container(
                color: Colors.black.withOpacity(0.5),
                width: screenWidth,
                height: double.infinity,
              ),
            ),
            Positioned(
              top: 0,
              bottom: 0,
              left: 0,
              child: Container(
                width: sidebarWidth,
                color: Colors.grey[200],
                child: Column(
                  children: [
                    const SizedBox(
                        height:
                            100), // Increased top space for profile container
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      margin: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        children: [
                          const CircleAvatar(
                            backgroundImage:
                                AssetImage('assets/images/profile.png'),
                            radius: 30,
                          ),
                          const SizedBox(width: 16),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Your Name',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold)),
                              TextButton(
                                onPressed: () =>
                                    Get.to(() => const ProfileScreen()),
                                child: const Text(
                                  'My Account',
                                  style: TextStyle(color: Colors.lightGreen),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20),
                    Expanded(
                      child: ListView(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        children: [
                          Container(
                            width: double.infinity,
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ListTile(
                                  title: Text('Payment'),
                                  leading: Icon(Icons.payment),
                                  onTap: () {},
                                ),
                                ListTile(
                                  title: Text('My Orders'),
                                  leading: Icon(Icons.shopping_cart),
                                  onTap: () {},
                                ),
                                ListTile(
                                  leading: Icon(Icons.location_on),
                                  title: Row(
                                    children: [
                                      Expanded(child: Text('Geolocation')),
                                      Switch(
                                        value: true,
                                        onChanged: (bool value) {},
                                      ),
                                    ],
                                  ),
                                ),
                                ListTile(
                                  title: Text('Support'),
                                  leading: Icon(Icons.support),
                                  onTap: () {},
                                ),
                                ListTile(
                                  title: Text('About'),
                                  leading: Icon(Icons.info),
                                  onTap: () {},
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 20),
                          Container(
                            width: double.infinity,
                            height: MediaQuery.of(context).size.height *
                                0.4, // Adjust height as needed
                            padding: EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: ListTile(
                              leading: Icon(Icons.delete, color: Colors.red),
                              title: Text(
                                'Delete Account',
                                style:
                                    TextStyle(color: Colors.red, fontSize: 16),
                              ),
                              onTap: () {},
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:myapp/data/repositories/pharmacies/pharmacy_repository.dart';
// import 'package:myapp/models/pharmacy_model.dart';

// class LandingPage extends StatefulWidget {
//   @override
//   _LandingPageState createState() => _LandingPageState();
// }

// class _LandingPageState extends State<LandingPage> {
//   late Future<List<Pharmacy>> _pharmacies;

//   @override
//   void initState() {
//     super.initState();
//     _pharmacies = PharmacyRepository.instance.getPharmacies();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Pharmacy Test'),
//       ),
//       body: FutureBuilder<List<Pharmacy>>(
//         future: _pharmacies,
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Center(child: CircularProgressIndicator());
//           } else if (snapshot.hasError) {
//             return Center(child: Text('Error: ${snapshot.error}'));
//           } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
//             return Center(child: Text('No pharmacies found.'));
//           } else {
//             List<Pharmacy> pharmacies = snapshot.data!;
//             return ListView.builder(
//               itemCount: pharmacies.length,
//               itemBuilder: (context, index) {
//                 Pharmacy pharmacy = pharmacies[index];
//                 return ListTile(
//                   title: Text(pharmacy.name),
//                   subtitle: Text(pharmacy.phone),
//                 );
//               },
//             );
//           }
//         },
//       ),
//     );
//   }
// }
