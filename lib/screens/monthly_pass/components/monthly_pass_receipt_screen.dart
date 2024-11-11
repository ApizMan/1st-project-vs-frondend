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
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:project/routes/route_manager.dart';
import 'package:project/theme.dart';
import 'dart:ui' as ui;
import 'package:pdf/widgets.dart' as pw;
import 'package:project/widget/loading_dialog.dart';
import 'package:project/widget/primary_button.dart';
import 'package:url_launcher/url_launcher.dart';

class MonthlyPassReceiptScreen extends StatefulWidget {
  const MonthlyPassReceiptScreen({
    super.key,
  });

  @override
  State<MonthlyPassReceiptScreen> createState() =>
      _MonthlyPassReceiptScreenState();
}

class _MonthlyPassReceiptScreenState extends State<MonthlyPassReceiptScreen> {
  final GlobalKey _printKey = GlobalKey(); // Key to capture the part to print

  late Future<Map<dynamic, dynamic>> _receiptFuture;

  @override
  void initState() {
    super.initState();
    _receiptFuture = analyzeReceipt();
  }

  Future<Map<dynamic, dynamic>> analyzeReceipt() async {
    // Await for the receipt data to be fetched
    return await SharedPreferencesHelper.getReceipt() ?? {};
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
    double? amount = arguments['amount'] as double?;

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
        leading: IconButton(
          onPressed: () {
            Navigator.popUntil(
              context,
              ModalRoute.withName(AppRoute.monthlyPassScreen),
            );
          },
          icon: const Icon(
            Icons.arrow_back,
            color: kWhite,
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
      body: FutureBuilder<Map<dynamic, dynamic>>(
        future: _receiptFuture,
        builder: (context, snapshot) {
          // If the data is still loading, show a loading indicator
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          // If there was an error while fetching the data
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          // If the data is fetched successfully
          if (snapshot.hasData) {
            Map receipt = snapshot.data!;

            return SingleChildScrollView(
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
                        ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          Text(
                            AppLocalizations.of(context)!.receiptNo,
                            style: textStyleNormal(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(width: 50),
                          Expanded(
                            child: Text(
                              receipt['noReceipt'] ?? '',
                              style: textStyleNormal(),
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
                            AppLocalizations.of(context)!.startTime,
                            style: textStyleNormal(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(width: 50),
                          Expanded(
                            child: Text(
                              receipt['startTime'] ?? '',
                              style: textStyleNormal(),
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
                            AppLocalizations.of(context)!.endTime,
                            style: textStyleNormal(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(width: 50),
                          Expanded(
                            child: Text(
                              receipt['endTime'] ?? '',
                              style: textStyleNormal(),
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
                            AppLocalizations.of(context)!.duration,
                            style: textStyleNormal(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(width: 50),
                          Expanded(
                            child: Text(
                              receipt['duration'] ?? '',
                              style: textStyleNormal(),
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
                            AppLocalizations.of(context)!.plateNumber,
                            style: textStyleNormal(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(width: 50),
                          Expanded(
                            child: Text(
                              receipt['plateNumber'] ?? '',
                              style: textStyleNormal(),
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
                            AppLocalizations.of(context)!.location,
                            style: textStyleNormal(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(width: 50),
                          Expanded(
                            child: Text(
                              receipt['location'] ?? '',
                              style: textStyleNormal(),
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
                            AppLocalizations.of(context)!.description,
                            style: textStyleNormal(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(width: 50),
                          Expanded(
                            child: Text(
                              receipt['type'] ?? '',
                              style: textStyleNormal(),
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
                            AppLocalizations.of(context)!.total,
                            style: textStyleNormal(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(width: 50),
                          Expanded(
                            child: Text(
                              amount!.toStringAsFixed(2),
                              style:
                                  textStyleNormal(fontWeight: FontWeight.bold),
                              textAlign:
                                  TextAlign.right, // Align text to the right
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
                                            .contactMonthlyPass,
                                        style: textStyleNormal(color: kGrey),
                                      ),
                                      TextSpan(
                                        text: '03-4162 8672',
                                        style: textStyleNormal(color: kBgInfo),
                                        recognizer: TapGestureRecognizer()
                                          ..onTap = () async {
                                            const phoneNumber =
                                                'tel:0341628672';
                                            if (await canLaunchUrl(
                                                Uri.parse(phoneNumber))) {
                                              await launchUrl(
                                                  Uri.parse(phoneNumber));
                                            } else {
                                              throw 'Could not launch $phoneNumber';
                                            }
                                          },
                                      ),
                                      TextSpan(
                                        text: AppLocalizations.of(context)!
                                            .emailMonthlyPass,
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
                                                  mode: LaunchMode
                                                      .externalApplication);
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
                            margin:
                                const EdgeInsets.symmetric(horizontal: 20.0),
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
            );
          }

          // In case data is not available
          return const LoadingDialog();
        },
      ),
    );
  }
}
