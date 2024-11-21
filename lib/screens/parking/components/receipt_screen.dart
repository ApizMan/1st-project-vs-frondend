import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_scale_tap/flutter_scale_tap.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ntp/ntp.dart';
import 'package:project/app/helpers/shared_preferences.dart';
import 'package:project/constant.dart';
import 'package:project/models/models.dart';
import 'package:project/routes/route_manager.dart';
import 'package:project/theme.dart';
import 'package:project/widget/primary_button.dart';
import 'package:printing/printing.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:url_launcher/url_launcher.dart';

class ReceiptScreen extends StatefulWidget {
  const ReceiptScreen({super.key});

  @override
  State<ReceiptScreen> createState() => _ReceiptScreenState();
}

class _ReceiptScreenState extends State<ReceiptScreen> {
  String _currentDate = ''; // Initialize variable for date
  final GlobalKey _printKey = GlobalKey(); // Key to capture the part to print
  late Map<dynamic, dynamic>? receipt;

  @override
  void initState() {
    receipt = {};
    super.initState();
    analyzeReceipt();
    Timer.periodic(const Duration(seconds: 1), (Timer t) => updateDateTime());
  }

  Future<void> analyzeReceipt() async {
    receipt = await SharedPreferencesHelper.getReceipt();
  }

  void updateDateTime() async {
    try {
      DateTime liveTime = await NTP.now(timeout: const Duration(seconds: 5));
      setState(() {
        _currentDate = liveTime.toString().split(' ')[0]; // Get current date
      });
    } catch (e) {
      // Fallback to local time in case of an error
      DateTime fallbackTime = DateTime.now();
      _currentDate = fallbackTime.toString().split(' ')[0]; // Get current date
    }
  }

