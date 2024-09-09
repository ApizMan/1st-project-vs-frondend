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
import 'package:project/routes/route_manager.dart';
import 'package:project/theme.dart';
import 'dart:ui' as ui;
import 'package:pdf/widgets.dart' as pw;
import 'package:project/widget/primary_button.dart';

class MonthlyPassReceiptScreen extends StatefulWidget {
  const MonthlyPassReceiptScreen({
    super.key,
  });

  @override
  State<MonthlyPassReceiptScreen> createState() =>
      _MonthlyPassReceiptScreenState();
}

class _MonthlyPassReceiptScreenState extends State<MonthlyPassReceiptScreen> {
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
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    final arguments =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;

    Map<String, dynamic> details =
        arguments['locationDetail'] as Map<String, dynamic>;
    String? parkingCar = arguments['selectedCarPlate'] as String?;
    double amount = double.parse(arguments['amount']);
    String? duration = arguments['duration'] as String?;
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
                      style: GoogleFonts.firaCode(
                        fontWeight: FontWeight.bold,
                        fontSize: 30,
                      ),
                    ),
                  ],
                )),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Text(
                      'Date',
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
                        details['location'],
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
                      'Total',
                      style: GoogleFonts.firaCode(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(width: 50),
                    Expanded(
                      child: Text(
                        amount.toStringAsFixed(2),
                        style:
                            GoogleFonts.firaCode(fontWeight: FontWeight.bold),
                        textAlign: TextAlign.right, // Align text to the right
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
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
    );
  }
}
