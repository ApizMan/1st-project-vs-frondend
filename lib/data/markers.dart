import 'package:google_maps_flutter/google_maps_flutter.dart';

class MarkerData {
  final String markerId;
  final LatLng position;
  final String title;

  MarkerData({
    required this.markerId,
    required this.position,
    required this.title,
  });
}

// Kuantan markers
final List<MarkerData> kuantanMarkers = [
  MarkerData(markerId: 'Kuantan 1', position: const LatLng(3.81718341729462, 103.326888483367), title: 'KN1A01'),
  MarkerData(markerId: 'Kuantan 2', position: const LatLng(3.81730525886114, 103.326533902839), title: 'KN1A02'),
  MarkerData(markerId: 'Kuantan 3', position: const LatLng(3.81745, 103.326), title: 'KN1A03'),
  MarkerData(markerId: 'Kuantan 4', position: const LatLng(3.81739, 103.3258), title: 'KN1A04'),
  MarkerData(markerId: 'Kuantan 5', position: const LatLng(3.81732, 103.3257), title: 'KN1A05'),
  MarkerData(markerId: 'Kuantan 6', position: const LatLng(3.81748, 103.3251), title: 'KN1A06'),
  MarkerData(markerId: 'Kuantan 7', position: const LatLng(3.81718, 103.3252), title: 'KN1A07'),
  MarkerData(markerId: 'Kuantan 8', position: const LatLng(3.81727, 103.3251), title: 'KN1A08'),
  MarkerData(markerId: 'Kuantan 9', position: const LatLng(3.81554, 103.3243), title: 'KN1A09'),
  MarkerData(markerId: 'Kuantan 10', position: const LatLng(3.81659, 103.3248), title: 'KN1A010'),
  MarkerData(markerId: 'Kuantan 11', position: const LatLng(3.81643, 103.3248), title: 'KN1A011'),
  MarkerData(markerId: 'Kuantan 12', position: const LatLng(3.81626, 103.3248), title: 'KN1A012'), 
  MarkerData(markerId: 'Kuantan 13', position: const LatLng(3.81603, 103.3249), title: 'KN1A013'),
  MarkerData(markerId: 'Kuantan 14', position: const LatLng(3.81561, 103.3250), title: 'KN1A014'),
  MarkerData(markerId: 'Kuantan 15', position: const LatLng(3.8154, 103.32486), title: 'KN1A015'),
];

