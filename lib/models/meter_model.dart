import 'package:google_maps_cluster_manager/google_maps_cluster_manager.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MeterModel with ClusterItem {
  final String terminalID;
  final LatLng? latLng;

  MeterModel({required this.terminalID, this.latLng});

  @override
  String toString() {
    return 'Place $terminalID (latLng: $latLng)';
  }

  @override
  LatLng get location => latLng ?? const LatLng(0, 0); // Return default location if latLng is null
}

// Function to create a Place object from JSON data
MeterModel createPlaceFromJson(Map<String, dynamic> json) {
  String? lat = json['Latitude'];
  String? lng = json['Longitude'];

  LatLng? latLng;
  if (lat != null && lat.isNotEmpty && lng != null && lng.isNotEmpty) {
    latLng = LatLng(double.parse(lat), double.parse(lng));
  }

  return MeterModel(
    terminalID: json['Terminal ID'],
    latLng: latLng,
  );
}