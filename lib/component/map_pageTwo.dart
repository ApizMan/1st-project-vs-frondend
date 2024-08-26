// ignore: file_names
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class MapPageTwo extends StatefulWidget {
  const MapPageTwo({super.key});

  @override
  State<MapPageTwo> createState() => _MapPageTwoState();
}

class _MapPageTwoState extends State<MapPageTwo> {
  final Completer<GoogleMapController> _controller = Completer();
  final List<Marker> myMarker = [];

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  _getCurrentLocation() async {
    Location location = Location();

    bool serviceEnabled;
    PermissionStatus permissionGranted;
    LocationData locationData;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return;
      }
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    locationData = await location.getLocation();

    setState(() {
      myMarker.add(
        Marker(
          markerId: const MarkerId('CurrentLocation'),
          position: LatLng(locationData.latitude!, locationData.longitude!),
          infoWindow: const InfoWindow(title: 'Your Location'),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: GoogleMap(
          initialCameraPosition: const CameraPosition(
            target: LatLng(3.207730998422345, 101.77983508463517),
            zoom: 14,
          ),
          mapType: MapType.normal,
          markers: Set<Marker>.of(myMarker),
          onMapCreated: (GoogleMapController controller) {
            _controller.complete(controller);
          },
        ),
      ),
    );
  }
}
