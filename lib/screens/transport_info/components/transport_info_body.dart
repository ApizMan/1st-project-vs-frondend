import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_cluster_manager/google_maps_cluster_manager.dart'
    as cluster_manager;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:project/constant.dart';
import 'package:project/models/models.dart';

// ignore: must_be_immutable
class TransportInfoBody extends StatefulWidget {
  final bool showMeter; // Keep it final

  const TransportInfoBody({
    super.key,
    required this.showMeter,
  });

  @override
  State<TransportInfoBody> createState() => _TransportInfoBodyState();
}

class _TransportInfoBodyState extends State<TransportInfoBody> {
  late cluster_manager.ClusterManager _manager;

  Location locationController = Location();

  final Completer<GoogleMapController> _mapController =
      Completer<GoogleMapController>();

  LatLng? _currentPosition;

  Set<Marker> markers = {};

  late List<MeterModel> model = [];

  bool _isManagerReady = false; // Add this flag

  @override
  void initState() {
    super.initState();
    getLocationUpdate();
    loadAllMeterData().then((events) {
      setState(() {
        model = events;
        _manager =
            _initClusterManager(); // Initialize _manager here after model is loaded
        _isManagerReady = true; // Mark manager as ready
      });
    });
  }

  Future<List<MeterModel>> loadAllMeterData() async {
    const List<String> filePaths = [
      METER_KUANTAN,
      METER_KUALA_TERENGGANU_STRADA,
      METER_KUALA_TERENGGANU_CALE,
      METER_MACHANG,
    ];

    List<MeterModel> allMeters = [];

    for (String filePath in filePaths) {
      try {
        // Load the JSON data from the asset file
        final String jsonString = await rootBundle.loadString(filePath);

        // Decode the JSON string to a Map<String, dynamic>
        final Map<String, dynamic> jsonMap = jsonDecode(jsonString);

        // Extract the 'data' list from the map
        final List<dynamic> jsonList = jsonMap['data'];

        // Map the dynamic list to a list of MeterModel objects
        final List<MeterModel> meters = jsonList
            .map((json) => createPlaceFromJson(json as Map<String, dynamic>))
            .toList();

        allMeters.addAll(meters);
      } catch (e) {
        // Handle any errors during loading or parsing
        e.toString();
      }
    }

    return allMeters;
  }

  Future<void> _cameraToPosition(LatLng position) async {
    final GoogleMapController controller = await _mapController.future;
    CameraPosition newCameraPosition = CameraPosition(
      target: position,
      zoom: 18,
    );

    await controller.animateCamera(
      CameraUpdate.newCameraPosition(
        newCameraPosition,
      ),
    );
  }

  Future<void> getLocationUpdate() async {
    bool serviceEnabled;
    PermissionStatus permissionGranted;

    serviceEnabled = await locationController.serviceEnabled();
    if (serviceEnabled) {
      serviceEnabled = await locationController.requestService();
    } else {
      return;
    }

    permissionGranted = await locationController.hasPermission();

    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await locationController.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
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

  cluster_manager.ClusterManager _initClusterManager() {
    return cluster_manager.ClusterManager<MeterModel>(model, _updateMarkers,
        markerBuilder: _markerBuilder);
  }

  void _updateMarkers(Set<Marker> markers) {
    setState(() {
      this.markers = markers;
    });
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

    // Ensure that _manager is initialized before proceeding
    if (!_isManagerReady) {
      return const Center(
        child: CircularProgressIndicator(
          color: kPrimaryColor,
        ),
      );
    }

    return GoogleMap(
      trafficEnabled: true,
      padding: const EdgeInsets.only(bottom: 20.0, left: 7.0),
      mapType: MapType.normal,
      initialCameraPosition: CameraPosition(
        target: _currentPosition!,
        zoom: 18,
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
        if (widget.showMeter) ...markers
      },
      onMapCreated: (GoogleMapController controller) {
        _mapController.complete(
          controller,
        );
        _manager.setMapId(controller.mapId);
      },
      onCameraMove: _manager.onCameraMove,
      onCameraIdle: _manager.updateMap,
    );
  }

  Future<Marker> Function(cluster_manager.Cluster<MeterModel>)
      get _markerBuilder => (cluster) async {
            return Marker(
              markerId: MarkerId(cluster.getId()),
              position: cluster.location,
              onTap: () {
                for (var p in cluster.items) {
                  p.toString();
                }
              },
              // icon: await _getMarkerBitmap(cluster.isMultiple ? 125 : 75,
              //     text: cluster.isMultiple ? cluster.count.toString() : null),
              icon: AssetMapBitmap(
                METER_ICON,
                width: 60.0,
                height: 60.0,
              ),
            );
          };

}
