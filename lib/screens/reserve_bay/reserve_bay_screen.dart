import 'package:flutter/material.dart';
import 'package:project/constant.dart';
import 'package:project/theme.dart';

class ReserveBayScreen extends StatefulWidget {
  const ReserveBayScreen({super.key});

  @override
  State<ReserveBayScreen> createState() => _ReserveBayScreenState();
}

class _ReserveBayScreenState extends State<ReserveBayScreen> {
  @override
  Widget build(BuildContext context) {
    final arguments =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;

    Map<String, dynamic> details =
        arguments['locationDetail'] as Map<String, dynamic>;
    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: AppBar(
        toolbarHeight: 100,
        foregroundColor: details['color'] == 4294961979 ? kBlack : kWhite,
        backgroundColor: Color(details['color']),
        centerTitle: true,
        title: Text(
          'Reserve Bay',
          style: textStyleNormal(
            fontSize: 26,
            color: details['color'] == 4294961979 ? kBlack : kWhite,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Column(
        children: [
          
        ],
      ),
    );
  }
}
