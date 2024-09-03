import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:project/component/Pass.dart';
import 'package:project/component/ReserveBay_screen.dart';
import 'package:project/component/compound.dart';
import 'package:project/component/map_page.dart';
import 'package:project/component/profile_screen.dart';
import 'package:project/component/reload_screen.dart';
import 'package:project/constant.dart';
// import 'package:project/screens/screens.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:geocoding/geocoding.dart';

class CarouselItem {
  String imageUrl;
  String location;

  CarouselItem({required this.imageUrl, required this.location});
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  HomeScreenState createState() => HomeScreenState();
}

class UserProfile {
  final String userID;
  final String firstName;
  final String secondName;
  final String idNumber;
  final String phoneNumber;
  final String email;
  final String? password;
  final String address1;
  final String address2;
  final String address3;
  final int postcode;
  final String city;
  final String state;
  final List<CarPlate> carPlates;

  UserProfile({
    required this.userID,
    required this.firstName,
    required this.secondName,
    required this.idNumber,
    required this.phoneNumber,
    required this.email,
    this.password,
    required this.address1,
    required this.address2,
    required this.address3,
    required this.postcode,
    required this.city,
    required this.state,
    required this.carPlates,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    var carPlatesJson = json['plateNumbers'] as List? ?? [];
    List<CarPlate> carPlatesList =
        carPlatesJson.map((plateJson) => CarPlate.fromJson(plateJson)).toList();

    return UserProfile(
      userID: json['id'] ?? '',
      firstName: json['firstName'] ?? '',
      secondName: json['secondname'] ?? '',
      idNumber: json['idNumber'] ?? '',
      phoneNumber: json['phoneNumber'] ?? '',
      email: json['email'] ?? '',
      password: json['password'],
      address1: json['address1'] ?? '',
      address2: json['address2'] ?? '',
      address3: json['address3'] ?? '',
      postcode: json['postcode'] ?? 0,
      city: json['city'] ?? '',
      state: json['state'] ?? '',
      carPlates: carPlatesList,
    );
  }
}

class Wallet {
  String id;
  String userId;
  double amount;

  Wallet({
    required this.id,
    required this.userId,
    required this.amount,
  });

  factory Wallet.fromJson(Map<String, dynamic> json) {
    return Wallet(
      id: json['id'] ?? '',
      userId: json['userId'] ?? '',
      amount: (json['amount'] as num).toDouble(),
    );
  }
}

class CarPlate {
  final String carplatenumberID;
  final String userID;
  final String carPlateNumber;

  CarPlate({
    required this.carplatenumberID,
    required this.userID,
    required this.carPlateNumber,
  });

  factory CarPlate.fromJson(Map<String, dynamic> json) {
    return CarPlate(
      carplatenumberID: json['id'] ?? '',
      userID: json['userId'] ?? '',
      carPlateNumber: json['plateNumber'] ?? '',
    );
  }
}

class HomeScreenState extends State<HomeScreen> {
  //Future<Infouser>? _userInfoFuture;

  List<CarouselItem> myitems = [
    CarouselItem(
        imageUrl: 'assets_images/pbtlogo_kuantan-removebg-preview.png',
        location: 'Kuantan'),
    CarouselItem(
        imageUrl: 'assets_images/pbkk_kt-removebg-preview.png',
        location: 'Kuala Terengganu'),
    CarouselItem(
        imageUrl: 'assets_images/PBT_machang-removebg-preview.png',
        location: 'Machang'),
  ];
  UserProfile? userProfile;
  Wallet? wallet;
  List<CarPlate> carPlates = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _checkLocationAndFetch();
    fetchUserProfile();

    paymentParking();
  }

  Future<void> fetchUserProfile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    if (token == null) return;

    final response = await http.get(
      Uri.parse("$baseUrl/auth/user-profile"),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (kDebugMode) {
      print('response.body : ${response.body}');
    }
    print('response.body : ${response.statusCode}');
    if (response.statusCode == 200) {
      setState(() {
        Map<String, dynamic> jsonList = jsonDecode(response.body);
        userProfile = UserProfile.fromJson(jsonList);
        carPlates = userProfile!.carPlates;
        if (kDebugMode) {
          print('user profile nk : $userProfile');
        }
        loading = false;
      });
    }
  }

  Future<void> paymentParking() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    var url = Uri.parse("$baseUrl/wallet/wallet-info");

    var response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (kDebugMode) {
      print('response.body : ${response.body}');
    }

