import 'package:flutter/material.dart';
import 'package:project/constant.dart';
import 'package:project/theme.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PdfViewerScreen extends StatelessWidget {
  final Map<String, dynamic> details;
  final String pdfUrl;

  const PdfViewerScreen({
    Key? key,
    required this.pdfUrl,
    required this.details,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: AppBar(
        toolbarHeight: 100,
        foregroundColor: details['color'] == 4294961979 ? kBlack : kWhite,
        backgroundColor: Color(details['color']),
        centerTitle: true,
        title: Text(
          AppLocalizations.of(context)!.viewPDF,
          style: textStyleNormal(
            fontSize: 26,
            color: details['color'] == 4294961979 ? kBlack : kWhite,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SfPdfViewer.network(pdfUrl),
    );
  }
}
