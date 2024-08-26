import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:project/component/home_screen.dart';
import 'package:project/data/markers.dart';
import 'package:search_map_location/search_map_location.dart';
// ignore: library_prefixes
import 'package:url_launcher/url_launcher.dart' as UrlLauncher;
import 'package:location/location.dart';
import 'package:google_fonts/google_fonts.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});
  @override
  State<MapPage> createState() => _MapPageState();
}

class Geolocation {
  LatLng coordinates;
  LatLngBounds bounds;

  Geolocation({required this.coordinates, required this.bounds});
}

class _MapPageState extends State<MapPage> {
  Set<Marker> _markers = {};
  double zoomVal = 5.0;
  bool _isSearchBarVisible = false;
  GoogleMapController? mapController;
  Location location = Location();
  final Completer<GoogleMapController> _controller = Completer();
  final List<Marker> myMarker = [];

  @override
  void initState() {
    super.initState();
    _getCurrentLocation(); // Call the method to determine the user's position
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    _getCurrentLocation();
  }

 Future<void> _getCurrentLocation() async {
    try {
      LocationData currentLocation = await location.getLocation();
      if(_controller.isCompleted){
        final GoogleMapController mapController = await _controller.future;
        mapController.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
              target: LatLng(currentLocation.latitude!, currentLocation.longitude!),
              zoom: 14.4746,
            ),
          ),
        );
      }      
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 55, 26, 200),
        leading: SizedBox(
          child: IconButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const HomeScreen()));
              },
              icon: const Icon(
                Icons.arrow_back_sharp,
                color: Colors.white,
              )),
        ),
        title: Text(
          'Back',
          style: GoogleFonts.dmSans(
            color: Colors.white,
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        ),
        bottom: PreferredSize(
            preferredSize: const Size.fromHeight(90.0),
            child: Container(
              padding: const EdgeInsets.all(10.0),
              alignment: Alignment.centerLeft,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Transport Info',
                    style: GoogleFonts.openSans(
                      color: Colors.white,
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Image(
                    image: AssetImage('assets_images/icons8-info-50.png'),
                    width: 60,
                    height: 80,
                    color: Colors.white,
                  ),
                ],
              ),
            )),
      ),
      body: Stack(
        children: <Widget>[
          _buildContainer(),
          _googlemap(context, _markers),
          _isSearchBarVisible ? _searchBar() : const SizedBox(),
          _icon(),
        ],
      ),
    );
  }

  Widget _buildContainer() {
    return Align(
      alignment: Alignment.bottomLeft,
      child: Container(),
    );
  }

  Widget _googlemap(BuildContext context, Set<Marker> markers) {
    Set<Marker> allMarkers = Set<Marker>.from(markers)..addAll(myMarker);
    LatLng initialCameraPosition;

    // Check if there is a user location marker
    if (myMarker.isNotEmpty) {
      initialCameraPosition = myMarker.first.position;
    } else {
      // Default to a specific location if user location is not available
      initialCameraPosition =  const LatLng(0.0,0.0);
    }

    return SizedBox(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: GoogleMap(
        mapType: MapType.normal,
        initialCameraPosition: CameraPosition(
          target: initialCameraPosition,
          zoom: 12,
        ),
        myLocationEnabled: true, // Enable my location button on the map
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
        markers: allMarkers,
      ),
    );
  }

  Widget _icon() {
    return Align(
      alignment: Alignment.topRight,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          GestureDetector(
            onTap: () {
              _generateMarkers();
              setState(() {});
            },
            child: const Image(
              image: AssetImage('assets_images/Parking.png'),
              height: 35,
              width: 35,
            ),
          ),
          const SizedBox(height: 8),
          const Image(
            image: AssetImage('assets_images/debit_credit.png'),
            height: 35,
            width: 35,
          ),
          GestureDetector(
            onTap: () {
              setState(() {
                _isSearchBarVisible = !_isSearchBarVisible;
              });
            },
            child: const Image(
              image: AssetImage('assets_images/location.png'),
              height: 35,
              width: 35,
            ),
          ),
        ],
      ),
    );
  }

  Widget _searchBar() {
    return Stack(
      children: [
        Positioned(
          bottom: 15,
          left: 0,
          right: 0,
          child: Center(
            child: DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                color: Colors.black,
              ),
              child: SearchLocation(
                apiKey: "AIzaSyDqSqaRpMggI2QWsPd-jdp-611FxMrxyMs",
              ),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _generateMarkers() async {
    // Clear existing markers before adding new ones
    _markers.clear();

    // Add new markers to the set
    _markers.addAll(kuantanMarkersList);
    _markers.addAll(machangMarkersList);
    _markers.addAll(kualaTerengganuMarkersList);

    Set<Marker> updatedMarkers = <Marker>{};

    for (Marker marker in _markers) {
      Marker updatedMarker = Marker(
        markerId: marker.markerId,
        position: marker.position,
        onTap: () => _showNavigationDialog(marker),
      );
      updatedMarkers.add(updatedMarker);
    }

    setState(() {
      _markers = updatedMarkers;
    });
  }

  Future<void> _showNavigationDialog(Marker marker) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Navigate to ${marker.markerId.value}'),
            content: const Text("Choose a navigation app"),
            actions: [
              TextButton(
                onPressed: () {
                  _launchGoogleMaps(marker.position);
                  Navigator.pop(context);
                },
                child: const Text("Google Maps"),
              )
            ],
          );
        });
  }

  void _launchGoogleMaps(LatLng destination) async {
    final url = Uri.parse(
        "https://www.google.com/maps/dir/?api=1&destination=${destination.latitude},${destination.longitude}");
    if (await UrlLauncher.launchUrl(url)) {
      await UrlLauncher.launchUrl(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
