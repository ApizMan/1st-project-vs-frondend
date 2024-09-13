import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_scale_tap/flutter_scale_tap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:project/constant.dart';
import 'package:project/models/models.dart';
import 'package:project/routes/route_manager.dart';
import 'package:project/theme.dart';
import 'package:project/widget/custom_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:share_plus/share_plus.dart';

//import 'package:line_awesome_flutter/line_awesome_flutter.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({
    super.key,
  });
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class Vehicle {
  final String plateNumber;

  Vehicle({
    required this.plateNumber,
  });
}

class CarPlate {
  final String id;
  final String carplatenumberID;
  final String userID;
  final String carPlateNumber;

  CarPlate({
    required this.id,
    required this.carplatenumberID,
    required this.userID,
    required this.carPlateNumber,
  });

  factory CarPlate.fromJson(Map<String, dynamic> json) {
    return CarPlate(
      id: json['id'] ?? '',
      carplatenumberID: json['id'] ?? '',
      userID: json['userId'] ?? '',
      carPlateNumber: json['plateNumber'] ?? '',
    );
  }
}

List<String> complaintTypes = [
  'Season Pass',
  'Reserve Bays',
  'Parking',
  'Enforcement',
  'Others',
];
String? selectedValue;
String? selectedPBT;

class _ProfileScreenState extends State<ProfileScreen> {
  TextEditingController carplate = TextEditingController();
  TextEditingController description = TextEditingController();
  TextEditingController email = TextEditingController();
  bool loading = true;
  get prefs => null;
  List<CarPlate> carPlates = [];

  List<String> profileList = [
    'About Me',
    'E-Mail & Password',
    'List of Vehicle',
    'Transaction History',
    'Settings',
    'Share This App',
    'Help Center',
    'Term & Conditions',
  ];

  List<Icon> profileListIcon = [
    const Icon(Icons.person),
    const Icon(Icons.email_sharp),
    const Icon(Icons.location_on),
    const Icon(Icons.history),
    const Icon(Icons.settings),
    const Icon(Icons.share),
    const Icon(Icons.help_outline_rounded),
    const Icon(Icons.telegram),
  ];

  @override
  void initState() {
    // email.text = userModel.email;
    super.initState();
    fetchCarPlate();
  }

  final Map<String, String> pbtMap = {
    'Majlis Bandaraya Kuantan': 'e2cdf0ae-3d97-4032-b451-3bff0c9853ec',
    'Majlis Daerah Machang': '942a008f-65a1-4edf-a67a-0509e1c6867d',
    'Majlis Bandaraya Kuala Terengganu': 'b7c6f626-c33f-4f08-a9d2-cfe4a49bad47',
  };

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