  Future<void> _printScreen() async {
    try {
      RenderRepaintBoundary boundary =
          _printKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
      ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      ByteData? byteData =
          await image.toByteData(format: ui.ImageByteFormat.png);
      if (byteData != null) {
        final pngBytes = byteData.buffer.asUint8List();
        await Printing.layoutPdf(onLayout: (PdfPageFormat format) async {
          final doc = pw.Document();
          final image = pw.MemoryImage(pngBytes);
          doc.addPage(pw.Page(build: (pw.Context context) {
            return pw.Center(child: pw.Image(image));
          }));
          return doc.save();
        });
      }
    } catch (e) {
      e.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    final arguments =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;
    UserModel? userModel = arguments['userModel'] as UserModel?;
    Map<String, dynamic> details =
        arguments['locationDetail'] as Map<String, dynamic>;
    double amount = double.parse(arguments['amount']);
    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: AppBar(
        toolbarHeight: 100,
        foregroundColor: details['color'] == 4294961979 ? kBlack : kWhite,
        backgroundColor: Color(details['color']),
        centerTitle: true,
        title: Text(
          AppLocalizations.of(context)!.receipt,
          style: textStyleNormal(
            fontSize: 26,
            color: details['color'] == 4294961979 ? kBlack : kWhite,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: ScaleTap(
              onPressed: _printScreen,
              child: const Icon(
                Icons.print,
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: RepaintBoundary(
          key: _printKey,
          child: Padding(
            padding: const EdgeInsets.only(
                top: 50, left: 20, right: 20, bottom: 100),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                    child: Column(
                  children: [
                    const Icon(
                      Icons.check_circle,
                      color: Colors.green,
                      size: 30,
                    ),
                    const SizedBox(width: 15),
                    Text(
                      '${AppLocalizations.of(context)!.successful}!',
                      style: textStyleNormal(
                        fontWeight: FontWeight.bold,
                        fontSize: 30,
                      ),
                    ),
                  ],
                )),
                const SizedBox(height: 20),
                Row(
                  children: [
                    const SizedBox(height: 20),
                    Text(
                      AppLocalizations.of(context)!.receiptNo,
                      style: textStyleNormal(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(width: 50),
                    Expanded(
                      child: Text(
                        receipt?['noReceipt'] ?? '',
                        style: textStyleNormal(),
                        textAlign: TextAlign.right, // Align text to the right
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    const SizedBox(height: 20),
                    Text(
                      AppLocalizations.of(context)!.name,
                      style: textStyleNormal(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(width: 50),
                    Expanded(
                      child: Text(
                        '${userModel!.firstName} ${userModel.secondName}',
                        style: textStyleNormal(),
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
                      style: textStyleNormal(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(width: 50),
                    Expanded(
                      child: Text(
                        _currentDate,
                        style: textStyleNormal(),
                        textAlign: TextAlign.right, // Align text to the right
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Text(
                      AppLocalizations.of(context)!.startTime,
                      style: textStyleNormal(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(width: 50),
                    Expanded(
                      child: Text(
                        receipt?['startTime'] ?? '',
                        style: textStyleNormal(),
                        textAlign: TextAlign.right, // Align text to the right
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Text(
                      AppLocalizations.of(context)!.endTime,
                      style: textStyleNormal(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(width: 50),
                    Expanded(
                      child: Text(
                        receipt?['endTime'] ?? '',
                        style: textStyleNormal(),
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
                      style: textStyleNormal(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(width: 50),
                    Expanded(
                      child: Text(
                        receipt?['duration'] ?? '',
                        style: textStyleNormal(),
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
                      style: textStyleNormal(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(width: 50),
                    Expanded(
                      child: Text(
                        receipt?['plateNumber'] ?? '',
                        style: textStyleNormal(),
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
                      style: textStyleNormal(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(width: 50),
                    Expanded(
                      child: Text(
                        receipt?['location'] ?? '',
                        style: textStyleNormal(),
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
                      style: textStyleNormal(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(width: 50),
                    Expanded(
                      child: Text(
                        userModel.email!,
                        style: textStyleNormal(),
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
                      style: textStyleNormal(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(width: 50),
                    Expanded(
                      child: Text(
                        receipt?['type'] ?? '',
                        style: textStyleNormal(),
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
                      style: textStyleNormal(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(width: 50),
                    Expanded(
                      child: Text(
                        'RM ${amount.toStringAsFixed(2)}',
                        style: textStyleNormal(fontWeight: FontWeight.bold),
                        textAlign: TextAlign.right, // Align text to the right
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Center(
                  child: Text(
                    AppLocalizations.of(context)!.thankYou,
                    style: GoogleFonts.dmSans(
                      fontSize: 20,
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const Image(
                            width: 100,
                            image: AssetImage(logo),
                          ),
                          spaceVertical(height: 20),
                          RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: AppLocalizations.of(context)!
                                      .contactParking,
                                  style: textStyleNormal(color: kGrey),
                                ),
                                TextSpan(
                                  text: '03-4162 8672',
                                  style: textStyleNormal(color: kBgInfo),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () async {
                                      const phoneNumber = 'tel:0341628672';
                                      if (await canLaunchUrl(
                                          Uri.parse(phoneNumber))) {
                                        await launchUrl(Uri.parse(phoneNumber));
                                      } else {
                                        throw 'Could not launch $phoneNumber';
                                      }
                                    },
                                ),
                                TextSpan(
                                  text: AppLocalizations.of(context)!
                                      .emailParking,
                                  style: textStyleNormal(color: kGrey),
                                ),
                                TextSpan(
                                  text: Get.locale!.languageCode == 'en'
                                      ? '\ninfo@vista-summerose.com.my'
                                      : 'info@vista-summerose.com.my',
                                  style: textStyleNormal(color: kBgInfo),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () async {
                                      final email = Uri.parse(
                                          'mailto:info@vista-summerose.com.my');
                                      if (await canLaunchUrl(email)) {
                                        await launchUrl(email,
                                            mode:
                                                LaunchMode.externalApplication);
                                      } else {
                                        throw 'Could not launch $email';
                                      }
                                    },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 20.0),
                      height: 250,
                      width: 2,
                      decoration: const BoxDecoration(color: kGrey),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Image(
                            width: 50,
                            image: AssetImage(details['logo']),
                          ),
                          spaceVertical(height: 20),
                          Text(
                            AppLocalizations.of(context)!.actTitle,
                            style: textStyleNormal(
                              color: kGrey,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            AppLocalizations.of(context)!.actDesc,
                            style: textStyleNormal(
                              color: kGrey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: PrimaryButton(
        borderRadius: 10.0,
        buttonWidth: 0.8,
        onPressed: () {
          Navigator.pushNamedAndRemoveUntil(
              context, AppRoute.homeScreen, (context) => false);
        },
        label: Text(
          AppLocalizations.of(context)!.backToHome,
          style: textStyleNormal(
            color: kWhite,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
