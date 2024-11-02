// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project/constant.dart';
import 'package:project/theme.dart';

class QrCodeScreen extends StatelessWidget {
  const QrCodeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final arguments =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;

    Map<String, dynamic> details =
        arguments['locationDetail'] as Map<String, dynamic>;
    String qrCodeUrl = arguments['qrCodeUrl'] as String;

    return Scaffold(
        backgroundColor: kBackgroundColor,
        appBar: AppBar(
          toolbarHeight: 100,
          foregroundColor: details['color'] == 4294961979 ? kBlack : kWhite,
          backgroundColor: Color(details['color']),
          centerTitle: true,
          title: Text(
            'QR Code',
            style: textStyleNormal(
              fontSize: 26,
              color: details['color'] == 4294961979 ? kBlack : kWhite,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: SingleChildScrollView(
            child: Column(
          children: [
            const SizedBox(height: 100),
            Center(
              child: Container(
                padding: const EdgeInsets.all(10.0),
                width: 300,
                height: 300,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.red,
                    width: 5.0,
                  ),
                ),
                child: SizedBox(
                  width: 300,
                  height: 300,
                  child: Image.network(
                    qrCodeUrl,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Column(
              children: [
                Text(
                  '1.Please screenshot the QR Code',
                  style: GoogleFonts.dmSans(color: Colors.red),
                ),
                Text(
                  '(QR Code will expire in 10 minutes)',
                  style: GoogleFonts.dmSans(color: Colors.red),
                ),
                const SizedBox(height: 10),
                Text(
                  '2.Open you banking online app',
                  style: GoogleFonts.dmSans(color: Colors.red),
                ),
                const SizedBox(height: 10),
                Text(
                  '3. Scan the QR code',
                  style: GoogleFonts.dmSans(color: Colors.red),
                )
              ],
            )
          ],
        )));
  }
}
