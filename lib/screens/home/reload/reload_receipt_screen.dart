// ignore_for_file: deprecated_member_use

import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_scale_tap/flutter_scale_tap.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:project/app/helpers/shared_preferences.dart';
import 'package:project/constant.dart';
import 'package:project/models/models.dart';
import 'package:project/routes/route_manager.dart';
import 'package:project/theme.dart';
import 'dart:ui' as ui;
import 'package:pdf/widgets.dart' as pw;
import 'package:project/widget/primary_button.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:url_launcher/url_launcher.dart';

class ReloadReceiptScreen extends StatefulWidget {
  const ReloadReceiptScreen({
    super.key,
  });

  @override
  State<ReloadReceiptScreen> createState() => _ReloadReceiptScreenState();
}

class _ReloadReceiptScreenState extends State<ReloadReceiptScreen> {
  String _currentDate = ''; // Initialize variable for date
  String _currentTime = '';
  final GlobalKey _printKey = GlobalKey(); // Key to capture the part to print

  @override
  void initState() {
    super.initState();
    analyzeTime();
    Timer.periodic(const Duration(seconds: 1), (Timer t) => updateDateTime());
  }

  void updateDateTime() {
    setState(() {
      _currentDate =
          DateTime.now().toString().split(' ')[0]; // Get current date
    });
  }

  Future<void> analyzeTime() async {
    _currentTime = (await SharedPreferencesHelper.getStartTime())!;
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

    Map<String, dynamic> details =
        arguments['locationDetail'] as Map<String, dynamic>;
    UserModel? userModel = arguments['userModel'] as UserModel?;
    double amount = arguments['amount'] as double;
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
            color: kWhite,
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
      body: SingleChildScrollView(
        child: RepaintBoundary(
          key: _printKey,
          child: Padding(
            padding: const EdgeInsets.only(top: 100, left: 20, right: 20),
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
                      AppLocalizations.of(context)!.time,
                      style: textStyleNormal(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(width: 50),
                    Expanded(
                      child: Text(
                        _currentTime,
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
                        AppLocalizations.of(context)!.reload,
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
                        amount.toStringAsFixed(2),
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
                Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      const Image(
                        width: 100,
                        image: AssetImage(logo),
                      ),
                      spaceVertical(height: 20),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 40),
                        child: RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text:
                                    AppLocalizations.of(context)!.contactReload,
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
                                text: AppLocalizations.of(context)!.emailReload,
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
                                          mode: LaunchMode.externalApplication);
                                    } else {
                                      throw 'Could not launch $email';
                                    }
                                  },
                              ),
                            ],
                          ),
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
  }
}
