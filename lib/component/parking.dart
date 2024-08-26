import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project/component/home_screen.dart';
import 'package:project/component/payment_prk.dart';
import 'package:project/constant.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:table_calendar/table_calendar.dart';

class ParkingScreen extends StatefulWidget {
  final UserProfile userProfile;
  final List<CarPlate> carPlates;

  const ParkingScreen(
      {super.key, required this.userProfile, required this.carPlates});

  @override
  State<ParkingScreen> createState() => _ParkingscreenState();
}

class GlobalState {
  static String plate = '';
  static double amount = 0.0;
}

class _ParkingscreenState extends State<ParkingScreen> {
  double _value = 0.65;
  int _remainingTime = 3600;
  late DateTime _focusedDay;
  List<CarPlate> carPlates = [];
  String? selectedCarPlate;

  @override
  void initState() {
    super.initState();
    _focusedDay = DateTime.now();
    if (widget.carPlates.isNotEmpty) {
      selectedCarPlate = widget.carPlates.first.carPlateNumber;
    }
  }

  Future<void> fetchCarPlate() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    if (token == null) return;

    final response = await http.get(
      Uri.parse("$baseUrl/carplatenumber"),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (kDebugMode) {
      print('response.body : ${response.body}');
    }
    if (kDebugMode) {
      print('response.body : ${response.statusCode}');
    }
    if (response.statusCode == 200) {
      setState(() {
        try {
          List<dynamic> jsonList = jsonDecode(response.body);
          carPlates = jsonList.map((json) => CarPlate.fromJson(json)).toList();
          //carPlates =[];
          if (kDebugMode) {
            print('please look here: $carPlates');
          }
        } catch (e, s) {
          if (kDebugMode) {
            print(e);
          }
          if (kDebugMode) {
            print(s);
          }
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 55, 26, 200),
        leading: SizedBox(
          child: IconButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const HomeScreen()));
              },
              icon: const Icon(
                Icons.arrow_back_sharp,
                color: Colors.white,
              )),
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
                    'Parking',
                    style: GoogleFonts.openSans(
                      color: Colors.white,
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Image(
                    image: AssetImage('assets_images/parking_side.png'),
                    width: 60,
                    height: 80,
                    color: Colors.white,
                  ),
                ],
              ),
            )),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 15),
            Align(
              alignment: Alignment.center,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                    onPressed: () {},
                    child: Text(
                      'Onstreet',
                      style: GoogleFonts.poppins(
                        color: Colors.black,
                      ),
                    )),
              ),
            ),
            const SizedBox(height: 15),
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_left_sharp),
                  onPressed: () {
                    setState(() {
                      _focusedDay =
                          _focusedDay.subtract(const Duration(days: 7));
                    });
                  },
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TableCalendar(
                        firstDay: DateTime.utc(2010, 10, 16),
                        lastDay: DateTime.utc(2030, 3, 14),
                        focusedDay: _focusedDay,
                        calendarFormat: CalendarFormat.week,
                        onFormatChanged: (format) {
                          setState(() {
                            // Update the calendar format if needed
                          });
                        },
                        onDaySelected: (selectedDay, focusedDay) {
                          setState(() {
                            _focusedDay = focusedDay;
                          });
                        },
                        headerStyle: const HeaderStyle(
                          formatButtonVisible: false,
                          titleTextStyle: TextStyle(fontSize: 0),
                        ),
                        headerVisible: false,
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.arrow_right_sharp),
                  onPressed: () {
                    setState(() {
                      _focusedDay = _focusedDay.add(const Duration(days: 7));
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 15),
            if (widget.carPlates.isNotEmpty)
              Container(
                width: 200, // Set the desired width
                height: 30, // Set the desired height
                decoration: BoxDecoration(
                  color: Colors.grey, // Set the desired background color
                  borderRadius: BorderRadius.circular(40), // Set the desired border radius
                ),
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: selectedCarPlate,
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedCarPlate = newValue;
                      });
                    },
                    items: widget.carPlates
                        .map<DropdownMenuItem<String>>((CarPlate carPlate) {
                      return DropdownMenuItem<String>(
                        value: carPlate.carPlateNumber,
                        child: Text(
                          carPlate.carPlateNumber,
                          style: const TextStyle(
                            color: Colors.white, // Set text color
                            fontSize: 10, // Set font size
                            fontWeight: FontWeight.bold, // Set font weight
                          ),
                        ),
                      );
                    }).toList(),
                    dropdownColor:
                        Colors.grey, // Set the dropdown menu background color
                    isExpanded: true,
                    style: const TextStyle(
                      color: Colors.white, // Set the selected item text color
                      fontSize: 10, // Set the selected item font size
                      fontWeight:
                          FontWeight.bold, // Set the selected item font weight
                    ),
                  ),
                ),
              ),
            const SizedBox(height: 20),
            Container(
              width: 200, // Set the desired width
              height: 30, // Set the desired height
              decoration: BoxDecoration(
                color:
                    const Color(0xFFDDDDDD), // Set the desired background color
                borderRadius:
                    BorderRadius.circular(40), // Set the desired border radius
              ),
              child: TextField(
                //controller: Company_name,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: null,
                  hintText: 'PBT',
                  hintStyle: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(40),
                  ),
                  filled: true,
                  fillColor: Colors.grey,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 20),
            Container(
              width: 200, // Set the desired width
              height: 30, // Set the desired height
              decoration: BoxDecoration(
                color:
                    const Color(0xFFDDDDDD), // Set the desired background color
                borderRadius:
                    BorderRadius.circular(40), // Set the desired border radius
              ),
              child: TextField(
                //controller: Company_name,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: null,
                  hintText: 'Location',
                  hintStyle: GoogleFonts.dmSans(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(40),
                  ),
                  filled: true,
                  fillColor: Colors.grey,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: <Widget>[
                  Container(
                      alignment: Alignment.center,
                      child: Column(
                        children: [
                          const SizedBox(height: 35),
                          Text(
                            'Duration',
                            style: GoogleFonts.secularOne(
                              fontSize: 20,
                              color: Colors.black,
                            ),
                          ),
                          Text(
                            _formatDuration(_remainingTime),
                            style: GoogleFonts.secularOne(
                              fontSize: 30,
                              color: const Color.fromARGB(255, 12, 59, 97),
                            ),
                          ),
                          const SizedBox(height: 15),
                          Text(
                            'A M O U N T',
                            style: GoogleFonts.secularOne(
                              fontSize: 20,
                              color: Colors.black,
                            ),
                          ),
                          Text(
                            'RM ${_value.toStringAsFixed(2)}',
                            style: GoogleFonts.secularOne(
                              fontSize: 30,
                              color: const Color.fromARGB(255, 19, 3, 108),
                            ),
                          ),
                          SliderTheme(
                            data: SliderTheme.of(context).copyWith(
                              activeTrackColor:
                                  const Color.fromRGBO(2, 50, 114, 1),
                              inactiveTickMarkColor:
                                  const Color.fromRGBO(217, 217, 217, 1.0),
                              trackShape: const RoundedRectSliderTrackShape(),
                              trackHeight: 10.0,
                              overlayColor: const Color.fromRGBO(2, 50, 114, 1),
                              overlayShape: const RoundSliderOverlayShape(
                                  overlayRadius: 28),
                              valueIndicatorShape:
                                  const PaddleSliderValueIndicatorShape(),
                              valueIndicatorColor:
                                  const Color.fromRGBO(2, 50, 114, 1),
                            ),
                            child: Column(
                              children: <Widget>[
                                Slider(
                                    min: 0.65,
                                    max: 4.8,
                                    divisions: 6,
                                    label:
                                        '${(((_value - 0.65) / (4.80 - 0.65) * 5) + 1).round()} hour',
                                    value: _value,
                                    onChanged: (double value) {
                                      setState(() {
                                        _value = (value / 0.65).round() * 0.65;
                                        _remainingTime = ((_value - 0.65) /
                                                        (4.80 - 0.65) *
                                                        5 +
                                                    1)
                                                .round() *
                                            3600;
                                      });
                                    }),
                              ],
                            ),
                          ),
                        ],
                      ))
                ],
              ),
            ),
            SizedBox(
              width: 200,
              height: 30,
              child: ElevatedButton(
                onPressed: () {
                  //paymentParking();
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => PaymentpkScreen(userProfile: widget.userProfile, carPlates: widget.carPlates, selectedCarPlate: selectedCarPlate!, amount: _value,)));
                   GlobalState.amount = _value;
                  calculateRemainingTime();
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(
                      const Color.fromARGB(255, 31, 36, 132)),
                ),
                child: Text(
                  'Confirm',
                  style: GoogleFonts.dmSans(
                    fontSize: 9.1,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showTimeEndingDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Center(
            child: Text(
              "Peringatan",
              style: GoogleFonts.poppins(
                color: Colors.red[800],
              ),
            ),
          ),
          content: Center(
            child: Text(
              "Your Duration of Parking will be terminated in 10 minute",
              style: GoogleFonts.poppins(),
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("OK"),
            ),
          ],
        );
      },
    );
  }

  void startCountdown() {
    const oneSecond = Duration(seconds: 1);

    Timer.periodic(oneSecond, (Timer timer) {
      setState(() {
        if (_remainingTime > 0) {
          _remainingTime--;
          if (_remainingTime == 600) {
            // Jika sisa waktu 10 menit
            _showTimeEndingDialog(); // Tampilkan dialog peringatan
          }
        } else {
          timer.cancel();
        }
      });
    });
  }

  String _formatDuration(int totalSeconds) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");

    int hours = totalSeconds ~/ 3600;
    int remainingMinutes = (totalSeconds % 3600) ~/ 60;
    int seconds = totalSeconds % 60;

    String formattedHours = twoDigits(hours);
    String formattedMinutes = twoDigits(remainingMinutes);
    String formattedSeconds = twoDigits(seconds);

    return "$formattedHours:$formattedMinutes:$formattedSeconds";
  }

  void calculateRemainingTime() {
    // Calculate the remaining time in seconds
    int _remainingTime =
        (((_value - 0.65) / (4.80 - 0.65) * 5 + 1).round() * 3600);

    // Convert seconds to hours
    int hours = (_remainingTime / 3600).round();

    // Determine the correct singular or plural form
    String hourLabel = hours == 1 ? "hour" : "hours";

    // Create the formatted string
    globalDuration = "$hours $hourLabel";
  }

  void calculateGlobalAmount() {
    globalAmount = _value;
  }
}
