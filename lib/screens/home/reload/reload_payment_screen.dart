import 'dart:async';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ntp/ntp.dart';
import 'package:project/app/helpers/shared_preferences.dart';
import 'package:project/constant.dart';
import 'package:project/form_bloc/form_bloc.dart';
import 'package:project/models/models.dart';
import 'package:project/theme.dart';
import 'package:project/widget/primary_button.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ReloadPaymentScreen extends StatefulWidget {
  const ReloadPaymentScreen({super.key});

  @override
  State<ReloadPaymentScreen> createState() => _ReloadPaymentScreenState();
}

class _ReloadPaymentScreenState extends State<ReloadPaymentScreen> {
  String _currentDate = ''; // Initialize variable for date
  String _currentTime = '';
  // ignore: unused_field
  String? _qrCodeUrl;
  String? shortcutLink;

  @override
  void initState() {
    super.initState();
    Timer.periodic(const Duration(seconds: 1), (Timer t) => updateDateTime());
  }

  void updateDateTime() async {
    DateTime liveTime = await NTP.now();
    setState(() {
      _currentDate = liveTime.toString().split(' ')[0]; // Get current date
      _currentTime = DateFormat('h:mm:ss a').format(liveTime);
    });
  }

  @override
  Widget build(BuildContext context) {
    final arguments =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;
    Map<String, dynamic> details =
        arguments['locationDetail'] as Map<String, dynamic>;
    UserModel? userModel = arguments['userModel'] as UserModel?;
    ReloadFormBloc? formBloc = arguments['formBloc'] as ReloadFormBloc;
    return Scaffold(
      backgroundColor: kBackgroundColor,
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
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: PrimaryButton(
        borderRadius: 10.0,
        buttonWidth: 0.8,
        onPressed: () async {
          await SharedPreferencesHelper.setTime(
              startTime: _currentTime, endTime: '');
          formBloc.submit();
          // Navigator.pushNamed(
          //   context,
          //   AppRoute.reloadReceiptScreen,
          //   arguments: {
          //     'locationDetail': details,
          //     'userModel': userModel,
          //     'amount': double.parse("40"),
          //   },
          // );
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
              Row(
                children: [
                  const SizedBox(height: 20),
                  Text(
                    AppLocalizations.of(context)!.name,
                    style: GoogleFonts.firaCode(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(width: 50),
                  Expanded(
                    child: Text(
                      '${userModel!.firstName} ${userModel.secondName}',
                      style: GoogleFonts.firaCode(),
                      textAlign: TextAlign.right, // Align text to the right
                    ),
                  )
                ],
              ),
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
                    AppLocalizations.of(context)!.email,
                    style: GoogleFonts.firaCode(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(width: 50),
                  Expanded(
                    child: Text(
                      userModel.email!,
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
                      AppLocalizations.of(context)!.token,
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
                      'RM ${double.parse(formBloc.amount.value).toStringAsFixed(2)}',
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
                  itemBuilder: (context, item) {
                    bool isSelected = formBloc.paymentMethod.value == item;
                    return FieldItem(
                      child: GestureDetector(
                        onTap: () => formBloc.paymentMethod.updateValue(item),
                        child: Container(
                          width: item == 'QR' ? 80 : 120,
                          height: 80,
                          decoration: BoxDecoration(
                            color: isSelected
                                ? Colors.blue.withOpacity(0.2)
                                : Colors.transparent,
                            border: isSelected
                                ? Border.all(color: Colors.blue, width: 2)
                                : null,
                            image: DecorationImage(
                              image: AssetImage(
                                item == 'QR'
                                    ? 'assets/images/duitnow.png'
                                    : 'assets/images/fpx.png',
                              ),
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
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
      ),
    );
  }
}
