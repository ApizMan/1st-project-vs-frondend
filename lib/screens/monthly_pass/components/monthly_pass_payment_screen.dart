import 'dart:async';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project/app/helpers/shared_preferences.dart';
import 'package:project/constant.dart';
import 'package:project/form_bloc/form_bloc.dart';
import 'package:project/models/models.dart';
import 'package:project/theme.dart';
import 'package:project/widget/primary_button.dart';

class MonthlyPassPaymentScreen extends StatefulWidget {
  const MonthlyPassPaymentScreen({
    super.key,
  });

  @override
  State<MonthlyPassPaymentScreen> createState() =>
      _MonthlyPassPaymentScreenState();
}

class _MonthlyPassPaymentScreenState extends State<MonthlyPassPaymentScreen> {
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
    String? duration = arguments['duration'] as String?;
    double? amount = double.parse(arguments['amount']);
    Map<String, dynamic> details =
        arguments['locationDetail'] as Map<String, dynamic>;
    MonthlyPassFormBloc? formBloc =
        arguments['formBloc'] as MonthlyPassFormBloc;
    MonthlyPassModel? model =
        arguments['monthlyPassModel'] as MonthlyPassModel?;

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
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: PrimaryButton(
          borderRadius: 10.0,
          buttonWidth: 0.8,
          onPressed: () async {
            formBloc.submit();

            model!.duration = duration;
            model.amount = amount.toString();
            model.location = formBloc.location.value;
            model.pbt = formBloc.pbt.value;
            model.plateNumber = parkingCar;

            await SharedPreferencesHelper.setReloadAmount(
              amount: amount,
              carPlate: parkingCar!,
              monthlyDuration: duration!,
            );
          },
          label: Text(
            'PAY',
            style: GoogleFonts.nunitoSans(color: Colors.white),
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
                      'Number Plate',
                      style: GoogleFonts.firaCode(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(width: 50),
                    Expanded(
                      child: Text(
                        parkingCar!,
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
                const SizedBox(height: 15),
                const Divider(
                  color: Colors.black,
                  thickness: 1.0,
                ),
                const SizedBox(height: 15),
                SizedBox(
                  height: 150,
                  child: RadioButtonGroupFieldBlocBuilder<String>(
                    padding: EdgeInsets.zero,
                    canTapItemTile: true,
                    groupStyle: const FlexGroupStyle(
                      direction: Axis.horizontal,
                    ),
                    selectFieldBloc: formBloc.paymentMethod,
                    decoration: InputDecoration(
                      labelText: 'Payment Method',
                      labelStyle: textStyleNormal(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    itemBuilder: (context, item) => FieldItem(
                      child: item == 'QR'
                          ? Container(
                              width: 80,
                              height: 80,
                              decoration: const BoxDecoration(
                                image: DecorationImage(
                                    image:
                                        AssetImage('assets/images/duitnow.png'),
                                    fit: BoxFit.contain),
                              ),
                            )
                          : Container(
                              width: 120,
                              height: 80,
                              decoration: const BoxDecoration(
                                image: DecorationImage(
                                    image: AssetImage('assets/images/fpx.png'),
                                    fit: BoxFit.contain),
                              ),
                            ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
