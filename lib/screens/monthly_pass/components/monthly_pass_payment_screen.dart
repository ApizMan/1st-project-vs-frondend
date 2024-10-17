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
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
    PromotionMonthlyPassModel? promotionModel =
        arguments['promotionModel'] as PromotionMonthlyPassModel?;

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
            model.promotionId = promotionModel!.id;

            await SharedPreferencesHelper.setReloadAmount(
              amount: amount,
              carPlate: parkingCar!,
              monthlyDuration: duration!,
            );
          },
          label: Text(
            AppLocalizations.of(context)!.pay,
            style: textStyleNormal(color: kWhite, fontWeight: FontWeight.bold),
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
                        AppLocalizations.of(context)!.monthlyPass,
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
                    AppLocalizations.of(context)!.paymentDesc,
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
                      labelText: AppLocalizations.of(context)!.paymentMethod,
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
                const SizedBox(height: 15),
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.error_outline, // Icon yang ingin Anda gunakan
                        color: Colors.red, // Warna ikon
                      ),
                      const SizedBox(height: 50),
                      const SizedBox(width: 5), // Jarak antara ikon dan teks
                      Flexible(
                        child: Text(
                          AppLocalizations.of(context)!.paymentDesc2,
                          style: GoogleFonts.firaCode(
                            color: Colors.red,
                            fontSize: 12,
                          ),
                          textAlign: TextAlign.justify,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
