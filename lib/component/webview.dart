import 'package:flutter/material.dart';
import 'package:project/constant.dart';
import 'package:project/theme.dart';
import 'package:project/widget/custom_dialog.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class WebViewPage extends StatefulWidget {
  final String title;
  final Map<String, dynamic> details;
  final String url;

  const WebViewPage({
    super.key,
    required this.title,
    required this.url,
    required this.details,
  });

  @override
  State<WebViewPage> createState() => _WebViewPageState();
}

class _WebViewPageState extends State<WebViewPage> {
  late final WebViewController controller;

  @override
  void initState() {
    super.initState();
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(Uri.parse(widget.url));
  }

  @override
  Widget build(BuildContext context) {
    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: () async {
        CustomDialog.show(
          context,
          title: AppLocalizations.of(context)!.closeReceipt,
          description: AppLocalizations.of(context)!.closeReceiptDesc,
          btnOkText: AppLocalizations.of(context)!.exit,
          btnCancelText: AppLocalizations.of(context)!.cancel,
          btnOkOnPress: () {
            Navigator.pop(context);
            Navigator.pop(context);
          },
          btnCancelOnPress: () => Navigator.pop(context),
        );
        return Future.value(false);
      },
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 100,
          foregroundColor:
              widget.details['color'] == 4294961979 ? kBlack : kWhite,
          backgroundColor: Color(widget.details['color']),
          centerTitle: true,
          title: Text(
            widget.title,
            style: textStyleNormal(
              fontSize: 26,
              color: widget.details['color'] == 4294961979 ? kBlack : kWhite,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: WebViewWidget(controller: controller),
      ),
    );
  }
}
