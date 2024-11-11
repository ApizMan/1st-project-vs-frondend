// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_scale_tap/flutter_scale_tap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project/constant.dart';
import 'package:project/models/models.dart';
import 'package:project/resources/resources.dart';
import 'package:project/routes/route_manager.dart';
import 'package:project/screens/home/profile/components/email_password_screen.dart';
import 'package:project/screens/home/profile/components/help_center_screen.dart';
import 'package:project/screens/home/profile/components/vehicle_list_screen.dart';
import 'package:project/theme.dart';
import 'package:project/widget/custom_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:project/screens/home/profile/components/about_me_screen.dart';

//import 'package:line_awesome_flutter/line_awesome_flutter.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({
    super.key,
  });
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

List<String> complaintTypes = [
  'Season Pass',
  'Reserve Bays',
  'Parking',
  'Enforcement',
  'Others',
];

class _ProfileScreenState extends State<ProfileScreen> {
  late final List<PBTModel> pbtModel;

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
    super.initState();
    pbtModel = [];
    _getPBT();
  }

  Future<void> _getPBT() async {
    final data = await PbtResources.getPBT(prefix: '/pbt/');

    if (data != null && mounted) {
      setState(() {
        pbtModel.addAll(
          data
              .map<PBTModel>((item) => PBTModel(
                    id: item['id'],
                    name: item['name'],
                    description: item['description'],
                  ))
              .toList(),
        ); // Add new data
      });
    }
  }

  // final Map<String, String> pbtMap = {
  //   'PBT Kuantan': 'e2cdf0ae-3d97-4032-b451-3bff0c9853ec',
  //   'PBT Machang': '942a008f-65a1-4edf-a67a-0509e1c6867d',
  //   'PBT Kuala Terengganu': 'b7c6f626-c33f-4f08-a9d2-cfe4a49bad47',
  // };

  // Future<bool> createhelpdesk() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   String? token = prefs.getString('token');
  //   String? pbtId = pbtMap[selectedPBT];

  //   if (pbtId == null) {
  //     return false;
  //   }

  //   var url = Uri.parse("$baseUrl/helpdesk/create-helpdesk");
  //   var response = await http.post(
  //     url,
  //     headers: {
  //       'Content-Type': 'application/json',
  //       'Authorization': 'Bearer $token',
  //     },
  //     body: jsonEncode({
  //       'pbt': pbtId,
  //       'description': description.text,
  //     }),
  //   );

  //   if (response.statusCode == 200) {
  //     return true;
  //   } else {
  //     return false;
  //   }
  // }

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
                    color: details['color'] == 4294961979 ? kBlack : kWhite,
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
                      backgroundImage: AssetImage('assets/images/account.png'),
                      radius: 40,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      '${userModel!.firstName} ${userModel.secondName}',
                      style: GoogleFonts.dmSans(
                        fontWeight: FontWeight.bold,
                        color: details['color'] == 4294961979 ? kBlack : kWhite,
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
                          displayAboutMe(context, userModel);
                        } else if (index == 1) {
                          displayEmailPassword(context, userModel, details);
                        } else if (index == 2) {
                          vehicleList(context, userModel);
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
                          helpCenter(context, pbtModel);
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
}