    if (response.statusCode == 200) {
      if (kDebugMode) {
        setState(() {
          Map<String, dynamic> jsonList = jsonDecode(response.body);
          wallet = Wallet.fromJson(jsonList);
          if (kDebugMode) {
            print('user profile nk : $userProfile');
          }
          loading = false;
        });
        print('Wallet Succesful!');
      }
    } else {
      if (kDebugMode) {
        print('Payment Parking failed: ${response.statusCode}');
      }
    }
  }

  void _checkLocationAndFetch() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      _confirmLocation(context);
    } else {
      _getLocation(context); // This line should be changed
    }
  }

  void _confirmLocation(BuildContext context) async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Location Service Disabled'),
              content: const Text(
                  'Please enable location service to use this feature'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Ok'),
                )
              ],
            );
          });
    }
  }

  void _getLocation(BuildContext context) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      bool? isLocationConfirmed = prefs.getBool('isLocationConfirmed');

      if (isLocationConfirmed == true) {
        print('Location already confirmed');
        return;
      }

      // Get the current position of the device
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      final List<Placemark> locationName =
          await placemarkFromCoordinates(position.latitude, position.longitude);

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Location Details'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                    'Our GPS detects you in ${locationName.first.locality}. Please \n confirm if this is accurate or \n inaccurate.'),
              ],
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () async {
                  await prefs.setBool('isLocationConfirmed', true);
                  Navigator.of(context).pop();
                },
                child: const Text('Confirm'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Cancel'),
              ),
            ],
          );
        },
      );
    } catch (e) {
      print('Error getting location: $e');
    }
  }

  void _handleImageClick(String location) {
    // Show location in a SnackBar
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Location: $location'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  final mynews = [
    Image.asset('assets_images/news_1.png'),
    Image.asset('assets_images/news_2.png'),
    Image.asset('assets_images/news_3.png'),
  ];
  double currentBalance = 0.00;
  int myCurrentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(width: 15),
            GestureDetector(
              onTap: () {
                if (userProfile != null) {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) =>
                          ProfileScreen(userProfile: userProfile!)));
                }
              },
              child: const CircleAvatar(
                backgroundImage: AssetImage(
                    'assets_images/account.png'), // Ganti dengan path gambar Anda
                radius: 15, // Sesuaikan ukuran radius sesuai kebutuhan
              ),
            ),
            const SizedBox(
                width:
                    10), // Menambahkan jarak antara gambar dan teks 'Welcome'
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Welcome',
                  style: GoogleFonts.ptSans(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                    height:
                        5), // Menambahkan jarak antara 'Welcome' dan 'nik haqim'
                Text(
                  userProfile?.firstName ?? '',
                  style: GoogleFonts.dmSans(
                    color: Colors.white,
                    fontSize: 15,
                  ),
                ),
              ],
            ),
            const SizedBox(width: 100),
            const Padding(
              padding: EdgeInsets.only(right: 10.0),
              child: Icon(
                Icons.notifications,
                color: Colors.white,
                size: 20, // Sesuaikan ukuran ikon sesuai kebutuhan
              ),
            ),
          ],
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(80.0),
          child: Container(
            padding: const EdgeInsets.all(10.0),
            alignment: Alignment.centerRight,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    const SizedBox(width: 30),
                    Text(
                      'Available Balance',
                      style: GoogleFonts.poppins(
                          fontSize: 10, color: Colors.white),
                    ),
                  ],
                ),
                //const SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      wallet?.amount.toStringAsFixed(2) ?? '0.00',
                      style: GoogleFonts.poppins(
                        color: Colors.grey,
                        fontSize: 30,
                      ),
                    ),
                    const SizedBox(width: 10),
                    SizedBox(
                      width: 80,
                      height: 20,
                      child: ElevatedButton(
                        onPressed: () {
                          if (userProfile != null) {
                            // Navigator.of(context).push(MaterialPageRoute(
                            //     builder: (context) => ReloadCreditScreen(
                            //         userProfile: userProfile)));
                          }
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    10)) // Background color
                            ),
                        child: Text(
                          '+Reload',
                          style: GoogleFonts.dmSans(
                            color: Colors.black,
                            fontSize: 8,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    const SizedBox(width: 150),
                    Text(
                      'Updated on 1st March 2025 15:30',
                      style: GoogleFonts.dmSans(
                        color: Colors.white,
                        fontSize: 8,
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 55, 26, 200),
      ),
      body: SingleChildScrollView(
          child: Column(
        children: [
          SizedBox(
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Select PBT',
                textAlign: TextAlign.left,
                style: GoogleFonts.poppins(
                  fontSize: 15,
                  color: Colors.black,
                ),
              ),
            ),
          ),
          CarouselSlider(
            options: CarouselOptions(
              autoPlay: false,
              height: 150,
              autoPlayCurve: Curves.fastOutSlowIn,
              autoPlayAnimationDuration: const Duration(milliseconds: 800),
              autoPlayInterval: const Duration(seconds: 2),
              enlargeCenterPage: true,
              aspectRatio: 2.0,
              onPageChanged: (index, reason) {
                setState(() {
                  myCurrentIndex = index;
                });
              },
            ),
            items: myitems.map((items) {
              return Builder(
                builder: (BuildContext context) {
                  return GestureDetector(
                    onTap: () {
                      String location = items.location;
                      _handleImageClick(location);
                    },
                    child: SizedBox(
                      width: 150,
                      height: 15,
                      //margin: const EdgeInsets.symmetric(horizontal: 5.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10.0),
                        child: Image.asset(
                          items.imageUrl,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  );
                },
              );
            }).toList(),
          ),
          const SizedBox(height: 10),
          Center(
            child: AnimatedSmoothIndicator(
              activeIndex: myCurrentIndex,
              count: myitems.length,
              effect: WormEffect(
                dotHeight: 8,
                dotWidth: 8,
                spacing: 10,
                dotColor: Colors.grey.shade200,
                activeDotColor: Colors.grey.shade900,
                paintStyle: PaintingStyle.fill,
              ),
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Our Service',
                textAlign: TextAlign.left,
                style: GoogleFonts.poppins(
                  fontSize: 15,
                  color: Colors.black,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.only(right: 20, left: 20),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () {
                            // Navigator.push(
                            //     context,
                            //     MaterialPageRoute(
                            //         builder: (context) => ParkingScreen()));
                          },
                          child: Image.asset(
                            'assets_images/ss_1.png',
                            width: 70,
                            height: 90,
                            fit: BoxFit.contain,
                          ),
                        ),
                        const SizedBox(height: 8),
                        SizedBox(
                          width: 60,
                          height: 30, // Tetapkan ketinggian tetap
                          child: Text(
                            'Parking',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const CompoundScreen()));
                          },
                          child: Image.asset(
                            'assets_images/ss_2.png',
                            width: 70,
                            height: 90,
                            fit: BoxFit.contain,
                          ),
                        ),
                        const SizedBox(height: 8),
                        SizedBox(
                          width: 65,
                          height: 30, // Tetapkan ketinggian tetap
                          child: Text(
                            'Summons',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const ReserveBay()));
                          },
                          child: Image.asset(
                            'assets_images/ss_3.png',
                            width: 70,
                            height: 90,
                            fit: BoxFit.contain,
                          ),
                        ),
                        const SizedBox(height: 10),
                        SizedBox(
                          width: 60,
                          height: 32, // Tetapkan ketinggian tetap
                          child: Text(
                            'Reserve Bays',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        GestureDetector(
                          onTap: () {
                            // Navigator.push(
                            //     context,
                            //     MaterialPageRoute(
                            //         builder: (context) =>
                            //             PassPage(userProfile: userProfile!)));
                          },
                          child: Image.asset(
                            'assets_images/MP.png',
                            width: 70,
                            height: 90,
                            fit: BoxFit.contain,
                          ),
                        ),
                        const SizedBox(height: 8),
                        SizedBox(
                          width: 60,
                          height: 30, // Tetapkan ketinggian tetap
                          child: Text(
                            'Season Pass',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          Padding(
              padding: const EdgeInsets.only(right: 20, left: 30),
              child: Column(children: [
                const SizedBox(height: 10),
                Row(
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const MapPage()));
                          },
                          child: Image.asset(
                            'assets_images/ss_5.png',
                            width: 70,
                            height: 90,
                            fit: BoxFit.contain,
                          ),
                        ),
                        const SizedBox(height: 8),
                        SizedBox(
                          width: 60,
                          height: 30, // Tetapkan ketinggian tetap
                          child: Text(
                            'Transport Info',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ])),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'News Update',
                textAlign: TextAlign.left,
                style: GoogleFonts.poppins(
                  fontSize: 15,
                  color: Colors.black,
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          CarouselSlider(
            options: CarouselOptions(
              autoPlay: false,
              height: 120,
              autoPlayCurve: Curves.fastOutSlowIn,
              autoPlayAnimationDuration: const Duration(milliseconds: 400),
              autoPlayInterval: const Duration(seconds: 2),
              enlargeCenterPage: true,
              aspectRatio: 2.0,
              onPageChanged: (index, reason) {
                setState(() {
                  myCurrentIndex = index;
                });
              },
            ),
            items: mynews,
          ),
          const SizedBox(height: 5),
          Center(
            child: AnimatedSmoothIndicator(
              activeIndex: myCurrentIndex,
              count: mynews.length,
              effect: WormEffect(
                dotHeight: 8,
                dotWidth: 8,
                spacing: 10,
                dotColor: Colors.grey.shade200,
                activeDotColor: Colors.grey.shade900,
                paintStyle: PaintingStyle.fill,
              ),
            ),
          ),
          const SizedBox(height: 20)
        ],
      )),
    );
  }
}
