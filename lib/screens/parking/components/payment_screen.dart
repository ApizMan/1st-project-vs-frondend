import 'dart:async';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project/constant.dart';
import 'package:project/form_bloc/form_bloc.dart';
import 'package:project/theme.dart';
import 'package:project/widget/primary_button.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({
    super.key,
  });

  @override
  State<PaymentScreen> createState() => _PaymentsppkScreenState();
}

class _PaymentsppkScreenState extends State<PaymentScreen> {
  //final double _value = 40.0;
  String _currentDate = '';
  String _currentTime = '';

  @override
  void initState() {
    super.initState();
    Timer.periodic(const Duration(seconds: 1), (Timer t) => updateDateTime());
  }

  void updateDateTime() {
    setState(() {
      _currentDate =
          DateTime.now().toString().split(' ')[0]; // Get current date
      _currentTime = DateFormat('h:mm:ss a').format(DateTime.now());
    });
  }

  @override
  Widget build(BuildContext context) {
    final arguments =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;
    String? parkingCar = arguments['selectedCarPlate'] as String?;
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
            'Payment',
            style: textStyleNormal(
              fontSize: 26,
              color: kWhite,
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
                      "Date",
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
                      'Time',
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
                      'Location',
                      style: GoogleFonts.firaCode(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(width: 50),
                    Expanded(
                      child: Text(
                        'Majlis Bandaraya Kuantan',
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
                      'Number Plate',
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
                      'Duration',
                      style: GoogleFonts.firaCode(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(width: 50),
                    Expanded(
                      child: Text(
                        GlobalDeclaration.globalDuration,
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
                      'Description',
                      style: GoogleFonts.firaCode(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(width: 50),
                    Expanded(
                      child: Text(
                        'Parking',
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
                      'Total',
                      style: GoogleFonts.firaCode(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(width: 50),
                    Expanded(
                      child: Text(
                        'RM ${amount.toStringAsFixed(2)}',
                        style:
                            GoogleFonts.firaCode(fontWeight: FontWeight.bold),
                        textAlign: TextAlign.right, // Align text to the right
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 40),
                Center(
                  child: Text(
                    'Please Pay and Park Responsibly',
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
                    onPressed: () {
                      setState(() {
                        formBloc.amount.updateValue(amount.toStringAsFixed(2));
                        formBloc.submit();
                      });

                      // Navigator.of(context).push(
                      //   MaterialPageRoute(
                      //     builder: (context) =>
                      //         ReceiptScreen(userProfile: userModel),
                      //   ),
                      // );
                    },
                    label: Text(
                      'PAY',
                      style: GoogleFonts.nunitoSans(color: Colors.white),
                    ),
                    color: kPrimaryColor,
                    borderRadius: 10.0,
                    buttonWidth: 0.8,
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
