import 'package:flutter/material.dart';
import 'package:myapp/Geofencing/geocoding_location.dart';
import 'package:myapp/models/pharmacy_model.dart';

class MCustomInfoWindow extends StatelessWidget {
  final Pharmacy pharmacy;

  const MCustomInfoWindow({Key? key, required this.pharmacy}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 1.5,
      height: MediaQuery.of(context).size.height * 0.6,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(
            color: Color.fromARGB(255, 98, 92, 92).withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12.0),
                topRight: Radius.circular(12.0),
              ),
              child: Image.network(
                pharmacy.image,
                width: double.infinity,
                height: MediaQuery.of(context).size.width * 0.5 * 0.5,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    pharmacy.name,
                    style: const TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 192, 65, 55),
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  Text(
                    'Opening Hours:',
                    style: const TextStyle(
                      fontSize: 15.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4.0),
                  // Display each day with its opening hours
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: pharmacy.openingHours.entries.map((entry) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 2.0),
                        child: Row(
                          children: [
                            Text(
                              '${entry.key}:',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(width: 4.0),
                            Text(
                              entry.value,
                              style: const TextStyle(fontSize: 13.0),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 8.0),
                  Row(
                    children: [
                      const Icon(Icons.phone),
                      const SizedBox(width: 4.0),
                      Text(
                        pharmacy.phone,
                        style: const TextStyle(fontSize: 13.0),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8.0),
                  FutureBuilder<String>(
                    future: getAddressFromLatLng(pharmacy.location),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      } else if (snapshot.hasError) {
                        return const Text(
                          'Error fetching address',
                          style: TextStyle(fontSize: 13.0),
                        );
                      } else {
                        return Row(
                          children: [
                            const Icon(Icons.location_on),
                            const SizedBox(width: 4.0),
                            Expanded(
                              child: Text(
                                snapshot.data ?? 'Address not available',
                                style: const TextStyle(fontSize: 13.0),
                              ),
                            ),
                          ],
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16.0), // Space between pharmacies
          ],
        ),
      ),
    );
  }
}
