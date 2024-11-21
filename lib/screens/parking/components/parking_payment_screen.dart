import 'dart:async';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ntp/ntp.dart';
import 'package:project/app/helpers/shared_preferences.dart';
import 'package:project/constant.dart';
import 'package:project/form_bloc/form_bloc.dart';
import 'package:project/theme.dart';
import 'package:project/widget/primary_button.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ParkingPaymentScreen extends StatefulWidget {
  const ParkingPaymentScreen({
    super.key,
  });

  @override
  State<ParkingPaymentScreen> createState() => _ParkingPaymentScreenState();
}

class _ParkingPaymentScreenState extends State<ParkingPaymentScreen> {
  //final double _value = 40.0;
  String _currentDate = '';
  String _currentTime = '';
  bool isCountdownActive = false;
  late String currentDuration;
  late String expiredDuration;

  @override
  void initState() {
    super.initState();
    Timer.periodic(const Duration(seconds: 1), (Timer t) => updateDateTime());
    analyzeParkingExpired();
  }

  void updateDateTime() async {
    try {
      DateTime liveTime = await NTP.now(timeout: const Duration(seconds: 5));
      setState(() {
        _currentDate = liveTime.toString().split(' ')[0]; // Get current date
        _currentTime = DateFormat('h:mm a').format(liveTime);
      });
    } catch (e) {
      // Fallback to local time in case of an error
      DateTime fallbackTime = DateTime.now();
      _currentDate = fallbackTime.toString().split(' ')[0]; // Get current date
      _currentTime = DateFormat('h:mm a').format(fallbackTime);
    }
  }

  Future<void> analyzeParkingExpired() async {
    currentDuration = await SharedPreferencesHelper.getParkingDuration();
    expiredDuration = await SharedPreferencesHelper.getParkingExpired();
  }

  @override
  Widget build(BuildContext context) {
    final arguments =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;
    String? parkingCar = arguments['selectedCarPlate'] as String?;
    String? duration = arguments['duration'] as String?;
    double amount = double.parse(arguments['amount']);
    Map<String, dynamic> details =
        arguments['locationDetail'] as Map<String, dynamic>;
    StoreParkingFormBloc? formBloc =
        arguments['formBloc'] as StoreParkingFormBloc;

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 100,
        foregroundColor: details['color'] == 4294961979 ? kBlack : kWhite,
        backgroundColor: Color(details['color']),
        centerTitle: true,
        title: Text(
          AppLocalizations.of(context)!.payment,
          style: textStyleNormal(
            fontSize: 26,
            color: details['color'] == 4294961979 ? kBlack : kWhite,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 50, left: 20, right: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              Row(
                children: [
                  Text(
                    AppLocalizations.of(context)!.date,
                    style: GoogleFonts.firaCode(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(width: 50),
                  Expanded(
                    child: Text(
                      _currentDate,
                      style: GoogleFonts.firaCode(),
                      textAlign: TextAlign.right, // Align text to the right
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Text(
                    AppLocalizations.of(context)!.time,
                    style: GoogleFonts.firaCode(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(width: 50),
                  Expanded(
                    child: Text(
                      _currentTime,
                      style: GoogleFonts.firaCode(),
                      textAlign: TextAlign.right, // Align text to the right
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Text(
                    AppLocalizations.of(context)!.location,
                    style: GoogleFonts.firaCode(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(width: 50),
                  Expanded(
                    child: Text(
                      formBloc.pbt.value!,
                      style: GoogleFonts.firaCode(),
                      textAlign: TextAlign.right, // Align text to the right
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Text(
                    AppLocalizations.of(context)!.plateNumber,
                    style: GoogleFonts.firaCode(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(width: 50),
                  Expanded(
                    child: Text(
                      parkingCar!.split('-')[0],
                      style: GoogleFonts.firaCode(),
                      textAlign: TextAlign.right, // Align text to the right
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Text(
                    AppLocalizations.of(context)!.duration,
                    style: GoogleFonts.firaCode(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(width: 50),
                  Expanded(
                    child: Text(
                      duration!,
                      style: GoogleFonts.firaCode(),
                      textAlign: TextAlign.right, // Align text to the right
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Text(
                    AppLocalizations.of(context)!.description,
                    style: GoogleFonts.firaCode(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(width: 50),
                  Expanded(
                    child: Text(
                      AppLocalizations.of(context)!.parking,
                      style: GoogleFonts.firaCode(),
                      textAlign: TextAlign.right, // Align text to the right
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Text(
                    AppLocalizations.of(context)!.total,
                    style: GoogleFonts.firaCode(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(width: 50),
                  Expanded(
                    child: Text(
                      'RM ${amount.toStringAsFixed(2)}',
                      style: GoogleFonts.firaCode(fontWeight: FontWeight.bold),
                      textAlign: TextAlign.right, // Align text to the right
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 40),
              Center(
                child: Text(
                  AppLocalizations.of(context)!.paymentDesc,
                  style: GoogleFonts.firaCode(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 100),
              Center(
                child: PrimaryButton(
                  onPressed: () async {
                    // Get current date and time
                    DateTime now = await NTP.now();

                    setState(() {
                      formBloc.amount.updateValue(amount.toStringAsFixed(2));

                      final receiptNo = generateReceiptNumber();

                      if (expiredDuration != '') {
                        // Add duration to current time
                        DateTime newTime = now
                            .add(parseDuration(duration))
                            .add(parseDuration(currentDuration));

                        SharedPreferencesHelper.setReceipt(
                          noReceipt: receiptNo,
                          startTime: DateFormat('hh:mm:ss a')
                              .format(now.add(parseDuration(currentDuration))),
                          endTime: DateFormat('hh:mm:ss a').format(newTime),
                          duration: duration,
                          location: formBloc.pbt.value,
                          plateNumber: parkingCar.split('-')[0],
                          type: AppLocalizations.of(context)!.parking,
                        );

                        // Format the new time as an ISO 8601 timestamp
                        String formattedTimestamp =
                            newTime.toUtc().toIso8601String();

                        formBloc.noReceipt.updateValue(receiptNo);
                        formBloc.expiredAt.updateValue(formattedTimestamp);
                      } else {
                        // Add duration to current time
                        DateTime newTime = now.add(parseDuration(duration));

                        SharedPreferencesHelper.setReceipt(
                          noReceipt: receiptNo,
                          startTime: _currentTime,
                          endTime: DateFormat('hh:mm:ss a').format(newTime),
                          duration: duration,
                          location: formBloc.pbt.value,
                          plateNumber: parkingCar.split('-')[0],
                          type: AppLocalizations.of(context)!.parking,
                        );

                        // Format the new time as an ISO 8601 timestamp
                        String formattedTimestamp =
                            newTime.toUtc().toIso8601String();

                        formBloc.noReceipt.updateValue(receiptNo);
                        formBloc.expiredAt.updateValue(formattedTimestamp);

                        SharedPreferencesHelper.setParkingDuration(
                            duration: duration);
                      }

                      formBloc.submit();
                    });
                  },
                  label: Text(
                    AppLocalizations.of(context)!.pay,
                    style: textStyleNormal(
                        color: kWhite, fontWeight: FontWeight.bold),
                  ),
                  color: kPrimaryColor,
                  borderRadius: 10.0,
                  buttonWidth: 0.8,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
