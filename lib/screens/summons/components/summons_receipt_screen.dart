import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_scale_tap/flutter_scale_tap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:project/constant.dart';
import 'package:project/models/models.dart';
import 'package:project/routes/route_manager.dart';
import 'package:project/theme.dart';
import 'dart:ui' as ui;
import 'package:pdf/widgets.dart' as pw;
import 'package:project/widget/primary_button.dart';

class SummonsReceiptScreen extends StatefulWidget {
  const SummonsReceiptScreen({
    super.key,
  });

  @override
  State<SummonsReceiptScreen> createState() => _SummonsReceiptScreenState();
}

class _SummonsReceiptScreenState extends State<SummonsReceiptScreen> {
  String _currentDate = ''; // Initialize variable for date
  String _currentTime = '';
  final GlobalKey _printKey = GlobalKey(); // Key to capture the part to print

  @override
  void initState() {
    super.initState();
    Timer.periodic(const Duration(seconds: 1), (Timer t) => updateDateTime());
  }

  void updateDateTime() {
    setState(() {
      _currentDate =
          DateTime.now().toString().split(' ')[0]; // Get current date
      _currentTime = DateFormat('h:mm a').format(DateTime.now());
    });
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
    List<SummonModel>? selectedSummons =
        arguments['selectedSummons'] as List<SummonModel>?;
    double? totalAmount = arguments['totalAmount'] as double?;
    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: AppBar(
        toolbarHeight: 100,
        foregroundColor: details['color'] == 4294961979 ? kBlack : kWhite,
        backgroundColor: Color(details['color']),
        centerTitle: true,
        title: Text(
          'Receipt',
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
          'Back To Home',
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
          child: SingleChildScrollView(
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
                        'Successful!',
                        style: textStyleNormal(
                          fontWeight: FontWeight.bold,
                          fontSize: 30,
                        ),
                      ),
                    ],
                  )),
                  const SizedBox(height: 10),
                  ListView.builder(
                      itemCount: selectedSummons!.length,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        return Container(
                          margin: const EdgeInsets.only(top: 20),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20.0, vertical: 20.0),
                          decoration: BoxDecoration(
                            color: kWhite,
                            borderRadius: BorderRadius.circular(8.0),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                            border: Border.all(
                              color: Colors.grey.withOpacity(0.3),
                              width: 1,
                            ),
                          ),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Text(
                                    'Receipt No.',
                                    style: textStyleNormal(
                                        fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(width: 50),
                                  Expanded(
                                    child: Text(
                                      'RC-${selectedSummons[index].noticeNo}',
                                      style: textStyleNormal(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                      textAlign: TextAlign
                                          .right, // Align text to the right
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Row(
                                children: [
                                  Text(
                                    'Date',
                                    style: textStyleNormal(
                                        fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(width: 50),
                                  Expanded(
                                    child: Text(
                                      _currentDate,
                                      style: textStyleNormal(),
                                      textAlign: TextAlign
                                          .right, // Align text to the right
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Row(
                                children: [
                                  Text(
                                    'Time',
                                    style: textStyleNormal(
                                        fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(width: 50),
                                  Expanded(
                                    child: Text(
                                      _currentTime,
                                      style: textStyleNormal(),
                                      textAlign: TextAlign
                                          .right, // Align text to the right
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Row(
                                children: [
                                  Text(
                                    'Notice Number',
                                    style: textStyleNormal(
                                        fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(width: 50),
                                  Expanded(
                                    child: Text(
                                      selectedSummons[index].noticeNo!,
                                      style: textStyleNormal(),
                                      textAlign: TextAlign
                                          .right, // Align text to the right
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Row(
                                children: [
                                  Text(
                                    'Plate Number',
                                    style: textStyleNormal(
                                        fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(width: 50),
                                  Expanded(
                                    child: Text(
                                      selectedSummons[index]
                                          .vehicleRegistrationNo!,
                                      style: textStyleNormal(),
                                      textAlign: TextAlign
                                          .right, // Align text to the right
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Row(
                                children: [
                                  Text(
                                    'Summons Rate',
                                    style: textStyleNormal(
                                        fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(width: 50),
                                  Expanded(
                                    child: Text(
                                      'RM ${double.parse(selectedSummons[index].amount!).toStringAsFixed(2)}',
                                      style: textStyleNormal(),
                                      textAlign: TextAlign
                                          .right, // Align text to the right
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      }),
                  const SizedBox(height: 40),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(
                        'Total',
                        style: textStyleNormal(
                          fontWeight: FontWeight.bold,
                          fontSize: 24,
                        ),
                      ),
                      Text(
                        'RM ${totalAmount!.toStringAsFixed(2)}',
                        style: textStyleNormal(
                          fontWeight: FontWeight.bold,
                          fontSize: 24,
                        ),
                        textAlign: TextAlign.right, // Align text to the right
                      ),
                    ],
                  ),
                  const SizedBox(height: 40),
                  Center(
                    child: Text(
                      'THANK YOU',
                      style: GoogleFonts.dmSans(
                        fontSize: 20,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