  Future<void> carplatereg({required bool isMain}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    if (token == null) return;
    var url = Uri.parse("$baseUrl/carplatenumber/create");
    var response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'plateNumber': carplate.text,
        'isMain': isMain ? true : false, // Send as 1 or 0
      }),
    );

    if (kDebugMode) {
      print('Response status: ${response.statusCode}');
    } // Debugging
    if (kDebugMode) {
      print('Response body: ${response.body}');
    } // Debugging

    if (response.statusCode == 200) {
      if (kDebugMode) {
        print('Car Plate Register Successful!');
      }
    } else {
      if (kDebugMode) {
        print('Car Plate Register: ${response.statusCode}');
      }
      if (kDebugMode) {
        print('Response: ${response.body}');
      }
    }
  }

  Future<void> deleteplate(String id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    if (token == null) return;

    final response = await http.post(
      Uri.parse("$baseUrl/carplatenumber/delete/$id"),
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
        carPlates.removeWhere((plate) => plate.id == id);
        if (kDebugMode) {
          print("Deleted car plate with id: $id");
        }
      });
    } else {
      if (kDebugMode) {
        print("Failed to delete car plate : ${response.statusCode}");
      }
    }
  }

  Future<bool> createhelpdesk() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    String? pbtId = pbtMap[selectedPBT];

    print('Selected PBT: $selectedPBT');
    print('Mapped PBT ID: $pbtId');

    if (pbtId == null) {
      print('PBT ID is null. Please select a PBT.');
      return false;
    }

    var url = Uri.parse("$baseUrl/helpdesk/create-helpdesk");
    var response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'pbt': pbtId,
        'description': description.text,
      }),
    );

    if (response.statusCode == 200) {
      print('Help Center Successfully Sent!');
      return true;
    } else {
      print('Helpdesk creation failed: ${response.statusCode}');
      print('Response: ${response.body}');
      return false;
    }
  }

  Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(keyToken);
    Navigator.pushNamedAndRemoveUntil(
        context, AppRoute.loginScreen, (context) => false);
  }

  @override
  Widget build(BuildContext context) {
    final arguments =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;
    UserModel? userModel = arguments['userModel'] as UserModel?;
    Map<String, dynamic> details =
        arguments['locationDetail'] as Map<String, dynamic>;
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(240.0),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(40),
            bottomRight: Radius.circular(40),
          ),
          child: Column(
            children: [
              AppBar(
                elevation: 0,
                scrolledUnderElevation: 0,
                toolbarHeight: 100,
                foregroundColor:
                    details['color'] == 4294961979 ? kBlack : kWhite,
                backgroundColor: Color(details['color']),
                centerTitle: true,
                title: Text(
                  'Profile',
                  style: textStyleNormal(
                    fontSize: 26,
                    color: kWhite,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                actions: [
                  Padding(
                    padding: const EdgeInsets.only(right: 10.0),
                    child: ScaleTap(
                      onPressed: () async {
                        await CustomDialog.show(
                          context,
                          title: 'Logout',
                          description: 'Are you sure you want to logout?',
                          btnOkOnPress: () async {
                            await logout();
                          },
                          btnOkText: 'Yes',
                          btnCancelOnPress: () {
                            Navigator.pop(context);
                          },
                          btnCancelText: 'No',
                        );
                      },
                      child: const Icon(
                        Icons.logout,
                        color: kRed,
                      ),
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.only(bottom: 20.0),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Color(
                      details['color']), // Set the desired background color
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(40),
                    bottomRight: Radius.circular(40),
                  ), // Set the desired border radius
                  border: Border.all(
                    color: Color(
                      details['color'],
                    ),
                  ),
                ),
                child: Column(
                  children: [
                    const CircleAvatar(
                      backgroundImage: AssetImage(
                          'assets/images/account.png'), // Ganti dengan path gambar Anda
                      radius: 40, // Sesuaikan ukuran radius sesuai kebutuhan
                    ),
                    const SizedBox(width: 10),
                    Text(
                      '${userModel!.firstName} ${userModel.secondName}',
                      style: GoogleFonts.dmSans(
                        fontWeight: FontWeight.bold,
                        color: kWhite,
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(bottom: 50, left: 10, right: 10),
          child: ListView.builder(
              shrinkWrap: true,
              itemCount: profileList.length,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    ListTile(
                      leading: profileListIcon[index],
                      title: Text(
                        profileList[index],
                        style: GoogleFonts.dmSans(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      trailing: const Icon(Icons.keyboard_arrow_right_sharp),
                      // selected: true,
                      onTap: () {
                        if (index == 0) {
                          showAccountInfoDialog(userModel);
                        } else if (index == 1) {
                          showEmailnPassword(userModel);
                        } else if (index == 2) {
                          showListOfVehicle();
                        } else if (index == 3) {
                          Navigator.pushNamed(
                            context,
                            AppRoute.transactionHistoryScreen,
                            arguments: {
                              'locationDetail': details,
                            },
                          );
                        } else if (index == 4) {
                          showSetting();
                        } else if (index == 5) {
                          Share.share(
                              'Hey, check out this app! https://play.google.com/store/apps/details?id=com.example.project');
                        } else if (index == 6) {
                          showhelpcentre();
                        }
                      },
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10.0),
                      child: Divider(
                        color: kBlack,
                        thickness: 0.2,
                      ),
                    ),
                  ],
                );
              }),
        ),
      ),
    );
  }

  void showAccountInfoDialog(UserModel userModel) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: const EdgeInsets.fromLTRB(20, 0, 20, 5),
          title: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'ACCOUNT INFO',
                    style: GoogleFonts.poppins(
                        fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                ],
              ),
            ],
          ),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                Center(
                  child: Text(
                    'Name',
                    style: GoogleFonts.dmSans(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                ),
                const SizedBox(height: 5),
                Center(
                  child: Text(
                    userModel.firstName!,
                    style: GoogleFonts.dmSans(
                      fontSize: 15,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Center(
                  child: Text(
                    'I.D NUMBER',
                    style: GoogleFonts.dmSans(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                ),
                const SizedBox(height: 5),
                Center(
                  child: Text(
                    userModel.idNumber!,
                    style: GoogleFonts.dmSans(
                      fontSize: 15,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Center(
                  child: Text(
                    'PHONE NUMBER',
                    style: GoogleFonts.dmSans(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                ),
                const SizedBox(height: 5),
                Center(
                  child: Text(
                    userModel.phoneNumber!,
                    style: GoogleFonts.dmSans(
                      fontSize: 15,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Center(
                  child: Text(
                    'Email',
                    style: GoogleFonts.dmSans(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                ),
                const SizedBox(height: 5),
                Center(
                  child: Container(
                    width: 170, // Set the desired width
                    decoration: BoxDecoration(
                      color: const Color(
                          0xFFDDDDDD), // Set the desired background color
                      borderRadius: BorderRadius.circular(
                          40), // Set the desired border radius
                    ),
                    child: TextFormField(
                      controller: email,
                      decoration: InputDecoration(
                        labelText: null,
                        hintStyle: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(40),
                        ),
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 5),
                        filled: true,
                        fillColor: Colors.grey,
                      ),
                      textAlign: TextAlign.center,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email';
                        } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+')
                            .hasMatch(value)) {
                          return 'Please enter a valid email address';
                        }
                        return null;
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Center(
                  child: Text(
                    'ADDRESS',
                    style: GoogleFonts.dmSans(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                ),
                const SizedBox(height: 5),
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        userModel.address1!,
                        style: GoogleFonts.dmSans(
                          fontSize: 15,
                        ),
                      ),
                      const SizedBox(width: 5),
                      Text(
                        userModel.address2!,
                        style: GoogleFonts.dmSans(
                          fontSize: 15,
                        ),
                      ),
                      const SizedBox(width: 5),
                      Text(
                        userModel.address3 ?? '',
                        style: GoogleFonts.dmSans(
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                ),
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Text(
                    userModel.postcode!.toString(),
                    style: GoogleFonts.dmSans(
                      fontSize: 15,
                    ),
                  ),
                  Text(
                    ' ${userModel.city!}',
                    style: GoogleFonts.dmSans(
                      fontSize: 15,
                    ),
                  ),
                  Text(
                    ' ${userModel.state!}',
                    style: GoogleFonts.dmSans(
                      fontSize: 15,
                    ),
                  ),
                ])
              ],
            ),
          ),
          actions: <Widget>[
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    onPressed: () async {
                      // if (formKey.currentState?.validate() ?? false) {
                      //   await ProfileResources.updateProfile(
                      //     prefix: '/auth/update',
                      //     body: jsonEncode({
                      //       'email': email.text,
                      //     }),
                      //   );

                      //   Navigator.of(context).pop();
                      // }
                    },
                    child: const Text('Confirm'),
                  ),
                  const SizedBox(
                      width:
                          16), // Add some horizontal spacing between the buttons
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('Cancel'),
                  ),
                ],
              ),
            )
          ],
        );
      },
    );
  }

  void showEmailnPassword(UserModel userModel) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    icon: const Icon(Icons.cancel),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Email & Password',
                    style: GoogleFonts.poppins(
                        fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                ],
              ),
            ],
          ),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10), // Spacer
                Center(
                  child: Text(
                    'EMAIL',
                    style: GoogleFonts.dmSans(
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
                const SizedBox(height: 5),
                Center(
                  child: Text(
                    userModel.email!,
                    style: GoogleFonts.dmSans(
                      fontSize: 15,
                    ),
                  ),
                ),
                const SizedBox(height: 5),
                Center(
                  child: Text(
                    'PASSWORD',
                    style: GoogleFonts.dmSans(
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
                const SizedBox(height: 5),
                Center(
                  child: Text(
                    'CONFIRM PASSWORD',
                    style: GoogleFonts.dmSans(
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            Center(
              child: TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Confirm'),
              ),
            ),
          ],
        );
      },
    );
  }

  void showhelpcentre() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    icon: const Icon(Icons.cancel),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Help Centre',
                    style: GoogleFonts.poppins(
                        fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                ],
              ),
            ],
          ),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                Center(
                  child: SizedBox(
                    child: DropdownButtonFormField<String>(
                      items: <String>[
                        'Season Pass',
                        'Reserve Bay',
                        'Parking',
                        'Enforcement',
                        'Others'
                      ].map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(
                            value,
                            style: GoogleFonts.poppins(),
                          ),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedValue = newValue;
                        });
                      },
                      decoration: InputDecoration(
                        hintText: 'Select Item',
                        hintStyle: const TextStyle(color: Colors.grey),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: const BorderSide(
                                width: 3, color: Colors.black)),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Center(
                    child: SizedBox(
                  child: DropdownButtonFormField<String>(
                    items: pbtMap.keys
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(
                          value,
                          style: GoogleFonts.poppins(
                            fontSize: 10,
                          ),
                        ),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedPBT = newValue;
                      });
                      print('Selected PBT: $selectedPBT');
                    },
                    decoration: InputDecoration(
                      hintText: 'PBT',
                      hintStyle: const TextStyle(color: Colors.grey),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide:
                              const BorderSide(width: 3, color: Colors.black)),
                    ),
                  ),
                )),
                const SizedBox(height: 10),
                SizedBox(
                  width: 800,
                  child: TextFormField(
                    controller: description,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(vertical: 100),
                      hintText: ' Please write here..... ',
                      hintStyle: const TextStyle(color: Colors.grey),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            Center(
              child: TextButton(
                onPressed: () async {
                  bool success = await createhelpdesk();
                  Navigator.of(context).pop();
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text(success ? 'Success' : 'Failure'),
                        content: Text(success
                            ? 'Complaint successfully sent!'
                            : 'Failed to send complaint.'),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text('OK'),
                          ),
                        ],
                      );
                    },
                  );
                },
                child: const Text('Confirm'),
              ),
            ),
          ],
        );
      },
    );
  }

  void showListOfVehicle() {
    print('tolong tgk sini carPlates: $carPlates');
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'List of Vehicle',
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ],
              ),
            ],
          ),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (int i = 0; i < carPlates.length; i++)
                  Column(
                    children: [
                      const SizedBox(height: 10), // Spacer
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  'Car Plate ${i + 1}',
                                  style: GoogleFonts.dmSans(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  carPlates[i].carPlateNumber,
                                  style: GoogleFonts.dmSans(
                                    fontSize: 15,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            icon: const Icon(
                              Icons.delete,
                              size: 15,
                            ),
                            onPressed: () async {
                              _showDeleteConfirmationDialog(carPlates[i]);
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
              ],
            ),
          ),
          actions: <Widget>[
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    onPressed: () {
                      _showAddVehicleDialog(context);
                    },
                    child: const Text('Add No Plate'),
                  ),
                  const SizedBox(
                      width:
                          16), // Add some horizontal spacing between the buttons
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('Cancel'),
                  ),
                ],
              ),
            )
          ],
        );
      },
    );
  }

  void _showAddVehicleDialog(BuildContext context) {
    if (carPlates.length >= 2) {
      _showErrorDialog(context, 'Error', 'Cannot add more than 2 vehicles');
      return;
    }
    bool isMain = false; // Default value for isMain

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              title: const Text('Add Vehicle'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  TextField(
                    controller: carplate,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        isMain = !isMain;
                      });
                    },
                    child: Text(isMain ? 'Unset as Main' : 'Set as Main'),
                  ),
                ],
              ),
              actions: <Widget>[
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      TextButton(
                        onPressed: () {
                          print(
                              'Sending request with isMain: ${isMain ? 1 : 0}'); // Debugging
                          carplatereg(isMain: isMain);
                          Navigator.of(context).pop();
                          showListOfVehicle();
                        },
                        child: const Text('Add'),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text('Cancel'),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showErrorDialog(BuildContext context, String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _showDeleteConfirmationDialog(CarPlate carPlate) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Deletion'),
          content: Text(
              'Are you sure you want to delete the plate number ${carPlate.carPlateNumber}?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                await deleteplate(carPlate.id);
              },
              child: const Text('Confirm'),
            ),
          ],
        );
      },
    );
  }

  void showSetting() {}
}
