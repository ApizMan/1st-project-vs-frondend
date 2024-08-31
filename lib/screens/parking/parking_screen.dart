import 'package:flutter/material.dart';
import 'package:project/constant.dart';
import 'package:project/models/models.dart';
import 'package:project/screens/screens.dart';
import 'package:project/theme.dart';

class ParkingScreen extends StatefulWidget {
  const ParkingScreen({super.key});

  @override
  State<ParkingScreen> createState() => _ParkingScreenState();
}

class _ParkingScreenState extends State<ParkingScreen> {
  @override
  Widget build(BuildContext context) {
    final arguments =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;

    Map<String, dynamic> details =
        arguments['locationDetail'] as Map<String, dynamic>;
    UserModel? userModel = arguments['userModel'] as UserModel?;
    List<PlateNumberModel>? plateNumbers =
        arguments['plateNumbers'] as List<PlateNumberModel>?;
    List<PBTModel>? pbtModel = arguments['pbtModel'] as List<PBTModel>?;

    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: AppBar(
        toolbarHeight: 100,
        foregroundColor: details['color'] == 4294961979 ? kBlack : kWhite,
        backgroundColor: Color(details['color']),
        centerTitle: true,
        title: Column(
          children: [
            Text(
              'Parking',
              style: textStyleNormal(
                fontSize: 26,
                color: details['color'] == 4294961979 ? kBlack : kWhite,
                fontWeight: FontWeight.bold,
              ),
            ),
            spaceVertical(height: 5.0),
            Text(
              'OnStreet',
              style: textStyleNormal(
                color: details['color'] == 4294961979 ? kBlack : kWhite,
              ),
            ),
          ],
        ),
      ),
      body: ParkingBodyScreen(
        userModel: userModel!,
        carPlates: plateNumbers!,
        pbtModel: pbtModel!,
        details: details,
      ),
    );
  }
}
