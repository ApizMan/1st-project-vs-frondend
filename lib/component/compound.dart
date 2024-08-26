import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project/component/home_screen.dart';
import 'package:project/widget/animsearchbar.dart';
//import 'package:shared_preferences/shared_preferences.dart';

class CompoundScreen extends StatefulWidget {
  const CompoundScreen({Key? key}) : super(key: key);

  @override
  State<CompoundScreen> createState() => _CompoundScreenState();
}

class Notice {
  final int compoundAmount;
  final String noticeNo;
  final String vehicleMakeModel;
  final String vehicleNo;
  final String vehicleType;

  Notice({
    required this.compoundAmount,
    required this.noticeNo,
    required this.vehicleMakeModel,
    required this.vehicleNo,
    required this.vehicleType,
  });

  factory Notice.fromJson(Map<String, dynamic> json) {
    return Notice(
      compoundAmount: json['CompoundAmount'],
      noticeNo: json['NoticeNo'],
      vehicleMakeModel: json['VehicleMakeModel'],
      vehicleNo: json['VehicleNo'],
      vehicleType: json['VehicleType'],
    );
  }
}

class _CompoundScreenState extends State<CompoundScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<Notice> noticeList = []; // List to hold Notice objects

  Future<void> fetchCompound() async {
    var url = Uri.parse("http://43.252.37.175/ParkingWebService/HandheldService.svc/SearchNotice");
    var response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'NoticeNo': _searchController.text,
      }),
    );

    if (response.statusCode == 200) {
      setState(() {
        Map<String, dynamic> jsonResponse = jsonDecode(response.body);
        List<dynamic> jsonNotices = jsonResponse['Notices'];
        List<Notice> tempList =
            jsonNotices.map((json) => Notice.fromJson(json)).toList();
        noticeList = tempList;
      });
    } else {
      if (kDebugMode) {
        print('Failed to fetch data. Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 55, 26, 200),
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const HomeScreen()));
          },
          icon: const Icon(
            Icons.arrow_back_sharp,
            color: Colors.white,
          ),
        ),
        title: Text(
          'Back',
          style: GoogleFonts.dmSans(
            color: Colors.white,
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(90.0),
          child: Container(
            padding: const EdgeInsets.all(10.0),
            alignment: Alignment.centerLeft,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Summons',
                  style: GoogleFonts.openSans(
                    color: Colors.white,
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Image(
                  image: AssetImage('assets_images/police.png'),
                  width: 60,
                  height: 80,
                  color: Colors.white,
                ),
              ],
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            AnimSearchBar(
              width: 400,
              height: 50,
              textController: _searchController,
              onSuffixTap: () {
                setState(() {
                  _searchController.clear();
                });
              },
              onSubmitted: (value) {
                fetchCompound(); // Fetch the data when search is submitted
              },
              searchBarOpen: (int) {
                setState(() {
                  _searchController.clear();
                });
              },
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: noticeList.length,
              itemBuilder: (context, index) {
                final notice = noticeList[index];
                return Card(
                  child: ListTile(
                    title: Text('Notice No: ${notice.noticeNo}'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Vehicle No: ${notice.vehicleNo}'),
                        Text('Vehicle Make/Model: ${notice.vehicleMakeModel}'),
                        Text('Vehicle Type: ${notice.vehicleType}'),
                        Text('Compound Amount: ${notice.compoundAmount}'),
                      ],
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 100),
            SizedBox(
              width: 200,
              height: 45,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 30, 6, 207),
                ),
                child: Text(
                  'Pay',
                  style: GoogleFonts.dmSans(
                    color: Colors.white,
                  ),
                ),
              ),              
            )
          ],
        ),
      ),
    );
  }
}
