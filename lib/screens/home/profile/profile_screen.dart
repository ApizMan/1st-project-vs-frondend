// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
    'PBT Kuantan': 'e2cdf0ae-3d97-4032-b451-3bff0c9853ec',
    'PBT Machang': '942a008f-65a1-4edf-a67a-0509e1c6867d',
    'PBT Kuala Terengganu': 'b7c6f626-c33f-4f08-a9d2-cfe4a49bad47',
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


    if (pbtId == null) {
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
      return true;
    } else {
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
    List<String> profileList = [
      AppLocalizations.of(context)!.aboutMe,
      AppLocalizations.of(context)!.emailPassword,
      AppLocalizations.of(context)!.listOfVehicle,
      AppLocalizations.of(context)!.transactionHistory,
      AppLocalizations.of(context)!.settings,
      AppLocalizations.of(context)!.shareThisApp,
      AppLocalizations.of(context)!.helpCenter,
      AppLocalizations.of(context)!.termAndConditions,
    ];

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
                  AppLocalizations.of(context)!.profile,
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
                          title: AppLocalizations.of(context)!.logout,
                          description:
                              '${AppLocalizations.of(context)!.logoutDesc}?',
                          btnOkOnPress: () async {
                            await logout();
                          },
                          btnOkText: AppLocalizations.of(context)!.yes,
                          btnCancelOnPress: () {
                            Navigator.pop(context);
                          },
                          btnCancelText: AppLocalizations.of(context)!.no,
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
                          'assets/images/account.png'), 
                      radius: 40, 
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
                          Navigator.pushNamed(
                            context,
                            AppRoute.settingsScreen,
                            arguments: {
                              'locationDetail': details,
                            },
                          );
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
                    AppLocalizations.of(context)!.accountInfo,
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
                    AppLocalizations.of(context)!.name,
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
                    AppLocalizations.of(context)!.idNumber,
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
                    Localizations.of(context, AppLocalizations).phoneNumber,
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
                    AppLocalizations.of(context)!.email,
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
                    AppLocalizations.of(context)!.address,
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
                    child: Text(AppLocalizations.of(context)!.confirm),
                  ),
                  const SizedBox(
                      width:
                          16), // Add some horizontal spacing between the buttons
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text(AppLocalizations.of(context)!.cancel),
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
                    AppLocalizations.of(context)!.emailPassword,
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
                    AppLocalizations.of(context)!.email,
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
                    AppLocalizations.of(context)!.password,
                    style: GoogleFonts.dmSans(
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
                const SizedBox(height: 5),
                Center(
                  child: Text(
                    '********',
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
                child: Text(AppLocalizations.of(context)!.confirm),
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
                    AppLocalizations.of(context)!.helpCenter,
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
                        AppLocalizations.of(context)!.seasonPass,
                        AppLocalizations.of(context)!.reserveBays,
                        AppLocalizations.of(context)!.parking,
                        AppLocalizations.of(context)!.enforcement,
                        AppLocalizations.of(context)!.others
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
                        hintText: AppLocalizations.of(context)!.selectItem,
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
                      hintText:
                          ' ${AppLocalizations.of(context)!.pleaseWriteHere}..... ',
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
                child: Text(AppLocalizations.of(context)!.confirm),
              ),
            ),
          ],
        );
      },
    );
  }

  void showListOfVehicle() {
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
                    AppLocalizations.of(context)!.listOfVehicle,
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
                                  '${AppLocalizations.of(context)!.carPlate} ${i + 1}',
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
                    child: Text(AppLocalizations.of(context)!.addPlateNo),
                  ),
                  const SizedBox(
                      width:
                          16), // Add some horizontal spacing between the buttons
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text(AppLocalizations.of(context)!.cancel),
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
      _showErrorDialog(context, AppLocalizations.of(context)!.error,
          AppLocalizations.of(context)!.errorDesc);
      return;
    }
    bool isMain = false; // Default value for isMain

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              title: Text(AppLocalizations.of(context)!.addVehicle),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  TextField(
                    controller: carplate,
                    inputFormatters: [
                      // This ensures that the input is displayed as uppercase
                      FilteringTextInputFormatter.allow(RegExp("[a-zA-Z0-9]")),
                      UpperCaseTextFormatter(),
                    ],
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
                          // Debugging
                          carplatereg(isMain: isMain);
                          Navigator.of(context).pop();
                          showListOfVehicle();
                        },
                        child: Text(AppLocalizations.of(context)!.add),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text(AppLocalizations.of(context)!.cancel),
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
          title: Text(AppLocalizations.of(context)!.confirmDeletion),
          content: Text(
              '${AppLocalizations.of(context)!.confirmDeletionDesc} ${carPlate.carPlateNumber}?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(AppLocalizations.of(context)!.cancel),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                await deleteplate(carPlate.id);
              },
              child: Text(AppLocalizations.of(context)!.confirm),
            ),
          ],
        );
      },
    );
  }
}
