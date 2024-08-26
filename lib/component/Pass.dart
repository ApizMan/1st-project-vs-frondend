import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project/component/home_screen.dart';
import 'package:project/component/payment_sp.dart';
import 'package:table_calendar/table_calendar.dart';

class PassPage extends StatefulWidget {
  final UserProfile userProfile;
  const PassPage({super.key, required this.userProfile});
  @override
  // ignore: library_private_types_in_public_api
  _PassPageState createState() => _PassPageState();
}

class GlobalState {
  static String location = '';
  static double amount = 0.0;
  static int month = 0;
}

class _PassPageState extends State<PassPage> {  
  late DateTime _focusedDay;  
  String selectedLocation = 'Kuantan';
  int _selectedMonth = 1;
  DateTime _dateTime = DateTime.now();

  @override
  void initState() {
    super.initState();
    _focusedDay = DateTime.now(); // Initialize _focusedDay with current date
  }

    Map<String, List<int>> pricesPerMonth = {
    'Kuantan': [1, 3, 12],
    'Machang': [1,  3, 6, 12],
    'Kuala Terengganu': [1, 3, 6, 12]
  };

  Map<String, Map<int, double>> prices = {
  'Kuantan': {1: 79.50, 3: 207.00, 12: 667.80},
  'Machang': {1: 60.00, 3: 180.00, 6:360.00, 12:720},
  'Kuala Terengganu': {1: 100, 3: 300, 6: 600, 12:1200},
};

String calculateEndDate() {
  // Calculate end date based on the selected duration from the slider
  int selectedDuration = _selectedMonth.toInt();
  DateTime endDate = _dateTime.add(Duration(days: selectedDuration * 30));
  return endDate.toString().split(" ")[0];
}
 String getDurationLabel(int months) {
  if (months == 1.0) {
    return '1 month';
  } else {
    return '${months.toInt()} months';
  }
}

double calculatePrice() {
  // Check if selectedLocation is a valid key in pricesPerMonth
  if (pricesPerMonth.containsKey(selectedLocation)) {
    // Check if _selectedMonth is a valid key in the selectedLocation
    double? price = prices[selectedLocation]?[_selectedMonth];

    // If price is not null, return it, otherwise return a default value
    return price ?? 0.0;
  } else {
    // Handle the case where selectedLocation is not a valid key
    return 0.0;
  }
}

  @override
  Widget build(BuildContext context) {
    List<int> availableMonths = pricesPerMonth[selectedLocation]!;  
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
                    'Season Pass',
                    style: GoogleFonts.openSans(
                      color: Colors.white,
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Image(
                    image: AssetImage('assets_images/season_pass.png'),
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
            const SizedBox(height: 100),
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
                  hintText: 'Plate Number',
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
                  hintStyle:  GoogleFonts.dmSans(
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
            DropdownButton2<String>(
              isExpanded: true,
              hint: Text('Select Location',
                style: GoogleFonts.dmSans(
                  fontSize: 20,
                  color: Colors.grey,
                ),
              ),
              items: ['', 'Kuantan', 'Machang', 'Kuala Terengganu'].map((location){
                return DropdownMenuItem<String>(
                  value: location,                                 
                  child: Text(location,
                    style: GoogleFonts.dmSans(
                      fontSize: 15,                                     
                      color: selectedLocation == location ? Colors.black : Colors.black,
                    ),
                  ),                                         
                );
              }).toList(),
              value: selectedLocation,
              onChanged: (String? newLocation) {
                if (newLocation != null) {
                  setState(() {
                  selectedLocation = newLocation;
                  _selectedMonth = availableMonths[0];                                 
                });
                }
              },
              buttonStyleData: ButtonStyleData(
                padding: const EdgeInsets.only(left: 14, right: 14),
                height: 30,
                width: 200,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(60),
                  border: Border.all(
                    color: Colors.black26,
                  ),
                  color: Colors.grey,
                )                
              ),
              menuItemStyleData: const MenuItemStyleData(
                height: 40,
              ),
              underline: const SizedBox(
                height: 0,
                width: 50,
              ),
              dropdownStyleData: DropdownStyleData(
                maxHeight: 200,
                width: 200,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  color: Colors.grey[300],
                ),                                                 
              ),
              
            ),
            const SizedBox(height: 20),
            Text(
              'A M O U N T',
              style: GoogleFonts.dmSans(
                color: const Color.fromARGB(255, 31, 36, 132),
                fontSize: 20,
              ),
            ),
            const SizedBox(height: 15),
            Text(
              'RM ${calculatePrice()}',
              style: GoogleFonts.oswald(
                color: const Color.fromARGB(255, 31, 36, 132),
                fontSize: 45,
              ),
            ), 
            const SizedBox(height: 15),
            SliderTheme(
              data: SliderTheme.of(context).copyWith(
                activeTrackColor: const Color.fromRGBO(2, 50, 114, 1),
                inactiveTrackColor: const Color.fromRGBO(217, 217, 217, 1.0),
                trackShape: const RoundedRectSliderTrackShape(),
                trackHeight: 10.0,
                overlayColor: const Color.fromRGBO(2, 50, 114, 1),
                overlayShape: const RoundSliderOverlayShape(overlayRadius: 28),
                valueIndicatorShape: const PaddleSliderValueIndicatorShape(),
                valueIndicatorColor: const Color.fromRGBO(2, 50, 114, 1),
              ),
              child: Column(
              children: <Widget>[
                Slider(
                  min: 0,
                  max: availableMonths.length - 1,                   
                  divisions: availableMonths.length - 1,       
                  value: availableMonths.indexOf(_selectedMonth).toDouble(),
                  onChanged: (double value) {
                    setState(() {
                      _selectedMonth = availableMonths[value.toInt()];
                    });                                                          
                  },
                  label: getDurationLabel(_selectedMonth),                                                     
                ),
              ],
              ),                                                                
            ),          
            const SizedBox(height: 20),
            SizedBox(
              width: 150,
              height: 30,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => PaymentspScreen(userProfile: widget.userProfile)));                      
                  GlobalState.location = selectedLocation;
                  GlobalState.amount = calculatePrice();
                  GlobalState.month = _selectedMonth;
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(
                      const Color.fromARGB(255, 31, 36, 132)),
                ),
                child: Text(
                  'Confirm',
                  style: GoogleFonts.dmSans(
                    fontSize: 12,
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
}
