import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:myapp/authentication/screens/profile/user_profile.dart';
import 'package:myapp/utils/loaders/loaders.dart';

class LandingPage extends StatefulWidget {
  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  Location _locationController = new Location();
  GoogleMapController? _mapController;
  final LatLng _initialPosition = const LatLng(5.7583804, -0.21917);
  LatLng? current_position = null;

  @override
  void initState() {
    super.initState();
    getLocationUpdates();
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
          print(current_position);
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
    if (current_position != null) {
      _mapController?.animateCamera(CameraUpdate.newLatLng(current_position!));
    } else {
      Loaders.warningSnackBar(
        title: 'Ooops...',
        message: "Current location not available",
      );
    }
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
              zoom: 13.0,
            ),
            onMapCreated: (controller) {
              _mapController = controller;
            },
            markers: current_position != null
                ? {
                    Marker(
                      markerId: MarkerId("_currentLocation"),
                      icon: BitmapDescriptor.defaultMarker,
                      position: current_position!,
                    ),
                  }
                : {},
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
            bottom: 350,
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
                      height: 4,
                      width: 60,
                      decoration: BoxDecoration(
                        color: Colors.grey[400],
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),
                  // Search Bar
                  Container(
                    height: 60, // Set the desired height here
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Search for a drug',
                        hintStyle: const TextStyle(fontSize: 16),
                        prefixIcon: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.search, size: 24),
                          ),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 20), // Adjust vertical padding
                        border: InputBorder.none,
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
                  ListView(
                    shrinkWrap: true,
                    padding: EdgeInsets.zero, // Remove default padding
                    physics:
                        const NeverScrollableScrollPhysics(), // Disable scrolling
                    children: [
                      ListTile(
                        contentPadding:
                            EdgeInsets.zero, // Remove ListTile padding
                        leading: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(Icons.access_time,
                              color: Colors.black),
                        ),
                        title: const Text('Location 1'),
                        onTap: () {
                          // Handle location tap
                        },
                      ),
                      ListTile(
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
                        title: const Text('Location 2'),
                        onTap: () {
                          // Handle location tap
                        },
                      ),
                      ListTile(
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
                        title: const Text('Location 3'),
                        onTap: () {
                          // Handle location tap
                        },
                      ),
                    ],
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
