import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({Key? key}) : super(key: key);

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class Payment {
  double amount;
  String status;
  DateTime createdAt;

  Payment({
    required this.amount,
    required this.status,
    required this.createdAt,
  });

  factory Payment.fromJson(Map<String, dynamic> json) {
    return Payment(
      amount: (json['amount'] as num).toDouble(),
      status: json['status'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}

class Transaction {
  String description;
  String amount;
  DateTime createdAt;

  Transaction({
    required this.description,
    required this.amount,
    required this.createdAt,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    try {
      print(json); // Debugging line to print the entire JSON object
      return Transaction(
        description: json['description'] as String,
        amount: json['amount'].toString(),
        createdAt: DateTime.parse(json['createdAt']),
      );
    } catch (e) {
      print('Error parsing Transaction: $e'); // Print the error for debugging
      rethrow;
    }
  }
}

class _HistoryScreenState extends State<HistoryScreen> {
  Payment? payment;
  Transaction? transaction;
  List<Payment> paymentList = [];
  List<Transaction> transList = [];

  Future<void> fetchHistory() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    if (token == null) return;

    final response = await http.get(
      Uri.parse("http://192.168.0.108:3000/payment/wallet-transaction"),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (kDebugMode) {
      print('response.body : $token');
    }

    if (kDebugMode) {
      print('response.body : ${response.body}');
    }
    print('response.body : ${response.statusCode}');
    if (response.statusCode == 200) {
      setState(() {
        List<dynamic> jsonResponse = jsonDecode(response.body);
        List<Payment> tempList =
            jsonResponse.map((json) => Payment.fromJson(json)).toList();
        paymentList = tempList;
      });
    }
  }

  Future<void> fetchTrans() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    if (token == null) return;

    final response = await http.get(
      Uri.parse("http://192.168.0.119:3000/transaction"),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (kDebugMode) {
      print('response.body : $token');
    }

    if (kDebugMode) {
      print('response.body : ${response.body}');
    }
    print('response.body : ${response.statusCode}');
    if (response.statusCode == 200) {
      setState(() {
        List<dynamic> jsonResponse = jsonDecode(response.body);
        List<Transaction> tempList =
            jsonResponse.map((json) => Transaction.fromJson(json)).toList();
        transList = tempList;
      });
    }
  }

  String formatDate(DateTime date) {
    return DateFormat('d MMMM').format(date);
  }

  @override
  void initState() {
    super.initState();
    fetchHistory();
    fetchTrans();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 55, 26, 200),
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
                    'Transaction History',
                    style: GoogleFonts.openSans(
                      color: Colors.white,
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Image(
                    image: AssetImage('assets/images/transaction_history.png'),
                    width: 60,
                    height: 60,
                  ),
                ],
              ),
            )),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: paymentList.length,
              itemBuilder: (context, index) {
                final notice = paymentList[index];
                Color amountColor = Colors.black;

                if (notice.status == 'SUCCESS' && notice.amount > 0) {
                  amountColor = Colors.green;
                } else if (notice.amount < 0) {
                  amountColor = Colors.red;
                } else {
                  amountColor = Colors.black;
                }
                return Card(
                  child: ListTile(
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(notice.status),
                        Text(
                          "${notice.amount > 0 ? '+' : ''}${notice.amount.toStringAsFixed(2)}",
                          style: GoogleFonts.oswald(
                            color: amountColor,
                          ),
                        ),
                      ],
                    ),
                    subtitle: Text(
                      formatDate(notice.createdAt),
                      style: GoogleFonts.dmSans(
                        fontSize: 10,
                      ),
                    ),
                  ),
                );
              },
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: transList.length,
              itemBuilder: (context, index) {
                final trans = transList[index];
                Color amountColor = Colors.red;

                return Card(
                  child: ListTile(
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(trans.description),
                        Text(
                          trans.amount,
                          style: GoogleFonts.oswald(
                            color: amountColor,
                          ),
                        ),
                      ],
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          formatDate(trans.createdAt),
                          style: GoogleFonts.dmSans(
                            fontSize: 10,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
