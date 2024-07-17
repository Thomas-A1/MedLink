import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:myapp/Geofencing/geocoding_location.dart';
import 'package:myapp/authentication/controllers/RecentSearch/recentSearch_Controller.dart';
import 'package:algolia/algolia.dart';
import 'package:myapp/Landing/Location_provider.dart';
import 'package:myapp/helpers/algolia_api.dart';
import 'package:flutter_svg/flutter_svg.dart';

class DrugSearch extends StatefulWidget {
  final String? initialSearch;

  DrugSearch({this.initialSearch});

  @override
  _DrugSearchState createState() => _DrugSearchState();
}

class _DrugSearchState extends State<DrugSearch> {
  TextEditingController _drugController = TextEditingController();
  TextEditingController _addressController = TextEditingController();
  List<String> _suggestions = [];
  final RecentSearchesController _recentSearchesController =
      Get.put(RecentSearchesController());

  bool _isSearchFocused = false;

  @override
  void initState() {
    super.initState();
    if (widget.initialSearch != null) {
      _drugController.text = widget.initialSearch!;
    }
    // Fetch and set the user's current address
    LatLng current_position =
        Get.find<LocationController>().currentPosition.value!;
    getAddressFromLatLng(current_position).then((address) {
      setState(() {
        _addressController.text = address;
      });
    });
  }

  void _searchDrug(String query) async {
    if (query.isEmpty) {
      setState(() {
        _suggestions = [];
      });
      return;
    }

    // Search Algolia for suggestions
    AlgoliaQuery algoliaQuery = AlgoliaService.algolia.instance
        .index('pharmaciees_index_query_suggestions')
        .search(query);
    AlgoliaQuerySnapshot snapshot = await algoliaQuery.getObjects();

    setState(() {
      _suggestions = snapshot.hits
          .map((hit) => hit.data['drugs'] as List<dynamic>)
          .expand((drugs) => drugs.map((drug) => drug['Common name'] as String))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.close),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: const Text(
          'Drug Search',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 229, 228, 228),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: TextField(
                controller: _addressController,
                readOnly: true,
                onTap: () {
                  // Focus on search input and change border color
                  setState(() {
                    _isSearchFocused = false;
                  });
                },
                decoration: InputDecoration(
                  prefixIcon: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(
                        color: Color.fromARGB(255, 188, 197, 224),
                        shape: BoxShape.circle,
                      ),
                      child: SvgPicture.asset(
                        'assets/images/current_location.svg',
                        width: 24,
                        height: 24,
                      ),
                    ),
                  ),
                  hintText: 'Current Address',
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 18.0),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Container(
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 233, 230, 230),
                borderRadius: BorderRadius.circular(8.0),
                border: Border.all(
                  color: _isSearchFocused
                      ? Colors.green
                      : const Color.fromARGB(255, 226, 223, 223),
                  width: _isSearchFocused ? 2.0 : 1.0,
                ),
              ),
              child: TextField(
                controller: _drugController,
                decoration: InputDecoration(
                  hintText: 'Search for a drug',
                  prefixIcon: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(
                        color: Color.fromARGB(
                            255, 193, 191, 191), // Adjust color as needed
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.search,
                          size: 24, color: Colors.white),
                    ),
                  ),
                  border: InputBorder.none,
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
                ),
                onChanged: _searchDrug,
                onTap: () {
                  // Focus on search input and change border color
                  setState(() {
                    _isSearchFocused = true;
                  });
                },
              ),
            ),
            SizedBox(height: 16),
            Expanded(
              child: _suggestions.isNotEmpty
                  ? ListView.builder(
                      itemCount: _suggestions.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(_suggestions[index]),
                          onTap: () {
                            _recentSearchesController
                                .addSearch(_suggestions[index]);
                            _drugController.text = _suggestions[index];
                          },
                        );
                      },
                    )
                  : _drugController.text.isEmpty
                      ? Obx(() =>
                          _recentSearchesController.recentSearches.isNotEmpty
                              ? Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Recently Searched',
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(height: 8),
                                    Wrap(
                                      spacing: 8,
                                      children: _recentSearchesController
                                          .recentSearches
                                          .take(3)
                                          .map((search) => GestureDetector(
                                                onTap: () {
                                                  _drugController.text = search;
                                                  _recentSearchesController
                                                      .addSearch(search);
                                                },
                                                child: Chip(
                                                  label: Row(
                                                    children: [
                                                      Icon(Icons.history),
                                                      SizedBox(width: 4),
                                                      Text(search),
                                                    ],
                                                  ),
                                                  deleteIcon: Icon(Icons.close),
                                                  onDeleted: () {
                                                    _recentSearchesController
                                                        .recentSearches
                                                        .remove(search);
                                                  },
                                                ),
                                              ))
                                          .toList(),
                                    ),
                                  ],
                                )
                              : Container())
                      : const Center(
                          child: Text(''),
                        ),
            ),
          ],
        ),
      ),
    );
  }
}
