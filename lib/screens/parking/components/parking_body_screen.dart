import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project/constant.dart';
import 'package:project/models/models.dart';
import 'package:project/routes/route_manager.dart';
import 'package:project/theme.dart';
import 'package:project/widget/primary_button.dart';
import 'package:table_calendar/table_calendar.dart';

class ParkingBodyScreen extends StatefulWidget {
  final UserModel userModel;
  final List<PlateNumberModel> carPlates;

  const ParkingBodyScreen(
      {super.key, required this.userModel, required this.carPlates});

  @override
  State<ParkingBodyScreen> createState() => _ParkingBodyScreenState();
}

class GlobalState {
  static String plate = '';
  static double amount = 0.0;
}

class _ParkingBodyScreenState extends State<ParkingBodyScreen> {
  double _value = 0.65;
  int _remainingTime = 3600;
  late DateTime _focusedDay;
  List<PlateNumberModel> carPlates = [];
  String? selectedCarPlate;

  @override
  void initState() {
    super.initState();
    _focusedDay = DateTime.now();

    // Find the car plate where isMain is true and set it as selected
    if (widget.carPlates.isNotEmpty) {
      PlateNumberModel mainCarPlate = widget.carPlates.firstWhere(
        (plate) => plate.isMain == true,
        orElse: () => widget.carPlates.first,
      );
      // Set the selectedCarPlate with both plateNumber and id to match the Dropdown value
      selectedCarPlate = '${mainCarPlate.plateNumber}-${mainCarPlate.id}';
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
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
                    _focusedDay = _focusedDay.subtract(const Duration(days: 7));
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
                borderRadius:
                    BorderRadius.circular(40), // Set the desired border radius
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
                  items: widget.carPlates.map<DropdownMenuItem<String>>(
                      (PlateNumberModel carPlate) {
                    // Add a unique ID to the value to prevent duplicates
                    return DropdownMenuItem<String>(
                      value: '${carPlate.plateNumber}-${carPlate.id}',
                      child: Text(
                        carPlate.plateNumber!,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    );
                  }).toList(),
                  dropdownColor: Colors.grey,
                  isExpanded: true,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
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
                                      _remainingTime =
                                          ((_value - 0.65) / (4.80 - 0.65) * 5 +
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
          spaceVertical(height: 20.0),
          PrimaryButton(
            onPressed: () {
              Navigator.pushNamed(
                context,
                AppRoute.parkingPaymentScreen,
                arguments: {
                  'userModel': widget.userModel,
                  'plateNumbers': widget.carPlates,
                  'selectedCarPlate': selectedCarPlate!,
                  'amount': _value,
                },
              );
              GlobalState.amount = _value;
              calculateRemainingTime();
            },
            label: Text(
              'Confirm',
              style: textStyleNormal(
                color: kWhite,
                fontWeight: FontWeight.bold,
              ),
            ),
            buttonWidth: 0.8,
            borderRadius: 10.0,
          ),
        ],
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
    GlobalDeclaration.globalDuration = "$hours $hourLabel";
  }

  void calculateGlobalAmount() {
    GlobalDeclaration.globalAmount = _value;
  }
}
