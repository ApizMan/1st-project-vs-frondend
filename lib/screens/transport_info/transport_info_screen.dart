import 'package:flutter/material.dart';
import 'package:project/constant.dart';
import 'package:project/screens/screens.dart';
import 'package:project/theme.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class TransportInfoScreen extends StatefulWidget {
  const TransportInfoScreen({super.key});

  @override
  State<TransportInfoScreen> createState() => _TransportInfoScreenState();
}

class _TransportInfoScreenState extends State<TransportInfoScreen> {
  late bool showMeter;

  @override
  void initState() {
    super.initState();
    showMeter = true;
  }

  @override
  Widget build(BuildContext context) {
    final arguments =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;

    Map<String, dynamic> details =
        arguments['locationDetail'] as Map<String, dynamic>;

    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.miniStartFloat,
      floatingActionButton: FloatingActionButton(
        backgroundColor: showMeter ? Color(details['color']) : kWhite,
        onPressed: () {
          setState(() {
            showMeter = !showMeter; // Toggle showMeter
          });
        },
        child: Image.asset(
          METER_ICON,
          height: 45,
        ),
      ),
      backgroundColor: kBackgroundColor,
      appBar: AppBar(
        toolbarHeight: 100,
        foregroundColor: details['color'] == 4294961979 ? kBlack : kWhite,
        backgroundColor: Color(details['color']),
        centerTitle: true,
        title: Text(
          AppLocalizations.of(context)!.transportInfo,
          style: textStyleNormal(
            fontSize: 26,
            color: details['color'] == 4294961979 ? kBlack : kWhite,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: TransportInfoBody(
        showMeter: showMeter, // Pass the updated showMeter value here
      ),
    );
  }
}
