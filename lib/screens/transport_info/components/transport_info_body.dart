import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:project/constant.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';

// ignore: must_be_immutable
class TransportInfoBody extends StatefulWidget {
  final bool showMeter; // Keep it final

  TransportInfoBody({
    super.key,
    required this.showMeter,
  });

  @override
  State<TransportInfoBody> createState() => _TransportInfoBodyState();
}

class _TransportInfoBodyState extends State<TransportInfoBody> {
  Location locationController = Location();

  final Completer<GoogleMapController> _mapController =
      Completer<GoogleMapController>();

  static const LatLng _pGooglePlex = LatLng(3.201177, 101.777404);

  static const LatLng _pApplePark = LatLng(3.207597, 101.784871);

  LatLng? _currentPosition = null;

  Map<PolylineId, Polyline> polylines = {};

  @override
  void initState() {
    super.initState();
    getLocationUpdate().then(
      (_) => {
        getPolylinePoint().then(
          (coordinates) => {
            generatePolylineFromPoints(coordinates),
          },
        ),
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_currentPosition == null) {
      return const Center(
        child: CircularProgressIndicator(
          color: kPrimaryColor,
        ),
      );
    }
    return GoogleMap(
      trafficEnabled: true,
      padding: const EdgeInsets.only(bottom: 20.0, left: 7.0),
      onMapCreated: (GoogleMapController controller) => _mapController.complete(
        controller,
      ),
      initialCameraPosition: CameraPosition(
        target: _currentPosition!,
        zoom: 15,
      ),
      markers: {
        Marker(
          markerId: const MarkerId('_currentLocation'),
          icon: AssetMapBitmap(
            YOU_ARE_HERE_ICON,
            width: 80.0,
            height: 80.0,
          ),
          position: _currentPosition!,
        ),
        if (widget.showMeter) ...[
          Marker(
            markerId: const MarkerId('_sourcesLocation'),
            icon: AssetMapBitmap(
              METER_ICON,
              width: 60.0,
              height: 60.0,
            ),
            position: _pGooglePlex,
          ),
          Marker(
            markerId: const MarkerId('_destinationLocation'),
            icon: AssetMapBitmap(
              METER_ICON,
              width: 60.0,
              height: 60.0,
            ),
            position: _pApplePark,
          ),
        ],
      },
      polylines: Set<Polyline>.of(polylines.values),
    );
  }

  Future<void> _cameraToPosition(LatLng position) async {
    final GoogleMapController controller = await _mapController.future;
    CameraPosition _newCameraPosition = CameraPosition(
      target: position,
      zoom: 15,
    );

    await controller.animateCamera(
      CameraUpdate.newCameraPosition(
        _newCameraPosition,
      ),
    );
  }

  Future<void> getLocationUpdate() async {
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;

    _serviceEnabled = await locationController.serviceEnabled();
    if (_serviceEnabled) {
      _serviceEnabled = await locationController.requestService();
    } else {
      return;
    }

    _permissionGranted = await locationController.hasPermission();

    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await locationController.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    locationController.onLocationChanged.listen(
      (LocationData currentLocation) {
        if (currentLocation.latitude != null &&
            currentLocation.longitude != null) {
          setState(() {
            _currentPosition =
                LatLng(currentLocation.latitude!, currentLocation.longitude!);
            _cameraToPosition(_currentPosition!);
          });
        }
      },
    );
  }

  Future<List<LatLng>> getPolylinePoint() async {
    List<LatLng> polylineCoordinates = [];
    PolylinePoints polylinePoints = PolylinePoints();

    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      GOOGLE_MAPS_API_KEY,
      PointLatLng(_pGooglePlex.latitude, _pGooglePlex.longitude),
      PointLatLng(_pApplePark.latitude, _pApplePark.longitude),
      travelMode: TravelMode.driving,
    );

    if (result.points.isNotEmpty) {
      result.points.forEach(
        (PointLatLng point) {
          polylineCoordinates.add(
            LatLng(point.latitude, point.longitude),
          );
        },
      );
    } else {
      print(result.errorMessage);
    }

    return polylineCoordinates;
  }

  void generatePolylineFromPoints(List<LatLng> polylineCoordinates) async {
    PolylineId id = const PolylineId('poly');
    Polyline polyline = Polyline(
      polylineId: id,
      color: kPrimaryColor,
      points: polylineCoordinates,
      width: 8,
    );
    setState(() {
      polylines[id] = polyline;
    });
  }
}
