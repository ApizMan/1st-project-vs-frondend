import 'dart:async';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
//import 'package:project/component/generate_qr.dart';
import 'package:project/constant.dart';
import 'package:project/form_bloc/form_bloc.dart';
import 'package:project/models/models.dart';
import 'package:project/routes/route_manager.dart';
import 'package:project/theme.dart';
import 'package:project/widget/loading_dialog.dart';
import 'package:project/widget/primary_button.dart';

class SummonsPaymentScreen extends StatefulWidget {
  const SummonsPaymentScreen({super.key});

  @override
  State<SummonsPaymentScreen> createState() => _ReloadPaymentScreenState();
}

class _ReloadPaymentScreenState extends State<SummonsPaymentScreen> {
  String _currentDate = ''; // Initialize variable for date
  String _currentTime = '';
  // ignore: unused_field
  String? _qrCodeUrl;
  String? shortcutLink;
  CompoundFormBloc? formBloc;

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
    Map<String, dynamic> details =
        arguments['locationDetail'] as Map<String, dynamic>;
    UserModel? userModel = arguments['userModel'] as UserModel?;
    return BlocProvider(
      create: (context) => CompoundFormBloc(
        model: userModel!,
      ),
      child: Builder(builder: (context) {
        formBloc = BlocProvider.of<CompoundFormBloc>(context);
        return FormBlocListener<CompoundFormBloc, String, String>(
          onSubmitting: (context, state) {
            LoadingDialog.show(context);
          },
          onSubmissionFailed: (context, state) => LoadingDialog.hide(context),
          onSuccess: (context, state) async {
            LoadingDialog.hide(context);

            // final payment = await SharedPreferencesHelper.getPayment();

            // if (payment == 'FPX') {
            //   Navigator.push(
            //     context,
            //     MaterialPageRoute(
            //       builder: (context) =>
            //           WebViewPage(url: state.successResponse!),
            //     ),
            //   );
            // } else {
            //   Navigator.of(context).push(
            //     MaterialPageRoute(
            //       builder: (context) =>
            //           QrCodeScreen(qrCodeUrl: state.successResponse!),
            //     ),
            //   );
            // }

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.successResponse!),
              ),
            );
          },
          onFailure: (context, state) {
            LoadingDialog.hide(context);

            Navigator.pushNamed(context, AppRoute.reloadReceiptScreen,
                arguments: {
                  'locationDetail': details,
                  'userModel': userModel,
                });

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.failureResponse!),
              ),
            );
          },
          child: Scaffold(
            backgroundColor: kBackgroundColor,
            appBar: AppBar(
              toolbarHeight: 100,
              foregroundColor: details['color'] == 4294961979 ? kBlack : kWhite,
              backgroundColor: Color(details['color']),
              centerTitle: true,
              title: Text(
                'Payment',
                style: textStyleNormal(
                  fontSize: 26,
                  color: details['color'] == 4294961979 ? kBlack : kWhite,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
            floatingActionButton: PrimaryButton(
              borderRadius: 10.0,
              buttonWidth: 0.8,
              onPressed: () {
                formBloc!.submit();
                Navigator.pushNamed(context, AppRoute.summonsReceiptScreen,
                    arguments: {
                      'locationDetail': details,
                      'userModel': userModel,
                    });
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
                    Row(
                      children: [
                        Text(
                          "Date",
                          style:
                              GoogleFonts.firaCode(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(width: 50),
                        Expanded(
                          child: Text(
                            _currentDate,
                            style: GoogleFonts.firaCode(),
                            textAlign:
                                TextAlign.right, // Align text to the right
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Text(
                          'Time',
                          style:
                              GoogleFonts.firaCode(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(width: 50),
                        Expanded(
                          child: Text(
                            _currentTime,
                            style: GoogleFonts.firaCode(),
                            textAlign:
                                TextAlign.right, // Align text to the right
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Text(
                          'Notice Number',
                          style:
                              GoogleFonts.firaCode(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(width: 50),
                        Expanded(
                          child: Text(
                            'KH14680548983',
                            style: GoogleFonts.firaCode(),
                            textAlign:
                                TextAlign.right, // Align text to the right
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Text(
                          'Type of Offences',
                          style:
                              GoogleFonts.firaCode(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(width: 50),
                        Expanded(
                          child: Text(
                            'Double Park',
                            style: GoogleFonts.firaCode(),
                            textAlign:
                                TextAlign.right, // Align text to the right
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Text(
                          'Number Plate',
                          style:
                              GoogleFonts.firaCode(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(width: 50),
                        Expanded(
                          child: Text(
                            'ABC1234',
                            style: GoogleFonts.firaCode(),
                            textAlign:
                                TextAlign.right, // Align text to the right
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Text(
                          'Compound Rate',
                          style:
                              GoogleFonts.firaCode(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(width: 50),
                        Expanded(
                          child: Text(
                            'RM 100',
                            style: GoogleFonts.firaCode(),
                            textAlign:
                                TextAlign.right, // Align text to the right
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Text(
                          'Issued By',
                          style:
                              GoogleFonts.firaCode(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(width: 50),
                        Expanded(
                          child: Text(
                            '${userModel!.firstName!} ${userModel.secondName!}',
                            style: GoogleFonts.firaCode(),
                            textAlign:
                                TextAlign.right, // Align text to the right
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 40),
                    Center(
                      child: Text(
                        'Please make payment before this date',
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
                        selectFieldBloc: formBloc!.paymentMethod,
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
                                        image: AssetImage(
                                            'assets/images/duitnow.png'),
                                        fit: BoxFit.contain),
                                  ),
                                )
                              : Container(
                                  width: 120,
                                  height: 80,
                                  decoration: const BoxDecoration(
                                    image: DecorationImage(
                                        image:
                                            AssetImage('assets/images/fpx.png'),
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
                          const SizedBox(
                              width: 5), // Jarak antara ikon dan teks
                          Flexible(
                            child: Text(
                              'You will be bring to 3rd Party website for Reload Token. Please ensure the detail above is accurate.',
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
          ),
        );
      }),
    );
  }
}