// Machang markers
final List<MarkerData> machangMarkers = [
  MarkerData(markerId: '1', position: const LatLng(5.763803843129803, 102.21897902869294), title: 'M01A01'),
  MarkerData(markerId: '2', position: const LatLng(5.763818813227292, 102.21956742010521), title: 'M01A02'),
  MarkerData(markerId: '3', position: const LatLng(5.763785069345777, 102.22004412813598), title: 'M01A03'),
  MarkerData(markerId: '4', position: const LatLng(5.763744808339124, 102.22049723133854), title: 'M01A04'),
  MarkerData(markerId: '5', position: const LatLng(5.763721529409399, 102.22086931540885), title: 'M01A05'),
  MarkerData(markerId: '6', position: const LatLng(5.7643312272943055, 102.22089910874477), title: 'M01A06'),
  MarkerData(markerId: '7', position: const LatLng(5.764413887784301, 102.22069817524925), title: 'M01A07'),
  MarkerData(markerId: '8', position: const LatLng(5.764385574012039, 102.22043257573642), title: 'M01A08'),
  MarkerData(markerId: '9', position: const LatLng(5.764757461592429, 102.220346026662), title: 'M01A09'),
  MarkerData(markerId: '10', position: const LatLng(5.765038826222367, 102.22076587945025), title: 'M01A10'),
  MarkerData(markerId: '11', position: const LatLng(5.764698273688244, 102.22111586564156), title: 'M01A11'),
  MarkerData(markerId: '12', position: const LatLng(5.76515746350962, 102.22119370934293), title: 'M01A12'),
  MarkerData(markerId: '13', position: const LatLng(5.765465709639691, 102.22018099304186), title: 'M01A13'),
  MarkerData(markerId: '14', position: const LatLng(5.765220040044343, 102.21989570970076), title: 'M01A14'),
  MarkerData(markerId: '15', position: const LatLng(5.765038826222367, 102.21964931743118), title: 'M01A15'),
  MarkerData(markerId: '16', position: const LatLng(5.7655385513899535, 102.2188641520109), title: 'M01A16'),
  MarkerData(markerId: '17', position: const LatLng(5.76529237095787, 102.2187562162303), title: 'M01A17'),
  MarkerData(markerId: '18', position: const LatLng(5.765175805877257, 102.22076587945025), title: 'M01A18'),
  MarkerData(markerId: '19', position: const LatLng(5.764939943162268, 102.21869476233688), title: 'M01A19'),
  MarkerData(markerId: '20', position: const LatLng(5.7647045146522675, 102.21870749813718), title: 'M01A20'),
  MarkerData(markerId: '21', position: const LatLng(5.76436934930706, 102.21870602247171), title: 'M01A21'),
  MarkerData(markerId: '22', position: const LatLng(5.764112168505416, 102.21868785164818), title: 'M01A22'),
  MarkerData(markerId: '23', position: const LatLng(5.764145441792048, 102.2193583940832), title: 'M01A23'),
  MarkerData(markerId: '24', position: const LatLng(5.764456991457234, 102.21954504690328), title: 'M01A24'),
  MarkerData(markerId: '25', position: const LatLng(5.7644319249075275, 102.21997867866241), title: 'M01A25'),
  MarkerData(markerId: '26', position: const LatLng(5.764663352020778, 102.21935227863462), title: 'M01A26'),
  MarkerData(markerId: '27', position: const LatLng(5.765135379604262, 102.21936928028698), title: 'M01A27'),
  MarkerData(markerId: '28', position: const LatLng(5.764990563811925, 102.21806338503012), title: 'M01A28'),
  MarkerData(markerId: '29', position: const LatLng(5.764680896185914, 102.21838258169679), title: 'M01A29'),
  MarkerData(markerId: '30', position: const LatLng(5.7643627091849625, 102.21802432042806), title: 'M01A30'),
  MarkerData(markerId: '31', position: const LatLng(5.764081140767281, 102.21796779046315), title: 'M01A31'),
  MarkerData(markerId: '32', position: const LatLng(5.763936594086192, 102.21731381100196), title: 'M01A32'),
  MarkerData(markerId: '33', position: const LatLng(5.764367137826527, 102.21730069424468), title: 'M01A33'),
  MarkerData(markerId: '34', position: const LatLng(5.764683187414507, 102.21767626959894), title: 'M01A34'),
  MarkerData(markerId: '35', position: const LatLng(5.765067784689755, 102.21735435119416), title: 'M01A35'),
  MarkerData(markerId: '36', position: const LatLng(5.765360617250663, 102.21775332806155), title: 'M01A36'),
  MarkerData(markerId: '37', position: const LatLng(5.76540498144109, 102.21706521159382), title: 'M01A37'),
  MarkerData(markerId: '38', position: const LatLng(5.765124858514382, 102.21667659611403), title: 'M01A38'),
  MarkerData(markerId: '39', position: const LatLng(5.764778520547769, 102.21702987006675), title: 'M01A39'),
  MarkerData(markerId: '40', position: const LatLng(5.764310788299476, 102.21659714500025), title: 'M01A40'),
  MarkerData(markerId: '41', position: const LatLng(5.763914247215753, 102.22076587945025), title: 'M01A41'),
  MarkerData(markerId: '42', position: const LatLng(5.764267395301613, 102.21650864204781), title: 'M01A42'),
  MarkerData(markerId: '43', position: const LatLng(5.7645995157228604, 102.21608090695278), title: 'M01A43'),
  MarkerData(markerId: '44', position: const LatLng(5.764778127661865, 102.2164571733971), title: 'M01A44'),
  MarkerData(markerId: '45', position: const LatLng(5.76487890354224, 102.215491443462), title: 'M01A45'),
  MarkerData(markerId: '46', position: const LatLng(5.76487890354224, 102.215352150624), title: 'M01A46'),
  MarkerData(markerId: '47', position: const LatLng(5.764019530866661, 102.21518708384434), title: 'M01A47'),
];

// Kuala Terengganu markers
final List<MarkerData> kualaTerengganuMarkers = [
  MarkerData(markerId: 'KT 1', position: const LatLng(5.3368552971475385, 5.33685529714753), title: 'T01A01'),
  MarkerData(markerId: 'KT 2', position: const LatLng(5.336762133492594, 103.14036383376882), title: 'T01A02'),
  MarkerData(markerId: 'KT 3', position: const LatLng(5.336817525309835, 103.14125359895814), title: 'T01A03'),
  MarkerData(markerId: 'KT 4', position: const LatLng(5.33749101032912,  103.1411630446967), title: 'T01A04'),
  MarkerData(markerId: 'KT 5', position: const LatLng(5.336388108658947, 103.14232746353997), title: 'T01A05'),
  MarkerData(markerId: 'KT 6', position: const LatLng(5.336318153175863, 103.1411517720367), title: 'T01A06'),
  MarkerData(markerId: 'KT 7', position: const LatLng(5.336320104565953, 103.14104699031512), title: 'T01A07'),
  MarkerData(markerId: 'KT 8', position: const LatLng(5.335464256996351, 103.14102592786293), title: 'T01A08'),
  MarkerData(markerId: 'KT 9', position: const LatLng(5.335247469963514, 103.14080494228074), title: 'T01A09'),
  MarkerData(markerId: 'KT 10', position: const LatLng(5.33470517472539, 103.14080718846901), title: 'T01A10'),
];

List<Marker> createMarkers(List<MarkerData> markerDataList, BitmapDescriptor icon) {
  return markerDataList.map((data) {
    return Marker(
      markerId: MarkerId(data.markerId),
      position: data.position,
      infoWindow: InfoWindow(title: data.title),
      icon: icon,
    );
  }).toList();
}

// Create markers for Kuantan
List<Marker> kuantanMarkersList = createMarkers(kuantanMarkers, BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue));

// Create markers for Machang
List<Marker> machangMarkersList = createMarkers(machangMarkers, BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed));

// Create markers for Kuala Terengganu
List<Marker> kualaTerengganuMarkersList = createMarkers(kualaTerengganuMarkers, BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen));
